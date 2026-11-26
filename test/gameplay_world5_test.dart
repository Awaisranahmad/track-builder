// Gameplay test — World 5 Jungle Ruins (levels 49-60).
// Har level apne hal se khela jata hai — hal world5_levels.dart
// ke comments mein likha hai. Harness phase5_tuning_test.dart
// se liya gaya hai (wahi _playScripted / _expectPassed pattern).
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/levels/worlds.dart';
import 'package:track_builder/data/models/level_data.dart';
import 'package:track_builder/data/models/piece_type.dart';
import 'package:track_builder/data/models/player_progress.dart';
import 'package:track_builder/data/save_service.dart';
import 'package:track_builder/game/track_builder_game.dart';
import 'package:track_builder/services/audio_service.dart';
import 'package:track_builder/services/sprite_service.dart';

Future<void> _pumpUntilResult(
  WidgetTester tester,
  TrackBuilderGame game, {
  int maxSteps = 1500,
}) async {
  for (var i = 0; i < maxSteps; i++) {
    await tester.pump(const Duration(milliseconds: 16));
    if (game.phase == GamePhase.result) return;
  }
}

Future<TrackBuilderGame> _makeGame(LevelData level) async {
  SpriteService.testMode = true;
  await SpriteService.preloadAll();
  SharedPreferences.setMockInitialValues({});
  final saveService = await SaveService.create();
  final progress = PlayerProgress();
  return TrackBuilderGame(
    level: level,
    progress: progress,
    saveService: saveService,
    audio: AudioService(testMode: true),
  );
}

Future<void> _pumpGame(WidgetTester tester, TrackBuilderGame game) async {
  await tester.pumpWidget(MaterialApp(home: GameWidget(game: game)));
  for (var i = 0; i < 100 && !game.isLoaded; i++) {
    await tester.pump(const Duration(milliseconds: 16));
  }
  await tester.pump();
}

/// Scripted drive — waqt par gas/brake badlo.
/// Script: (atSeconds, gas, brake) — waqt GO ke baad se.
Future<TrackBuilderGame> _playScripted(
  WidgetTester tester,
  LevelData level,
  List<({Vector2 tap, PieceType type})> placements,
  List<({double at, bool gas, bool brake})> script,
) async {
  final game = await _makeGame(level);
  await _pumpGame(tester, game);
  expect(game.phase, GamePhase.build);
  for (final placement in placements) {
    final piece = game.buildManager.placeAt(placement.tap, placement.type);
    expect(
      piece,
      isNotNull,
      reason: 'Level ${level.id}: ${placement.type.label} '
          'place nahi hua at ${placement.tap}',
    );
  }
  await tester.pump();
  game.startDrive();
  expect(game.phase, GamePhase.drive);
  if (script.isEmpty) {
    game.setGas(true);
    await _pumpUntilResult(tester, game);
    return game;
  }
  var scriptIndex = 0;
  var elapsed = 0.0;
  for (var i = 0; i < 1500; i++) {
    while (scriptIndex < script.length &&
        script[scriptIndex].at <= elapsed) {
      game.setGas(script[scriptIndex].gas);
      game.setBrake(script[scriptIndex].brake);
      scriptIndex++;
    }
    await tester.pump(const Duration(milliseconds: 16));
    elapsed += 0.016;
    if (game.phase == GamePhase.result) return game;
  }
  return game;
}

/// Gas-only drive — World 5 ke saare levels isi se pass hote hain.
Future<TrackBuilderGame> _play(
  WidgetTester tester,
  LevelData level,
  List<({Vector2 tap, PieceType type})> placements,
) async {
  return _playScripted(
    tester,
    level,
    placements,
    const [(at: 0, gas: true, brake: false)],
  );
}

void _expectPassed(TrackBuilderGame game, LevelData level) {
  expect(game.phase, GamePhase.result, reason: 'Level ${level.id}: waqt khatam');
  final result = game.resultNotifier.value;
  expect(result, isNotNull);
  expect(result!.passed, isTrue,
      reason: 'Level ${level.id} fail: ${result.failReason}');
  expect(
    result.coinsCollected,
    result.totalCoins,
    reason: 'Level ${level.id}: saare coins nahi mile '
        '(${result.coinsCollected}/${result.totalCoins})',
  );
  expect(result.stars, greaterThanOrEqualTo(2));
}

void main() {
  group('World 5 — har level apne hal se pass hota hai (Jungle Ruins)', () {
    testWidgets('Level 49 Ruins Entrance — road + road + ramp', (tester) async {
      final level = levelById(49)!;
      final game = await _play(tester, level, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(10.2, 9.3), type: PieceType.road),
        (tap: Vector2(11.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 50 Bounce! — spring se ledge par', (tester) async {
      final level = levelById(50)!;
      final game = await _play(tester, level, [
        (tap: Vector2(6.2, 9.3), type: PieceType.spring),
      ]);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 51 Double Bounce — do springs, do ledges',
        (tester) async {
      final level = levelById(51)!;
      final game = await _play(tester, level, [
        (tap: Vector2(4.2, 9.3), type: PieceType.spring),
        (tap: Vector2(10.2, 8.3), type: PieceType.spring),
      ]);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 52 Falling Rocks — road + bridge roof', (tester) async {
      final level = levelById(52)!;
      final game = await _play(tester, level, [
        (tap: Vector2(4.2, 9.3), type: PieceType.road),
        (tap: Vector2(8.2, 7.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 53 Temple Steps — teen ramps, teen steps',
        (tester) async {
      final level = levelById(53)!;
      final game = await _play(tester, level, [
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(9.5, 7.5), type: PieceType.ramp),
        (tap: Vector2(14.5, 6.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 54 The Well — spring se hawa wale coins, phir kunwan',
        (tester) async {
      final level = levelById(54)!;
      final game = await _play(tester, level, [
        (tap: Vector2(7.2, 9.3), type: PieceType.spring),
      ]);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 55 Vine Swing — ramp jump + spring + bridge landing',
        (tester) async {
      final level = levelById(55)!;
      final game = await _play(tester, level, [
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(8.2, 9.3), type: PieceType.spring),
        (tap: Vector2(11.2, 7.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 56 Crumble Stone — gas hi rakho, ruko mat',
        (tester) async {
      final level = levelById(56)!;
      final game = await _play(tester, level, []);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 2);
    });

    testWidgets('Level 57 Rock Rain — bridge roof + spring escape',
        (tester) async {
      final level = levelById(57)!;
      final game = await _play(tester, level, [
        (tap: Vector2(7.2, 7.3), type: PieceType.bridge),
        (tap: Vector2(12.2, 9.3), type: PieceType.spring),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 58 Hidden Coins — spring up, drop down, low coins',
        (tester) async {
      final level = levelById(58)!;
      final game = await _play(tester, level, [
        (tap: Vector2(4.2, 9.3), type: PieceType.spring),
      ]);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 2);
    });

    testWidgets('Level 59 Temple Run — ramp + ramp + crumble + spring',
        (tester) async {
      final level = levelById(59)!;
      final game = await _play(tester, level, [
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(9.5, 7.5), type: PieceType.ramp),
        (tap: Vector2(13.2, 7.3), type: PieceType.spring),
      ]);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });

    testWidgets('Level 60 Ruins Exam — ramp + spring + bridge + rockfall',
        (tester) async {
      final level = levelById(60)!;
      final game = await _play(tester, level, [
        (tap: Vector2(3.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(6.2, 8.3), type: PieceType.spring),
        (tap: Vector2(14.2, 6.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, level);
      expect(game.buildManager.remainingCount(PieceType.road), 1);
    });
  });
}
