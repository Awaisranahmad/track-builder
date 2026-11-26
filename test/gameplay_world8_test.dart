// Gameplay test — World 8 Sky Islands (levels 85-96, finale).
// Har level apne hal se khela jata hai — hal world8_levels.dart
// ke comments mein likha hai.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/levels/worlds.dart';
import 'package:track_builder/data/models/piece_type.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/game/track_builder_game.dart';
import 'package:track_builder/services/audio_service.dart';
import 'package:track_builder/services/sprite_service.dart';

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
  SpriteService.testMode = true;
  await SpriteService.preloadAll();
  SharedPreferences.setMockInitialValues({});
  final saveService = await SaveService.create();
  final progress = PlayerProgress();
  final game = TrackBuilderGame(
    level: levelById(levelId)!,
    progress: progress,
    saveService: saveService,
    audio: AudioService(testMode: true),
  );
  return game;
}

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
  await tester.pump();
  game.startDrive();
  expect(game.phase, GamePhase.drive);

  game.setGas(true);
  await _pumpUntilResult(tester, game);
  return game;
}

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
  group('World 8 — har level apne hal se pass hota hai (Sky Islands)', () {
    testWidgets('Level 85 First Island — bridge + road', (tester) async {
      final game = await _playLevel(tester, 85, [
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(14.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 85);
      expect(game.buildManager.remainingCount(PieceType.ramp), 1);
    });

    testWidgets('Level 86 Tailwind — ramp jump, tailwind', (tester) async {
      final game = await _playLevel(tester, 86, [
        (tap: Vector2(5.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 86);
    });

    testWidgets('Level 87 Headwind — booster + ramp, headwind',
        (tester) async {
      final game = await _playLevel(tester, 87, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 87);
    });

    testWidgets('Level 88 Island Hop — spring + do roads', (tester) async {
      final game = await _playLevel(tester, 88, [
        (tap: Vector2(6.2, 9.3), type: PieceType.spring),
        (tap: Vector2(12.2, 6.3), type: PieceType.road),
        (tap: Vector2(16.2, 6.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 88);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 89 Cloud Loop — booster + loop, headwind exit',
        (tester) async {
      final game = await _playLevel(tester, 89, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(9, 7.0), type: PieceType.loop),
      ]);
      _expectPassedWithAllCoins(game, 89);
    });

    testWidgets('Level 90 Sky Seesaw — seesaw, tailwind', (tester) async {
      final game = await _playLevel(tester, 90, [
        (tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
      ]);
      _expectPassedWithAllCoins(game, 90);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 91 Zero-G Sky — ramp + magnet, booster nahi',
        (tester) async {
      final game = await _playLevel(tester, 91, [
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(8, 8.0), type: PieceType.magnet),
      ]);
      _expectPassedWithAllCoins(game, 91);
    });

    testWidgets('Level 92 Storm Run — booster + bridge + road',
        (tester) async {
      final game = await _playLevel(tester, 92, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(14.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 92);
    });

    testWidgets('Level 93 Almost Nothing II — road + ramp jump',
        (tester) async {
      final game = await _playLevel(tester, 93, [
        (tap: Vector2(8.2, 9.3), type: PieceType.road),
        (tap: Vector2(10.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 93);
    });

    testWidgets('Level 94 Every Piece — booster + loop + bridge',
        (tester) async {
      final game = await _playLevel(tester, 94, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(8, 7.0), type: PieceType.loop),
        (tap: Vector2(13.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 94);
    });

    testWidgets('Level 95 The Long Fall — ramp jump, 0.5m ledge',
        (tester) async {
      final game = await _playLevel(tester, 95, [
        (tap: Vector2(6.5, 8.0), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 95);
      expect(game.buildManager.remainingCount(PieceType.spring), 1);
    });

    testWidgets('Level 96 Master Builder — booster + loop + bridge',
        (tester) async {
      final game = await _playLevel(tester, 96, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(8, 7.0), type: PieceType.loop),
        (tap: Vector2(13.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassedWithAllCoins(game, 96);
    });
  });
}
