// Gameplay test — World 7 Volcano (levels 73-84).
// Har level apne hal se khela jata hai — hal world7_levels.dart
// ke comments mein likha hai. Harness phase5_tuning_test.dart se
// liya gaya (_playScripted / _expectPassed).
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

Future<TrackBuilderGame> _play(
  WidgetTester tester,
  LevelData level,
  List<({Vector2 tap, PieceType type})> placements, {
  bool gas = true,
}) async {
  return _playScripted(
    tester,
    level,
    placements,
    const [(at: 0, gas: true, brake: false)],
    gas: gas,
  );
}

/// Scripted drive — waqt par gas/brake badlo.
/// Script: (atSeconds, gas, brake) — waqt GO ke baad se.
Future<TrackBuilderGame> _playScripted(
  WidgetTester tester,
  LevelData level,
  List<({Vector2 tap, PieceType type})> placements,
  List<({double at, bool gas, bool brake})> script, {
  bool gas = true,
}) async {
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
    game.setGas(gas);
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

void main() {
  group('World 7 — har level apne hal se pass hota hai (Volcano)', () {
    testWidgets('Level 73 Lava Line — bridge over lava', (tester) async {
      final level = levelById(73)!;
      final game = await _play(tester, level, [
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 74 Hot Bridge — sinking bridge + support road',
        (tester) async {
      final level = levelById(74)!;
      final game = await _play(tester, level, [
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(6.2, 9.3), type: PieceType.road),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 75 Gate Keeper — booster + road, two gates',
        (tester) async {
      final level = levelById(75)!;
      final game = await _play(tester, level, [
        (tap: Vector2(5.2, 9.3), type: PieceType.booster),
        (tap: Vector2(6.2, 9.3), type: PieceType.road),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 76 Eruption — ramp jump over geyser', (tester) async {
      final level = levelById(76)!;
      final game = await _play(tester, level, [
        (tap: Vector2(6.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 77 Lava Run — booster + bridge + ramp jump',
        (tester) async {
      final level = levelById(77)!;
      final game = await _play(tester, level, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(4.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(8.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 78 Cooling Rocks — crumble hops + road',
        (tester) async {
      final level = levelById(78)!;
      final game = await _play(tester, level, [
        (tap: Vector2(10.2, 9.3), type: PieceType.road),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 79 Double Gate Loop — booster + loop through gate',
        (tester) async {
      final level = levelById(79)!;
      final game = await _play(tester, level, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(11, 7.0), type: PieceType.loop),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 80 Rising Lava — spring up, ramp up, lava below',
        (tester) async {
      final level = levelById(80)!;
      final game = await _play(tester, level, [
        (tap: Vector2(5.2, 9.3), type: PieceType.spring),
        (tap: Vector2(12.0, 8.0), type: PieceType.ramp),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 81 Ember Rain — reinforced bridge, rockfall',
        (tester) async {
      final level = levelById(81)!;
      final game = await _play(tester, level, [
        (tap: Vector2(5.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(5.2, 9.3), type: PieceType.road),
        (tap: Vector2(9.2, 9.3), type: PieceType.road),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 82 The Crucible — seesaw over lava, then gate',
        (tester) async {
      final level = levelById(82)!;
      final game = await _play(tester, level, [
        (tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
        (tap: Vector2(11.2, 9.3), type: PieceType.road),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 83 Last Bridge — boost-jump off the bridge end',
        (tester) async {
      final level = levelById(83)!;
      final game = await _play(tester, level, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(10.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, level);
    });

    testWidgets('Level 84 Volcano Exam — loop + bridge + gate + geyser',
        (tester) async {
      final level = levelById(84)!;
      final game = await _play(tester, level, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
        (tap: Vector2(13, 7.0), type: PieceType.loop),
      ]);
      _expectPassed(game, level);
    });
  });
}
