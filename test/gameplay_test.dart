// Gameplay test — levels ko headless khel kar pass karna.
// Yehi Phase 2 ka "done" hai: World 1 shuru se aakhir tak khela ja sake.
// Phase 3 mein World 2 aur 3 bhi yahin khele jate hain.
// Har level ka hal (solution placements) world*_levels.dart ke
// comments mein likha hai — test wahi hal khelta hai.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/levels/world1_levels.dart';
import 'package:track_builder/data/levels/worlds.dart';
import 'package:track_builder/data/models/piece_type.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/game/components/track_piece.dart';
import 'package:track_builder/game/track_builder_game.dart';
import 'package:track_builder/services/audio_service.dart';
import 'package:track_builder/services/sprite_service.dart';

/// Game ko 16ms ke steps mein chalao, jab tak result na aaye ya waqt khatam.
Future<void> _pumpUntilResult(
  WidgetTester tester,
  TrackBuilderGame game, {
  int maxSteps = 1200,
}) async {
  for (var i = 0; i < maxSteps; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    if (game.phase == GamePhase.result) return;
  }
}

Future<TrackBuilderGame> _makeGame(int levelId) async {
  // Test mode: asal PNG decode nahi — placeholder sprites.
  // (Is VM ke tester mein decode ke baad frame atak jata hai.)
  SpriteService.testMode = true;
  await SpriteService.preloadAll();
  SharedPreferences.setMockInitialValues({});
  final saveService = await SaveService.create();
  final progress = PlayerProgress();
  final game = TrackBuilderGame(
    level: levelById(levelId)!,
    progress: progress,
    saveService: saveService,
    // Tests mein audio nahi bajta — testMode no-op hai.
    audio: AudioService(testMode: true),
  );
  return game;
}

