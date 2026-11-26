// World 2 — Desert Dunes, Levels 13-24.
// Level design doc page 7 se liya gaya: naam, tray, twist.
// Surface: sand — motor halka slow (SurfaceValues.motorMultiplier 0.8),
// is liye gold times World 1 se thode lambe hain.
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Coin heights: road par y=8.2, ledge (top y=8.5)
// par y=7.7, jump ki hawa mein flight line par.
// Hal (solution) har level ke comment mein — gameplay_test wahi khelta hai.
import '../../core/constants.dart';
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 13 — "First Dune".
/// Uncha start (dune), do gaps. Tray: Road x2.
/// Hal: road 4-6 par, road 10-12 par.
const LevelData level13 = LevelData(
  id: 13,
  world: 2,
  levelInWorld: 1,
  name: 'First Dune',
  terrain: [
    TerrainSegment(x: 0, y: 8.5, width: 4, height: 2.5),
    TerrainSegment(x: 6, y: 9, width: 4, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 7.83,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(3, 7.7),
    CoinData(5, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 17,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 2), (x: 10, width: 2)],
);

/// Level 14 — "Long Crossing".
/// Ab tak ki sab se chaudi khaai (dry canyon). Tray: Bridge x1, Road x1.
/// Hal: bridge 4-8 par (tap 4.2, 9.3) — road spare hai.
const LevelData level14 = LevelData(
  id: 14,
  world: 2,
  levelInWorld: 2,
  name: 'Long Crossing',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 12, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(6, 8.2),
    CoinData(14, 8.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 4)],
);

/// Level 15 — "Cactus Alley".
/// Raste mein cactus (1m uncha block) — seedha drive karna atak jayega.
/// Tray: Road x2, Ramp x1.
/// Hal: road 4-6 par, ramp (8.5, 8.5) par — block (9-10) ke upar se jump.
const LevelData level15 = LevelData(
  id: 15,
  world: 2,
  levelInWorld: 3,
  name: 'Cactus Alley',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 14, height: 2),
    TerrainSegment(x: 9, y: 8, width: 1, height: 1),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(9.5, 7.5),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 17,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 2)],
);

/// Level 16 — "Half Pipe".
/// Gehri U-shaped valley — do ramps aamne-saamne.
/// Tray: Ramp x2.
/// Hal: ramp (5.0, 8.5) se valley mein (low end zameen par hona
/// chahiye — gap ke upar float kare to gari tip par atak jati hai),
/// ramp (11, 9.5) se bahar. Valley 4m chaudi hai taake landing safe ho.
const LevelData level16 = LevelData(
  id: 16,
  world: 2,
  levelInWorld: 4,
  name: 'Half Pipe',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 10, width: 4, height: 1),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 2)],
  coins: [
    CoinData(3, 8.2),
    CoinData(8, 9.3),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 2), (x: 10, width: 2)],
);

/// Level 17 — "Soft Landing".
/// Uncha start, lamba drop, finish neeche. Tray: Road x1, Ramp x1.
/// Hal: road 5-7 par — platform (top y=8.5) se 0.5m drop kar ke road
/// par utro. Ramp spare hai.
/// NOTE: pehle ramp (6, 8.2) ko +30° ghuma kar dhalwan banane ki
/// koshish thi — gari dhalwan par 4+ m/s pakar kar aage ki taraf
/// flip ho jati thi. +30° ramp descent ke liye nahi bana (us ki
/// geometry 0.5 grid par platform se ground tak nahi milti).
const LevelData level17 = LevelData(
  id: 17,
  world: 2,
  levelInWorld: 5,
  name: 'Soft Landing',
  terrain: [
    TerrainSegment(x: 0, y: 8.5, width: 5, height: 2.5),
    TerrainSegment(x: 7, y: 9, width: 13, height: 2),
  ],
  startX: 2,
  startY: 7.83,
  finishX: 16,
  tray: [TrayEntry(PieceType.road, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3, 7.7),
    CoinData(6, 8.2),
    CoinData(14, 8.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.sand,
  waterZones: [(x: 5, width: 2)],
);

/// Level 18 — "Three Bridges".
/// Teen canyon gaps, 4 pieces — ek spare.
/// Tray: Bridge x2, Road x2.
/// Hal: bridge 3-7, bridge 9-13, road 15-17 par.
const LevelData level18 = LevelData(
  id: 18,
  world: 2,
  levelInWorld: 6,
  name: 'Three Bridges',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 3, height: 2),
    TerrainSegment(x: 7, y: 9, width: 2, height: 2),
    TerrainSegment(x: 13, y: 9, width: 2, height: 2),
    TerrainSegment(x: 17, y: 9, width: 3, height: 2),
  ],
  startX: 1.5,
  startY: 8.33,
  finishX: 19,
  tray: [TrayEntry(PieceType.bridge, 2), TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(5, 8.2),
    CoinData(11, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.sand,
  waterZones: [(x: 3, width: 4), (x: 9, width: 4), (x: 15, width: 2)],
);

/// Level 19 — "Rock Block".
/// Beech mein pathar (1m uncha block) — seedha drive karna hard stop hai.
/// Tray: Ramp x1, Road x1.
/// Hal: road 4-6 par, ramp (9.5, 8.5) par — block (10-11) ke upar se jump.
const LevelData level19 = LevelData(
  id: 19,
  world: 2,
  levelInWorld: 7,
  name: 'Rock Block',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 14, height: 2),
    TerrainSegment(x: 10, y: 8, width: 1, height: 1),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(10.5, 7.5),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 17,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 2)],
);

