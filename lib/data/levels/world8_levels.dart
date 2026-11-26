// World 8 — Sky Islands, Levels 85-96 (finale).
// Sab kuch combined: bridge, ramp, booster, loop, spring, seesaw,
// magnet aur wind — har level ek proven template par bana hai
// (Phase 5 tuning tests / Worlds 1-3).
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Coin heights: road par y=8.2, ledge (top y=8.5)
// par y=7.7, jump ki hawa mein flight line par.
// Sky Islands ki fiction mein neeche kuch nahi — mechanically
// falls waterZones hain (paani mein girna = fail), baaki worlds jaisi.
// Hal (solution) har level ke comment mein — gameplay_world8_test
// wahi khelta hai.
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 85 — "First Island".
/// Bridge + road, do gaps — World 8 ka warm-up.
/// Tray: Bridge x1, Road x1, Ramp x1 (ramp spare).
/// Hal: bridge 6-10 par (tap 6.2, 9.3), road 14-16 par (tap 14.2, 9.3).
const LevelData level85 = LevelData(
  id: 85,
  world: 8,
  levelInWorld: 1,
  name: 'First Island',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 4, height: 2),
    TerrainSegment(x: 16, y: 9, width: 4, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.road, 1),
    TrayEntry(PieceType.ramp, 1),
  ],
  coins: [
    CoinData(3, 8.2),
    CoinData(8, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 6, width: 4), (x: 14, width: 2)],
);

/// Level 86 — "Tailwind".
/// Tailwind (+1.0) ramp jump ko 2m gap ke paar dhakelti hai.
/// Tray: Ramp x1.
/// Hal: ramp (5.5, 8.5) par — kinare ke paas se launch. Gas-only.
/// NOTE: ramp-only jump 4m gap nahi bharta (gas speed ~3 m/s),
/// is liye gap 2m rakha — tailwind phir bhi zaroori hai, warna
/// ramp se launch ho kar bhi gari gap mein girti hai.
const LevelData level86 = LevelData(
  id: 86,
  world: 8,
  levelInWorld: 2,
  name: 'Tailwind',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 8, y: 9, width: 12, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(7, 7.0),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 2)],
  hazards: [
    LevelHazard.wind(
      x: 6,
      y: 4,
      width: 2,
      cycleSeconds: 4.0,
      openSeconds: 2.0,
      strength: 1.0,
    ),
  ],
);

/// Level 87 — "Headwind".
/// Headwind (-1.0) ke khilaf — booster + ramp se 4m gap.
/// Tray: Booster x1, Ramp x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, ramp (4.5, 8.5) par.
/// NOTE: 6m gap headwind mein nahi bharta (tuning test tailwind
/// se pass hota tha) — gap 4m rakha.
const LevelData level87 = LevelData(
  id: 87,
  world: 8,
  levelInWorld: 3,
  name: 'Headwind',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.booster, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(8, 7.0),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 4)],
  hazards: [
    LevelHazard.wind(
      x: 6,
      y: 4,
      width: 4,
      cycleSeconds: 4.0,
      openSeconds: 2.0,
      strength: -1.0,
    ),
  ],
);

/// Level 88 — "Island Hop".
/// Spring se unchi ledge (top y=6) par, phir do road gaps.
/// Tray: Road x3, Spring x1 (ek road spare).
/// Hal: spring (6.2, 9.3) par, road (12.2, 6.3) par (12-14 gap),
/// road (16.2, 6.3) par (16-18 gap). Spring tuning template + roads.
const LevelData level88 = LevelData(
  id: 88,
  world: 8,
  levelInWorld: 4,
  name: 'Island Hop',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 8, y: 6, width: 4, height: 5),
    TerrainSegment(x: 14, y: 6, width: 2, height: 5),
    TerrainSegment(x: 18, y: 6, width: 2, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [TrayEntry(PieceType.road, 3), TrayEntry(PieceType.spring, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(10, 5.2),
    CoinData(15, 5.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 12, width: 2), (x: 16, width: 2)],
);

/// Level 89 — "Cloud Loop".
/// Loop + exit par headwind — loop ke baad hawa ke khilaf.
/// Tray: Loop x1, Booster x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, loop (9, 7.0) par.
/// Gas-only; loop ring-jump hai, booster se speed + behtar time.
const LevelData level89 = LevelData(
  id: 89,
  world: 8,
  levelInWorld: 5,
  name: 'Cloud Loop',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.loop, 1), TrayEntry(PieceType.booster, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(14, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 18,
  hazards: [
    LevelHazard.wind(
      x: 12,
      y: 4,
      width: 4,
      cycleSeconds: 4.0,
      openSeconds: 2.0,
      strength: -1.0,
    ),
  ],
);

/// Level 90 — "Sky Seesaw".
/// Seesaw + tailwind us ke upar — hawa seesaw paar karne mein madad.
/// Tray: See-Saw x1, Road x1 (road spare).
/// Hal: seesaw (8.2, 9.3) par. Gas-only (seesaw tuning template).
const LevelData level90 = LevelData(
  id: 90,
  world: 8,
  levelInWorld: 6,
  name: 'Sky Seesaw',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 11, y: 9, width: 9, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.seesaw, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(9.5, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 8, width: 3)],
  hazards: [
    LevelHazard.wind(
      x: 8,
      y: 4,
      width: 3,
      cycleSeconds: 4.0,
      openSeconds: 2.0,
      strength: 1.0,
    ),
  ],
);

/// Level 91 — "Zero-G Sky".
/// Magnet se float kar ke gap paar — booster nahi, gap chhota (4m).
/// Tray: Magnet x1, Ramp x1.
/// Hal: ramp (4.5, 8.5) par, magnet (8, 8.0) par. Gas-only.
/// NOTE: magnet tuning template 6m gap booster ke saath tha;
/// booster baghair 4m gap rakha.
const LevelData level91 = LevelData(
  id: 91,
  world: 8,
  levelInWorld: 7,
  name: 'Zero-G Sky',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.magnet, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(8, 7.0),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 4)],
);

