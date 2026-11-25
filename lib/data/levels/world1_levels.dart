// World 1 — Green Hills, Levels 1-3.
// Level design doc page 6 se liya gaya: naam, tray, twist.
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Gold times pehli playable pass ke targets hain —
// playtest ke baad tune honge (fairness rules ke mutabiq).
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 1 — "First Gear".
/// Flat grass, ek chhota gap. Tray: Road x1.
/// Pure tutorial: drag, GO, finish — pehla star 30 second mein.
const LevelData level1 = LevelData(
  id: 1,
  world: 1,
  levelInWorld: 1,
  name: 'First Gear',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 14, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 7.6),
    CoinData(10, 8.2),
    CoinData(14, 8.2),
  ],
  goldTimeSeconds: 12,
  waterZones: [(x: 4, width: 2)],
);

/// Level 2 — "Two Gaps".
/// Do chhote gaps ek ke baad ek. Tray: Road x2.
/// Coins doosre gap ke upar — repetition se confidence banta hai.
const LevelData level2 = LevelData(
  id: 2,
  world: 1,
  levelInWorld: 2,
  name: 'Two Gaps',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 4, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(5, 7.6),
    CoinData(11, 7.6),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 15,
  waterZones: [(x: 4, width: 2), (x: 10, width: 2)],
);

/// Level 3 — "Coin Line".
/// Ek gap, coins arc mein. Tray: Road x2 (ek spare — waste allowed early).
/// Seekh: coins risky line par hote hain, safe line par nahi.
const LevelData level3 = LevelData(
  id: 3,
  world: 1,
  levelInWorld: 3,
  name: 'Coin Line',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7, y: 9, width: 13, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(5.5, 7.4),
    CoinData(6, 6.8),
    CoinData(6.5, 7.4),
  ],
  goldTimeSeconds: 14,
  waterZones: [(x: 5, width: 2)],
);

/// Phase 1 mein khelne layak levels.
const List<LevelData> world1Levels = [level1, level2, level3];

/// Level id se dhoondho — na mile to null.
LevelData? levelById(int id) {
  for (final level in world1Levels) {
    if (level.id == id) return level;
  }
  return null;
}