/// Level 20 — "Dune Surf".
/// Chaar rolling dunes — seedhiyan neeche ki taraf, coins har crest par.
/// Takreeban koi building nahi: sirf ek road, baaki driving.
/// Tray: Road x1.
/// Hal: road 12-14 par.
const LevelData level20 = LevelData(
  id: 20,
  world: 2,
  levelInWorld: 8,
  name: 'Dune Surf',
  terrain: [
    TerrainSegment(x: 0, y: 8, width: 4, height: 3),
    TerrainSegment(x: 4, y: 8.5, width: 4, height: 2.5),
    TerrainSegment(x: 8, y: 9, width: 4, height: 2),
    TerrainSegment(x: 14, y: 9, width: 6, height: 2),
  ],
  startX: 2,
  startY: 7.33,
  finishX: 18,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(3, 7.3),
    CoinData(6, 7.8),
    CoinData(10, 8.2),
    CoinData(17, 8.2),
  ],
  goldTimeSeconds: 15,
  surface: SurfaceType.sand,
  waterZones: [(x: 12, width: 2)],
);

/// Level 21 — "The Long Way Down".
/// Tez dhalwan, neeche gap full speed par. Tray: Bridge x1, Ramp x1.
/// Hal: bridge 5-9 par (tap 5.2, 9.3) — platform (top y=8.5) se 0.5m
/// drop kar ke bridge par utro, phir flat bridge par speed sambhalo.
/// Ramp spare hai — jump karne ki koshish out of control hogi.
/// NOTE: pehle ramp (6.5, 8.5) ko +30° dhalwan banaya tha — wahi
/// flip ka masla (L17 wala note dekho).
const LevelData level21 = LevelData(
  id: 21,
  world: 2,
  levelInWorld: 9,
  name: 'The Long Way Down',
  terrain: [
    TerrainSegment(x: 0, y: 8.5, width: 5, height: 2.5),
    TerrainSegment(x: 8, y: 9, width: 12, height: 2),
  ],
  startX: 2,
  startY: 7.83,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3, 7.7),
    CoinData(7, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 15,
  surface: SurfaceType.sand,
  waterZones: [(x: 5, width: 3)],
);

/// Level 22 — "Mirage".
/// Do ek jaise gaps — ek chauda hai. Pehle naapo, phir banao.
/// Tray: Bridge x1, Ramp x1, Road x1.
/// Hal: road 4-6 par, bridge 10-14 par. Ramp spare hai.
const LevelData level22 = LevelData(
  id: 22,
  world: 2,
  levelInWorld: 10,
  name: 'Mirage',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 4, height: 2),
    TerrainSegment(x: 14, y: 9, width: 6, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(12, 8.2),
    CoinData(17, 8.2),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 2), (x: 10, width: 4)],
);

/// Level 23 — "Sandstorm Run".
/// Lamba mixed level — sab kuch ek run mein. Tray: Road x2, Bridge x1, Ramp x1.
/// Hal: road 4-6, bridge 9-13, road 16-18 par. Ramp spare hai.
const LevelData level23 = LevelData(
  id: 23,
  world: 2,
  levelInWorld: 11,
  name: 'Sandstorm Run',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 3, height: 2),
    TerrainSegment(x: 13, y: 9, width: 3, height: 2),
    TerrainSegment(x: 18, y: 9, width: 2, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [
    TrayEntry(PieceType.road, 2),
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.ramp, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(11, 8.2),
    CoinData(17, 8.2),
  ],
  goldTimeSeconds: 22,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 2), (x: 9, width: 4), (x: 16, width: 2)],
);

/// Level 24 — "Dunes Exam".
/// Canyon, pathar, dunes aur uncha finish. Tray: Bridge x1, Ramp x2, Road x1.
/// Hal: bridge 4-8, road 10-12, ramp (14.5, 8.5) se gap jump kar ke
/// ledge (top y=8.5) par. Doosra ramp spare hai.
/// NOTE: pehle ramp (12.5, 8.5) se ledge par charhne ki koshish thi —
/// ret par slow launch par gari peeche ki taraf flip ho jati thi,
/// is liye ramp ab jump ke liye hai, climb ke liye nahi.
const LevelData level24 = LevelData(
  id: 24,
  world: 2,
  levelInWorld: 12,
  name: 'Dunes Exam',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 2, height: 2),
    TerrainSegment(x: 12, y: 9, width: 2, height: 2),
    TerrainSegment(x: 16, y: 8.5, width: 4, height: 2.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.ramp, 2),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(6, 8.2),
    CoinData(11, 8.2),
    CoinData(17, 7.7),
  ],
  goldTimeSeconds: 22,
  surface: SurfaceType.sand,
  waterZones: [(x: 4, width: 4), (x: 10, width: 2), (x: 14, width: 2)],
);

/// World 2 ke poore 12 levels.
const List<LevelData> world2Levels = [
  level13,
  level14,
  level15,
  level16,
  level17,
  level18,
  level19,
  level20,
  level21,
  level22,
  level23,
  level24,
];