/// Level 92 — "Storm Run".
/// Pehle gap par tailwind (+1.0), doosre gap par headwind (-1.0) —
/// alternating hawa, har segment ulta throttle chahta hai.
/// Tray: Booster x1, Bridge x1, Road x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, bridge (6.2, 9.3) par,
/// road (14.2, 9.3) par. Gas-only: bridge par tailwind madad,
/// road par headwind ke khilaf bhi gas kaafi hai.
const LevelData level92 = LevelData(
  id: 92,
  world: 8,
  levelInWorld: 8,
  name: 'Storm Run',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 4, height: 2),
    TerrainSegment(x: 16, y: 9, width: 4, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(3.5, 8.2),
    CoinData(8, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 6, width: 4), (x: 14, width: 2)],
  hazards: [
    LevelHazard.wind(
      x: 6,
      y: 4,
      width: 4,
      cycleSeconds: 4.0,
      openSeconds: 2.0,
      strength: 1.0,
    ),
    LevelHazard.wind(
      x: 14,
      y: 4,
      width: 2,
      cycleSeconds: 4.0,
      openSeconds: 2.0,
      strength: -1.0,
    ),
  ],
);

/// Level 93 — "Almost Nothing II".
/// Lamba level, ek 4m gap — L5 "Ramp Up" pattern.
/// Tray: Road x1, Ramp x1.
/// Hal: road (8.2, 9.3) par (gap ka pehla aadha), ramp (10.5, 8.5)
/// par — ramp se launch ho kar gap ka baaki hissa paar karo.
const LevelData level93 = LevelData(
  id: 93,
  world: 8,
  levelInWorld: 9,
  name: 'Almost Nothing II',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(11, 7.7),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 8, width: 4)],
);

/// Level 94 — "Every Piece".
/// Showcase: loop + booster + bridge; baaki pieces tray mein spare.
/// Tray: Road x1, Ramp x1, Bridge x1, Booster x1, Loop x1,
/// Spring x1, See-Saw x1, Magnet x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, loop (8, 7.0) par,
/// bridge (13.2, 9.3) par (13-17 gap).
const LevelData level94 = LevelData(
  id: 94,
  world: 8,
  levelInWorld: 10,
  name: 'Every Piece',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 13, height: 2),
    TerrainSegment(x: 17, y: 9, width: 3, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [
    TrayEntry(PieceType.road, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.loop, 1),
    TrayEntry(PieceType.spring, 1),
    TrayEntry(PieceType.seesaw, 1),
    TrayEntry(PieceType.magnet, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(14, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 20,
  waterZones: [(x: 13, width: 4)],
);

/// Level 95 — "The Long Fall".
/// 0.5m unchi ledge (top y=8.5) se ramp jump — neeche 0.5m drop,
/// flip nahi hota. Spring spare hai.
/// Tray: Ramp x1, Spring x1.
/// Hal: ramp (6.5, 8.0) par — ledge ke kinare se launch ho kar
/// 4m gap (6-10) paar karo, neeche zameen (top y=9) par utro.
const LevelData level95 = LevelData(
  id: 95,
  world: 8,
  levelInWorld: 11,
  name: 'The Long Fall',
  terrain: [
    TerrainSegment(x: 0, y: 8.5, width: 6, height: 2.5),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 7.83,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 1), TrayEntry(PieceType.spring, 1)],
  coins: [
    CoinData(3, 7.7),
    CoinData(12, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 4)],
);

/// Level 96 — "Master Builder".
/// Finale: loop + timed gate + bridge — World 8 ka aakhri test.
/// Tray: Road x1, Ramp x1, Bridge x1, Booster x1, Loop x1, Spring x1
/// (fixed 6-piece tray).
/// Hal: booster (3.2, 9.3) tap se 3-4 par, loop (8, 7.0) par,
/// bridge (13.2, 9.3) par (13-17 gap). Gate (x=11) band ho to
/// gari ruk kar khulne ka intezar karti hai (gate tuning jaisa).
/// NOTE: Free-choice tray future work — filhal fixed 6-piece tray.
/// Master Builder car isi level se unlock hoti hai
/// (car_data.dart: unlockLevelId 96) — yahan kuch change nahi.
const LevelData level96 = LevelData(
  id: 96,
  world: 8,
  levelInWorld: 12,
  name: 'Master Builder',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 13, height: 2),
    TerrainSegment(x: 17, y: 9, width: 3, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [
    TrayEntry(PieceType.road, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.loop, 1),
    TrayEntry(PieceType.spring, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(12, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 20,
  waterZones: [(x: 13, width: 4)],
  hazards: [
    LevelHazard.gate(x: 11, y: 9.0, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

/// World 8 ke poore 12 levels.
const List<LevelData> world8Levels = [
  level85,
  level86,
  level87,
  level88,
  level89,
  level90,
  level91,
  level92,
  level93,
  level94,
  level95,
  level96,
];
