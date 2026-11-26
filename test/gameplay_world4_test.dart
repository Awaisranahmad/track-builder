// Gameplay test — World 4 Night City (levels 37-48).
// Har level apne hal se khela jata hai — hal world4_levels.dart
// ke comments mein likha hai. Harness phase5_tuning_test.dart se liya gaya.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:track_builder/data/levels/world4_levels.dart';
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

/// Scripted drive — waqt par gas/brake badlo.
/// Lift wali levels mein "wait" karna parta hai (design doc:
/// "build to the lift, wait, ride, drive off").
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

/// Lift wali levels ka drive script — tuning level 904 se liya gaya:
/// gas se lift par charho, coast kar ke ride karo, phir gas se utro.
const List<({double at, bool gas, bool brake})> _liftScript = [
  (at: 0, gas: true, brake: false),
  (at: 1.2, gas: false, brake: false),
  (at: 3.5, gas: true, brake: false),
];

void main() {
  group('World 4 — har level apne hal se pass hota hai (Night City)', () {
    testWidgets('Level 37 Rooftops — road + ramp + road', (tester) async {
      final game = await _play(tester, level37, [
        (tap: Vector2(5.2, 9.3), type: PieceType.road),
        (tap: Vector2(6.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(12.2, 9.3), type: PieceType.road),
      ]);
      _expectPassed(game, level37);
    });

    testWidgets('Level 38 The Lift — lift par sawaar, upar utro',
        (tester) async {
      final game = await _playScripted(tester, level38, [], _liftScript);
      _expectPassed(game, level38);
      expect(game.liftCount, 1);
    });

    testWidgets('Level 39 Neon Alley — ramp se dumpster ke upar',
        (tester) async {
      final game = await _play(tester, level39, [
        (tap: Vector2(9.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level39);
    });

    testWidgets('Level 40 Loop the Loop — booster + loop', (tester) async {
      final game = await _play(tester, level40, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(10, 7.0), type: PieceType.loop),
      ]);
      _expectPassed(game, level40);
    });

    testWidgets('Level 41 Loop + Landing — loop, phir bridge',
        (tester) async {
      final game = await _play(tester, level41, [
        (tap: Vector2(10, 7.0), type: PieceType.loop),
        (tap: Vector2(13.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, level41);
    });

    testWidgets('Level 42 Traffic Lights — gate khud khulta hai',
        (tester) async {
      final game = await _play(tester, level42, []);
      _expectPassed(game, level42);
      expect(game.gateCount, 1);
    });

    testWidgets('Level 43 Parking Garage — road neeche, ramp upar',
        (tester) async {
      final game = await _play(tester, level43, [
        (tap: Vector2(6.2, 9.3), type: PieceType.road),
        (tap: Vector2(12.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level43);
    });

    testWidgets('Level 44 Billboard Jump — booster + ramp, 6m gap',
        (tester) async {
      final game = await _play(tester, level44, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level44);
    });

    testWidgets('Level 45 Double Loop — ek boost, do loops',
        (tester) async {
      final game = await _play(tester, level45, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(7, 7.0), type: PieceType.loop),
        (tap: Vector2(13, 7.0), type: PieceType.loop),
      ]);
      _expectPassed(game, level45);
    });

    testWidgets('Level 46 Rush Hour — lift, loop, gate', (tester) async {
      final game = await _playScripted(tester, level46, [
        (tap: Vector2(14, 6.0), type: PieceType.loop),
      ], _liftScript);
      _expectPassed(game, level46);
      expect(game.liftCount, 1);
      expect(game.gateCount, 1);
    });

    testWidgets('Level 47 Blackout — bridge par se guzro', (tester) async {
      final game = await _play(tester, level47, [
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, level47);
    });

    testWidgets('Level 48 City Exam — lift, loop, road, gate',
        (tester) async {
      final game = await _playScripted(tester, level48, [
        (tap: Vector2(8.2, 8.3), type: PieceType.booster),
        (tap: Vector2(13.5, 6.0), type: PieceType.loop),
        (tap: Vector2(14.2, 8.3), type: PieceType.road),
      ], _liftScript);
      _expectPassed(game, level48);
      expect(game.liftCount, 1);
      expect(game.gateCount, 1);
    });
  });
}
