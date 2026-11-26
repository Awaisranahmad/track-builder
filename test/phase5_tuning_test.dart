// Phase 5 tuning test — naye pieces aur hazards ki physics verify.
// Ye file Phase 5 ke engine ko tune karne ke liye hai; pass hone
// ke baad is ke cases phase5_test.dart mein rehte hain.
// Har level yahin inline define hai (LevelData) — worlds mein
// aane wale asli levels alag file mein hain.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
/// Lift jaisi levels mein "wait" karna parta hai (design doc:
/// "build to the lift, wait, ride, drive off").
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

// ---- Tuning levels (inline) ----

const LevelData loopLevel = LevelData(
  id: 900,
  world: 4,
  levelInWorld: 1,
  name: 'Loop Tuning',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.loop, 1), TrayEntry(PieceType.booster, 1)],
  coins: [CoinData(5, 8.2), CoinData(14, 8.2), CoinData(16, 8.2)],
  goldTimeSeconds: 15,
);

const LevelData springLevel = LevelData(
  id: 901,
  world: 5,
  levelInWorld: 1,
  name: 'Spring Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 8, y: 6, width: 4, height: 5),
    TerrainSegment(x: 14, y: 6, width: 6, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.spring, 1), TrayEntry(PieceType.road, 1)],
  coins: [CoinData(5, 8.2), CoinData(10, 5.2), CoinData(13, 5.2)],
  goldTimeSeconds: 16,
);

const LevelData seesawLevel = LevelData(
  id: 902,
  world: 6,
  levelInWorld: 1,
  name: 'Seesaw Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 11, y: 9, width: 9, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.seesaw, 1)],
  coins: [CoinData(5, 8.2), CoinData(9.5, 8.2), CoinData(15, 8.2)],
  goldTimeSeconds: 16,
  waterZones: [(x: 8, width: 3)],
);

const LevelData magnetLevel = LevelData(
  id: 903,
  world: 6,
  levelInWorld: 2,
  name: 'Magnet Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.magnet, 1),
  ],
  coins: [CoinData(5, 8.2), CoinData(9, 7.0), CoinData(15, 8.2)],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 6)],
);

const LevelData liftLevel = LevelData(
  id: 904,
  world: 4,
  levelInWorld: 2,
  name: 'Lift Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7.75, y: 6, width: 12.25, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [CoinData(3, 8.2), CoinData(6.4, 7.0), CoinData(12, 5.2)],
  goldTimeSeconds: 18,
  hazards: [
    LevelHazard.lift(x: 6.375, y: 9.0, y2: 6.0, periodSeconds: 6.0),
  ],
);

const LevelData gateLevel = LevelData(
  id: 905,
  world: 4,
  levelInWorld: 3,
  name: 'Gate Tuning',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [CoinData(5, 8.2), CoinData(12, 8.2), CoinData(16, 8.2)],
  goldTimeSeconds: 16,
  hazards: [
    LevelHazard.gate(x: 10, y: 9.0, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

const LevelData lavaLevel = LevelData(
  id: 906,
  world: 7,
  levelInWorld: 1,
  name: 'Lava Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.road, 1)],
  coins: [CoinData(5, 8.2), CoinData(8, 8.2), CoinData(15, 8.2)],
  goldTimeSeconds: 16,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.0, width: 4),
  ],
);

const LevelData windLevel = LevelData(
  id: 907,
  world: 8,
  levelInWorld: 1,
  name: 'Wind Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.booster, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [CoinData(5, 8.2), CoinData(9, 7.0), CoinData(15, 8.2)],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 6)],
  hazards: [
    LevelHazard.wind(
      x: 6,
      y: 4,
      width: 6,
      cycleSeconds: 4.0,
      openSeconds: 2.0,
      strength: 1.0,
    ),
  ],
);

const LevelData geyserLevel = LevelData(
  id: 908,
  world: 7,
  levelInWorld: 2,
  name: 'Geyser Tuning',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [CoinData(5, 8.2), CoinData(13, 8.2), CoinData(16, 8.2)],
  goldTimeSeconds: 16,
  hazards: [
    LevelHazard.geyser(
      x: 10,
      y: 9.0,
      cycleSeconds: 3.0,
      openSeconds: 1.0,
    ),
  ],
);

const LevelData crumbleLevel = LevelData(
  id: 909,
  world: 5,
  levelInWorld: 2,
  name: 'Crumble Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 9, y: 9, width: 11, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [CoinData(5, 8.2), CoinData(7.5, 8.2), CoinData(15, 8.2)],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 3)],
  crumblePlatforms: [TerrainSegment(x: 6, y: 9, width: 3, height: 2)],
);

const LevelData rockfallLevel = LevelData(
  id: 910,
  world: 5,
  levelInWorld: 3,
  name: 'Rockfall Tuning',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [CoinData(5, 8.2), CoinData(12, 8.2), CoinData(16, 8.2)],
  goldTimeSeconds: 16,
  hazards: [
    LevelHazard.rockfall(x: 10, y: 2, intervalSeconds: 4.0),
  ],
);

const LevelData risingLavaLevel = LevelData(
  id: 911,
  world: 7,
  levelInWorld: 3,
  name: 'Rising Lava Tuning',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [CoinData(5, 8.2), CoinData(12, 8.2), CoinData(16, 8.2)],
  goldTimeSeconds: 16,
  hazards: [
    LevelHazard.risingLava(x: 0, y: 10.5, width: 20, rate: 0.25),
  ],
);

const LevelData sinkingBridgeLevel = LevelData(
  id: 912,
  world: 7,
  levelInWorld: 4,
  name: 'Sinking Bridge Tuning',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1)],
  coins: [CoinData(5, 8.2), CoinData(8, 8.2), CoinData(15, 8.2)],
  goldTimeSeconds: 16,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.0, width: 4),
    LevelHazard.sinkingBridge(rate: 0.3),
  ],
);