/// Ek level ko us ke hal se khelo: pieces lagao, GO, gas.
/// Wapas: khela hua game (result check karne ke liye).
/// GameWidget pump karo aur game ka onLoad (sprites) mukammal hone do.
/// Phase 4 se onLoad async hai — ek pump kaafi nahi.
/// (await game.toBeLoaded() yahan deadlock karta hai — mount ko frames chahiye.)
Future<void> _pumpGame(WidgetTester tester, TrackBuilderGame game) async {
  await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
  for (var i = 0; i < 100 && !game.isLoaded; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.pump();
}

Future<TrackBuilderGame> _playLevel(
  WidgetTester tester,
  int levelId,
  List<({Vector2 tap, PieceType type})> placements,
) async {
  return _playLevelRotations(
    tester,
    levelId,
    placements
        .map((p) => (tap: p.tap, type: p.type, rotations: 0))
        .toList(),
  );
}

/// _playLevel jaisa, lekin kuch pieces ko rotate bhi karo —
/// dhalwan wale levels (L17, L21) mein ramp +30° chahiye hota hai
/// (2 rotations: -30° se +15° se +30°).
Future<TrackBuilderGame> _playLevelRotations(
  WidgetTester tester,
  int levelId,
  List<({Vector2 tap, PieceType type, int rotations})> placements,
) async {
  final game = await _makeGame(levelId);
  await _pumpGame(tester, game);

  expect(game.phase, GamePhase.build);

  for (final placement in placements) {
    final piece = game.buildManager.placeAt(placement.tap, placement.type);
    expect(
      piece,
      isNotNull,
      reason: 'Level $levelId: ${placement.type.label} '
          'place nahi hua at ${placement.tap}',
    );
  }
  await tester.pump(); // pieces ke body banne do — rotate ko body chahiye
  for (final placement in placements) {
    for (var i = 0; i < placement.rotations; i++) {
      expect(
        game.buildManager.rotateAt(placement.tap),
        isTrue,
        reason: 'Level $levelId: rotate nahi hua at ${placement.tap}',
      );
    }
  }
  await tester.pump(); // rotate lagne do

  game.startDrive();
  expect(game.phase, GamePhase.drive);

  game.setGas(true);
  await _pumpUntilResult(tester, game);
  return game;
}

/// Pass hone ki check — result + saare coins (coin star bhi).
void _expectPassedWithAllCoins(TrackBuilderGame game, int levelId) {
  expect(game.phase, GamePhase.result, reason: 'Level $levelId: waqt khatam');
  final result = game.resultNotifier.value;
  expect(result, isNotNull);
  expect(result!.passed, isTrue, reason: 'Level $levelId fail: '
      '${result.failReason}');
  expect(
    result.coinsCollected,
    result.totalCoins,
    reason: 'Level $levelId: saare coins nahi mile '
        '(${result.coinsCollected}/${result.totalCoins})',
  );
  expect(result.stars, greaterThanOrEqualTo(2));
}

void main() {
  group('Level 1 — poora loop', () {
    testWidgets('road lagao, GO, gas — gari finish tak pahunchti hai',
        (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      expect(game.phase, GamePhase.build);

      // Gap par road lagao — tap point (4.2, 9.3) → top-left snap (5, 9).
      final piece = game.buildManager.placeAt(
        Vector2(4.2, 9.3),
        PieceType.road,
      );
      expect(piece, isNotNull);
      await tester.pump(); // piece ka body banne do
      expect(game.buildManager.remainingCount(PieceType.road), 0);

      game.startDrive();
      expect(game.phase, GamePhase.drive);

      game.setGas(true);
      await _pumpUntilResult(tester, game);

      _expectPassedWithAllCoins(game, 1);
    });

    testWidgets('road lagaye baghair gari khaai mein girti hai',
        (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      await tester.pump(); // gari ka body banne do
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.phase, GamePhase.result);
      final result = game.resultNotifier.value;
      expect(result, isNotNull);
      expect(result!.passed, isFalse);
      expect(result.failReason, 'fall');
      expect(result.stars, 0);
    });

    testWidgets('retry par build waisa hi rehta hai', (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump(); // piece ka body banne do
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);
      expect(game.phase, GamePhase.result);

      game.retry();
      expect(game.phase, GamePhase.build);
      // Road abhi bhi laga hua hai — dobara lagane ki zaroorat nahi.
      expect(game.buildManager.placedPieces.length, 1);
      expect(game.buildManager.remainingCount(PieceType.road), 0);
    });

    testWidgets('Level 1 pass hone par progress save hoti hai',
        (tester) async {
      SharedPreferences.setMockInitialValues({});
      final saveService = await SaveService.create();
      final progress = PlayerProgress();
      final game = TrackBuilderGame(
        level: level1,
        progress: progress,
        saveService: saveService,
        audio: AudioService(testMode: true),
      );
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump(); // piece ka body banne do
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.resultNotifier.value?.passed, isTrue);
      // Save async hota hai — thoda waqt do.
      await tester.pump(const Duration(milliseconds: 200));
      final loaded = saveService.loadProgress();
      expect(loaded.starsForLevel(1), greaterThanOrEqualTo(1));
      expect(loaded.isLevelUnlocked(2), isTrue);
    });
  });

  group('World 1 — har level apne hal se pass hota hai', () {
    testWidgets('Level 2 Two Gaps — do roads', (tester) async {
      final game = await _playLevel(tester, 2, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(10.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 2);
    });

    testWidgets('Level 3 Coin Line — ek road, arc coins', (tester) async {
      final game = await _playLevel(tester, 3, [
        (tap: Vector2(5.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 3);
    });

    testWidgets('Level 4 Downhill — road, upar se neeche', (tester) async {
      final game = await _playLevel(tester, 4, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 4);
    });

    testWidgets('Level 5 Ramp Up — road + ramp jump', (tester) async {
      final game = await _playLevel(tester, 5, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(6.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 5);
    });

    testWidgets('Level 6 Angle It — road + ramp, unchi ledge', (tester) async {
      final game = await _playLevel(tester, 6, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(6.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 6);
    });

    testWidgets('Level 7 Too Fast — sirf ramp, upar se jump', (tester) async {
      final game = await _playLevel(tester, 7, [
        (tap: Vector2(4.5, 7.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 7);
    });

    testWidgets('Level 8 Step Up, Step Down — road, ramp, road',
        (tester) async {
      final game = await _playLevel(tester, 8, [
        (tap: Vector2(5.2, 9.3), type: PieceType.road),
        (tap: Vector2(6.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(12.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 8);
    });

    testWidgets('Level 9 Bridge the Gap — bridge 4m nadi par', (tester) async {
      final game = await _playLevel(tester, 9, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 9);
      // Road spare rehta hai — tray mein 1 road baaki.
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 10 Bridge + Jump — bridge phir ramp', (tester) async {
      final game = await _playLevel(tester, 10, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(11.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 10);
    });

    testWidgets('Level 11 Almost Nothing — road + bridge, ramp spare',
        (tester) async {
      final game = await _playLevel(tester, 11, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(12.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 11);
      // Ramp istemal nahi hua — efficiency lesson.
      expect(game.buildManager.remainingCount(PieceType.ramp), 1);
    });

    testWidgets('Level 12 Hills Exam — road, bridge, ramp',
        (tester) async {
      final game = await _playLevel(tester, 12, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(11.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(14.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 12);
    });
  });

  group('World 2 — har level apne hal se pass hota hai (sand)', () {
    testWidgets('Level 13 First Dune — do roads, uncha start', (tester) async {
      final game = await _playLevel(tester, 13, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(10.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 13);
    });

    testWidgets('Level 14 Long Crossing — bridge 4m canyon par',
        (tester) async {
      final game = await _playLevel(tester, 14, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 14);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 15 Cactus Alley — road + ramp, block ke upar',
        (tester) async {
      final game = await _playLevel(tester, 15, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(8.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 15);
    });

    testWidgets('Level 16 Half Pipe — do ramps, valley ke andar-bahar',
        (tester) async {
      final game = await _playLevel(tester, 16, [
        (tap: Vector2(5.0, 8.5), type: PieceType.ramp),
        (tap: Vector2(11, 9.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 16);
    });

    testWidgets('Level 17 Soft Landing — road, 0.5m drop neeche',
        (tester) async {
      final game = await _playLevel(tester, 17, [
        (tap: Vector2(5.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 17);
    });

    testWidgets('Level 18 Three Bridges — bridge, bridge, road',
        (tester) async {
      final game = await _playLevel(tester, 18, [
        (tap: Vector2(3.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(9.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(15.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 18);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 19 Rock Block — road + ramp, pathar ke upar',
        (tester) async {
      final game = await _playLevel(tester, 19, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(9.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 19);
    });

    testWidgets('Level 20 Dune Surf — seedhiyan neeche, ek road',
        (tester) async {
      final game = await _playLevel(tester, 20, [
        (tap: Vector2(12.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 20);
    });

    testWidgets('Level 21 The Long Way Down — bridge, 0.5m drop neeche',
        (tester) async {
      final game = await _playLevel(tester, 21, [
        (tap: Vector2(5.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 21);
    });

    testWidgets('Level 22 Mirage — road chhote gap, bridge bade gap',
        (tester) async {
      final game = await _playLevel(tester, 22, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(10.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 22);
      expect(game.buildManager.remainingCount(PieceType.ramp), 1);
    });

    testWidgets('Level 23 Sandstorm Run — road, bridge, road',
        (tester) async {
      final game = await _playLevel(tester, 23, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(9.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(16.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 23);
      expect(game.buildManager.remainingCount(PieceType.ramp), 1);
    });

    testWidgets('Level 24 Dunes Exam — bridge, road, ramp jump ledge par',
        (tester) async {
      final game = await _playLevel(tester, 24, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(10.2, 9.3), type: PieceType.road),
        (tap: Vector2(14.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 24);
      expect(game.buildManager.remainingCount(PieceType.ramp), 1);
    });
  });

  group('World 3 — har level apne hal se pass hota hai (ice)', () {
    testWidgets('Level 25 First Ice — ek road, barf par slide',
        (tester) async {
      final game = await _playLevel(tester, 25, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 25);
    });

    testWidgets('Level 26 Brake Early — road, chhota platform',
        (tester) async {
      final game = await _playLevel(tester, 26, [
        (tap: Vector2(5.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 26);
    });

    testWidgets('Level 27 Boost! — booster + ramp, 6m gap', (tester) async {
      final game = await _playLevel(tester, 27, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(5.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 27);
    });

    testWidgets('Level 28 Ice Ice Baby — bridge barf par', (tester) async {
      final game = await _playLevel(tester, 28, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 28);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 29 Too Much Boost — booster + ramp, deewar wala finish',
        (tester) async {
      final game = await _playLevel(tester, 29, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(5.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 29);
    });

    testWidgets('Level 30 Pine Forest — road + ramp, block ke upar',
        (tester) async {
      final game = await _playLevel(tester, 30, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(9.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 30);
    });

    testWidgets('Level 31 Frozen Waterfall — booster + ramp, unchi ledge',
        (tester) async {
      final game = await _playLevel(tester, 31, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(5.5, 7.0), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 31);
    });

    testWidgets('Level 32 Whiteout — bridge + road', (tester) async {
      final game = await _playLevel(tester, 32, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(10.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 32);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 33 Double Boost — do booster, do ramp',
        (tester) async {
      final game = await _playLevel(tester, 33, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(10.2, 9.3), type: PieceType.booster),
        (tap: Vector2(13.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 33);
    });

    testWidgets('Level 34 Thin Ice — sirf bridge', (tester) async {
      final game = await _playLevel(tester, 34, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 34);
    });

    testWidgets('Level 35 Avalanche Alley — road, ramp jump, road',
        (tester) async {
      final game = await _playLevel(tester, 35, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(10.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 35);
    });

    testWidgets('Level 36 Peaks Exam — bridge, booster, ramp',
        (tester) async {
      final game = await _playLevel(tester, 36, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(8.2, 9.3), type: PieceType.booster),
        (tap: Vector2(11.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 36);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });
  });

  group('Booster piece', () {
    testWidgets('booster zameen se flush baithta hai', (tester) async {
      final game = await _makeGame(27);
      await _pumpGame(tester, game);

      final booster = game.buildManager.placeAt(
        Vector2(3.2, 9.3),
        PieceType.booster,
      );
      expect(booster, isNotNull);
      await tester.pump();

      expect(booster!.pieceCenter.x, 3.5);
      expect(booster.pieceCenter.y, closeTo(9.15, 0.001));
      expect(booster.body.angle, 0);
      expect(game.buildManager.remainingCount(PieceType.booster), 0);
    });

    testWidgets('booster par se guzre to raftaar barhti hai', (tester) async {
      final game = await _makeGame(27);
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(3.2, 9.3), PieceType.booster);
      await tester.pump(); // piece ka body banne do
      game.startDrive();
      game.setGas(true);

      // 2 second drive karo — booster ke upar se guzarna chahiye.
      for (var i = 0; i < 125; i++) {
        await tester.pump(const Duration(milliseconds: 16));
        if (game.car.speed > 5.0) break;
      }
      // Booster target 6.5 m/s — normal gas se sirf ~3 m/s milti hai.
      expect(game.car.speed, greaterThan(5.0));
    });

    testWidgets('booster baghair jump 6m gap paar nahi hota', (tester) async {
      final game = await _makeGame(27);
      await _pumpGame(tester, game);

      // Sirf ramp — booster nahi.
      game.buildManager.placeAt(Vector2(5.5, 8.5), PieceType.ramp);
      await tester.pump();
      game.startDrive();
      game.setGas(true);
      await _pumpUntilResult(tester, game);

      expect(game.phase, GamePhase.result);
      final result = game.resultNotifier.value;
      expect(result, isNotNull);
      expect(result!.passed, isFalse);
    });
  });

  group('Build system', () {
    testWidgets('undo tray mein piece wapas karta hai', (tester) async {
      final game = await _makeGame(2);
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      game.buildManager.placeAt(Vector2(10.2, 9.3), PieceType.road);
      await tester.pump(); // pieces ke body banne do
      expect(game.buildManager.remainingCount(PieceType.road), 0);

      expect(game.buildManager.undo(), isTrue);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
      expect(game.buildManager.placedPieces.length, 1);
    });

    testWidgets('tray khaali ho to piece nahi lagta', (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      game.buildManager.placeAt(Vector2(4.2, 9.3), PieceType.road);
      await tester.pump(); // piece ka body banne do
      final second = game.buildManager.placeAt(
        Vector2(10.2, 9.3),
        PieceType.road,
      );
      expect(second, isNull);
    });

    testWidgets('ramp ka angle upar ki taraf hota hai', (tester) async {
      final game = await _makeGame(1);
      await _pumpGame(tester, game);

      final ramp = TrackPiece(
        type: PieceType.ramp,
        pieceCenter: Vector2(10, 8),
      );
      game.world.add(ramp);
      await tester.pump();

      // Ramp upar ki taraf — body ka angle negative hona chahiye.
      expect(ramp.body.angle, lessThan(0));
      expect(ramp.body.angle, greaterThan(-1.0));
    });

    testWidgets('bridge zameen se flush baithta hai', (tester) async {
      final game = await _makeGame(9);
      await _pumpGame(tester, game);

      // Tap (4.2, 9.3) → centre (6, 9.15), 4m lamba, top y=9.0.
      final bridge = game.buildManager.placeAt(
        Vector2(4.2, 9.3),
        PieceType.bridge,
      );
      expect(bridge, isNotNull);
      await tester.pump();

      expect(bridge!.pieceCenter.x, 6.0);
      expect(bridge.pieceCenter.y, closeTo(9.15, 0.001));
      expect(bridge.body.angle, 0);
      expect(game.buildManager.remainingCount(PieceType.bridge), 0);
    });
  });
}
