// Gameplay test — World 6 Space Station (levels 61-72).
// Har level apne hal se khela jata hai — hal world6_levels.dart
// ke comments mein likha hai. Saare levels gas-only pass hote
// hain (probes se verify); see-saw aur gate levels mein bhi
// gas-only kaafi hai.
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
  group('World 6 — har level apne hal se pass hota hai (Space Station)', () {
    testWidgets('Level 61 Zero-G — ramp + road landing', (tester) async {
      final game = await _playLevel(tester, 61, [
        (tap: Vector2(4.0, 8.5), type: PieceType.ramp),
        (tap: Vector2(6.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 61);
    });

    testWidgets('Level 62 Ceiling Drive — road runway + magnet float',
        (tester) async {
      final game = await _playLevel(tester, 62, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(7.5, 8.0), type: PieceType.magnet),
      ]);
      _expectPassedWithAllCoins(game, 62);
    });

    testWidgets('Level 63 Float and Drop — ramp jump, lower deck',
        (tester) async {
      final game = await _playLevel(tester, 63, [
        (tap: Vector2(6.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 63);
    });

    testWidgets('Level 64 Airlock — do gates, gas-only', (tester) async {
      final game = await _playLevel(tester, 64, []);
      _expectPassedWithAllCoins(game, 64);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
      expect(game.buildManager.remainingCount(PieceType.booster), 1);
    });

    testWidgets('Level 65 Orbit — magnet, high deck se float down',
        (tester) async {
      final game = await _playLevel(tester, 65, [
        (tap: Vector2(7.5, 8.0), type: PieceType.magnet),
      ]);
      _expectPassedWithAllCoins(game, 65);
    });

    testWidgets('Level 66 Balance Point — seesaw', (tester) async {
      final game = await _playLevel(tester, 66, [
        (tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
      ]);
      _expectPassedWithAllCoins(game, 66);
    });

    testWidgets('Level 67 Tip and Launch — seesaw + ramp', (tester) async {
      final game = await _playLevel(tester, 67, [
        (tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
        (tap: Vector2(12.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 67);
    });

    testWidgets('Level 68 Low-G Seesaw — seesaw + road strip',
        (tester) async {
      final game = await _playLevel(tester, 68, [
        (tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
        (tap: Vector2(11.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 68);
    });

    testWidgets('Level 69 Gravity Flip — do magnets + road runway',
        (tester) async {
      final game = await _playLevel(tester, 69, [
        (tap: Vector2(3.2, 9.3), type: PieceType.road),
        (tap: Vector2(6.5, 8.0), type: PieceType.magnet),
        (tap: Vector2(13, 8.5), type: PieceType.magnet),
      ]);
      _expectPassedWithAllCoins(game, 69);
    });

    testWidgets('Level 70 Asteroid Field — booster + ramp, rockfall',
        (tester) async {
      final game = await _playLevel(tester, 70, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(5.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 70);
    });

    testWidgets('Level 71 Docking Bay — road pad + ramp', (tester) async {
      final game = await _playLevel(tester, 71, [
        (tap: Vector2(9.2, 9.3), type: PieceType.road),
        (tap: Vector2(6.0, 8.5), type: PieceType.ramp),
      ]);
      _expectPassedWithAllCoins(game, 71);
    });

    testWidgets('Level 72 Station Exam — seesaw + ramp + magnet + road',
        (tester) async {
      final game = await _playLevel(tester, 72, [
        (tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
        (tap: Vector2(12.0, 8.5), type: PieceType.ramp),
        (tap: Vector2(15.5, 8.0), type: PieceType.magnet),
        (tap: Vector2(17.2, 9.3), type: PieceType.road),
      ]);
      _expectPassedWithAllCoins(game, 72);
    });
  });
}