void main() {
  group('Phase 5 tuning — naye pieces', () {
    testWidgets('Loop — booster se loop poora, finish', (tester) async {
      final game = await _play(tester, loopLevel, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(10, 7.0), type: PieceType.loop),
      ]);
      _expectPassed(game, loopLevel);
    });

    // Loop ring-jump hai (true loop-the-loop nahi): ramp se launch ho kar
    // gari ring ke andar se guzar jati hai, is liye booster baghair bhi
    // pass ho jata hai. Booster se zyada speed + behtar time milta hai.
    testWidgets('Loop — booster baghair bhi ring se guzar jata hai',
        (tester) async {
      final game = await _play(tester, loopLevel, [
        (tap: Vector2(10, 7.0), type: PieceType.loop),
      ]);
      _expectPassed(game, loopLevel);
    });

    testWidgets('Spring — bounce kar ke deewar par charhta hai',
        (tester) async {
      final game = await _play(tester, springLevel, [
        (tap: Vector2(6.2, 9.3), type: PieceType.spring),
        (tap: Vector2(12.2, 6.3), type: PieceType.road),
      ]);
      _expectPassed(game, springLevel);
    });

    testWidgets('See-Saw — jhukta hai, gari paar karti hai', (tester) async {
      final game = await _play(tester, seesawLevel, [
        (tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
      ]);
      _expectPassed(game, seesawLevel);
    });

    testWidgets('Magnet — float kar ke gap paar hota hai', (tester) async {
      final game = await _play(tester, magnetLevel, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
        (tap: Vector2(9, 8.0), type: PieceType.magnet),
      ]);
      _expectPassed(game, magnetLevel);
    });
  });

  group('Phase 5 tuning — hazards', () {
    testWidgets('Lift — neeche se upar, drive off', (tester) async {
      // Scripted: gas se lift par charho, gas chhor kar ride karo
      // (lift 1.5-3.0s mein upar jati hai), phir gas se utro.
      final game = await _playScripted(tester, liftLevel, [], [
        (at: 0, gas: true, brake: false),
        (at: 1.2, gas: false, brake: false),
        (at: 3.5, gas: true, brake: false),
      ]);
      _expectPassed(game, liftLevel);
      expect(game.liftCount, 1);
    });

    testWidgets('Gate — khulne ka intezar, phir guzarta hai',
        (tester) async {
      final game = await _play(tester, gateLevel, []);
      _expectPassed(game, gateLevel);
      expect(game.gateCount, 1);
    });

    testWidgets('Lava — bridge par se guzre to pass', (tester) async {
      final game = await _play(tester, lavaLevel, [
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, lavaLevel);
      expect(game.lavaCount, 1);
    });

    testWidgets('Lava — bridge baghair lava mein girta hai', (tester) async {
      final game = await _play(tester, lavaLevel, []);
      expect(game.phase, GamePhase.result);
      final result = game.resultNotifier.value;
      expect(result, isNotNull);
      expect(result!.passed, isFalse);
      expect(result.failReason, 'lava');
    });

    testWidgets('Wind — tailwind se gap paar hota hai', (tester) async {
      final game = await _play(tester, windLevel, [
        (tap: Vector2(3.2, 9.3), type: PieceType.booster),
        (tap: Vector2(4.5, 8.5), type: PieceType.ramp),
      ]);
      _expectPassed(game, windLevel);
      expect(game.windCount, 1);
    });

    testWidgets('Geyser — inactive waqt mein guzre to pass', (tester) async {
      final game = await _play(tester, geyserLevel, []);
      _expectPassed(game, geyserLevel);
      expect(game.geyserCount, 1);
    });

    testWidgets('Crumble — tez guzre to platform tootne se pehle paar',
        (tester) async {
      final game = await _play(tester, crumbleLevel, []);
      _expectPassed(game, crumbleLevel);
    });

    testWidgets('Rockfall — pathar girte hain, level phir bhi pass',
        (tester) async {
      final game = await _play(tester, rockfallLevel, []);
      _expectPassed(game, rockfallLevel);
    });

    testWidgets('Rising Lava — tez gari lava se pehle finish',
        (tester) async {
      final game = await _play(tester, risingLavaLevel, []);
      _expectPassed(game, risingLavaLevel);
      expect(game.lavaCount, 1);
    });

    testWidgets('Sinking Bridge — dhanste bridge par se guzre to pass',
        (tester) async {
      final game = await _play(tester, sinkingBridgeLevel, [
        (tap: Vector2(6.2, 9.3), type: PieceType.bridge),
      ]);
      _expectPassed(game, sinkingBridgeLevel);
    });
  });
}
