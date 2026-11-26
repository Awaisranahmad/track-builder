// World 1 — Green Hills, Levels 1-12.
// Level design doc page 6 se liya gaya: naam, tray, twist.
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Gold times pehli playable pass ke targets hain —
// playtest ke baad tune honge (fairness rules ke mutabiq).
//
// Coin heights: coin tab collect hota hai jab gari ka chassis
// us se 0.5m ke andar guzre — is liye road par chalte hue coins
// y=8.2 par hain (chassis ~8.33), ledge (top y=8.5) par y=7.7,
// aur jump ki hawa mein coins flight line par. Phase 1 mein
// L1/L2/L3 ke gap coins y=7.6 par thay — gari ki chhat se
// 0.53m upar, drive kar ke collect nahi hote thay; Phase 2
// mein neeche laaye gaye taake 3-star mumkin ho.
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
    CoinData(5, 8.2),
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
    CoinData(5, 8.2),
    CoinData(11, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 15,
  waterZones: [(x: 4, width: 2), (x: 10, width: 2)],
);

/// Level 3 — "Coin Line".
/// Ek gap, coins arc mein. Tray: Road x2 (ek spare — waste allowed early).
/// Seekh: coins risky line par hote hain, safe line par nahi.
/// Arc halki si hai (8.0-8.1) taake road par drive kar ke saare coins milen.
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
    CoinData(5.5, 8.1),
    CoinData(6, 8.0),
    CoinData(6.5, 8.1),
  ],
  goldTimeSeconds: 14,
  waterZones: [(x: 5, width: 2)],
);

/// Level 4 — "Downhill".
/// Start finish se upar hai, beech mein gap. Tray: Road x2.
/// Gravity free speed deti hai — finish par brake karna seekhna hai.
const LevelData level4 = LevelData(
  id: 4,
  world: 1,
  levelInWorld: 4,
  name: 'Downhill',
  terrain: [
    TerrainSegment(x: 0, y: 8.5, width: 4, height: 2.5),
    TerrainSegment(x: 6, y: 9, width: 14, height: 2),
  ],
  startX: 2,
  startY: 7.83,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(3, 7.7),
    CoinData(5, 8.2),
    CoinData(14, 8.2),
  ],
  goldTimeSeconds: 14,
  waterZones: [(x: 4, width: 2)],
);

/// Level 5 — "Ramp Up".
/// Chauda gap, road se nahi bharta. Tray: Road x1, Ramp x1.
/// RAMP UNLOCKED. Pehla jump — landing zone bari aur forgiving hai.
/// Hal: road 4-6 par, ramp (6.5, 8.5) par — jump kar ke 8 ke paar.
const LevelData level5 = LevelData(
  id: 5,
  world: 1,
  levelInWorld: 5,
  name: 'Ramp Up',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 12, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(7, 7.7),
    CoinData(13, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 4, width: 4)],
);

/// Level 6 — "Angle It".
/// Wahi jump, finish ledge upar hai. Tray: Ramp x1, Road x1.
/// Ramp ko ghumana seekhna hai — seedha ramp paani mein girayega.
/// Hal: road 4-6 par, ramp (6.5, 8.5) par — ledge (top y=8.5) par utro.
const LevelData level6 = LevelData(
  id: 6,
  world: 1,
  levelInWorld: 6,
  name: 'Angle It',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 7, y: 8.5, width: 9, height: 2.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 14,
  tray: [TrayEntry(PieceType.ramp, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(6.5, 7.6),
    CoinData(11, 7.7),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 4, width: 3)],
);

/// Level 7 — "Too Fast".
/// Upar se start, ramp, chhota finish platform. Tray: Ramp x1.
/// Pehla overshoot lesson: full speed finish se aage nikal jata hai.
/// Hal: ramp (4.5, 7.5) par — platform (x=7) par utro, brake se sambhalo.
const LevelData level7 = LevelData(
  id: 7,
  world: 1,
  levelInWorld: 7,
  name: 'Too Fast',
  terrain: [
    TerrainSegment(x: 0, y: 7, width: 5, height: 4),
    TerrainSegment(x: 7, y: 9, width: 9, height: 2),
  ],
  startX: 2,
  startY: 6.33,
  finishX: 13,
  tray: [TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(6.5, 7.3),
    CoinData(10, 8.2),
    CoinData(12, 8.2),
  ],
  goldTimeSeconds: 12,
  waterZones: [(x: 5, width: 2)],
);

/// Level 8 — "Step Up, Step Down".
/// Do ledges, alag heights. Tray: Road x2, Ramp x1.
/// Pehla do-piece combination — do valid solutions hain.
/// Hal: road 5-7 par, ramp (6.5, 8.5) se ledge (top y=8.5) par,
/// phir road 12-14 par.
const LevelData level8 = LevelData(
  id: 8,
  world: 1,
  levelInWorld: 8,
  name: 'Step Up, Step Down',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7, y: 8.5, width: 5, height: 2.5),
    TerrainSegment(x: 14, y: 9, width: 6, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(6, 8.2),
    CoinData(9.5, 7.7),
    CoinData(13, 8.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 5, width: 2), (x: 12, width: 2)],
);

/// Level 9 — "Bridge the Gap".
/// Nadi itni chaudi ke koi jump nahi. Tray: Bridge x1, Road x1.
/// BRIDGE UNLOCKED. Bridge halka sa hilta hai — is dafa funny hai, fatal nahi.
/// Hal: bridge (4.2, 9.3) tap se 4-8 par — road spare hai.
/// NOTE: Phase 2 mein bridge static plank hai (sag Phase 4 polish mein).
const LevelData level9 = LevelData(
  id: 9,
  world: 1,
  levelInWorld: 9,
  name: 'Bridge the Gap',
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
    CoinData(7, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 4, width: 4)],
);

/// Level 10 — "Bridge + Jump".
/// Pehle nadi par bridge, phir ramp jump. Tray: Bridge x1, Ramp x1.
/// Pehla true combo level. Gold time ke liye bridge par brake nahi.
/// Hal: bridge 4-8 par, ramp (11.5, 8.5) par — 12-14 gap jump karo.
const LevelData level10 = LevelData(
  id: 10,
  world: 1,
  levelInWorld: 10,
  name: 'Bridge + Jump',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 4, height: 2),
    TerrainSegment(x: 14, y: 9, width: 6, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(6, 8.2),
    CoinData(13, 7.7),
    CoinData(17, 8.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 4, width: 4), (x: 12, width: 2)],
);

/// Level 11 — "Almost Nothing".
/// Lamba level, generous terrain. Tray: Road x1, Ramp x1, Bridge x1.
/// Efficiency lesson: 3-star hal sirf 2 pieces istemal karta hai (ramp spare).
/// Hal: road 4-6 par, bridge 12-16 par.
const LevelData level11 = LevelData(
  id: 11,
  world: 1,
  levelInWorld: 11,
  name: 'Almost Nothing',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 6, height: 2),
    TerrainSegment(x: 16, y: 9, width: 4, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [
    TrayEntry(PieceType.road, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.bridge, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(10, 8.2),
    CoinData(14, 8.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 4, width: 2), (x: 12, width: 4)],
);

/// Level 12 — "Hills Exam".
/// Gap, nadi aur uncha finish ek run mein. Tray: Road x2, Ramp x1, Bridge x1.
/// World test — L1-11 se kuch naya nahi. 20 stars par Desert khulta hai.
/// Hal: road 4-6 par, bridge 11-15 par, ramp (14.5, 8.5) par —
/// ramp bridge ke end se ledge (top y=8.5) par le jata hai.
const LevelData level12 = LevelData(
  id: 12,
  world: 1,
  levelInWorld: 12,
  name: 'Hills Exam',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 5, height: 2),
    TerrainSegment(x: 15, y: 8.5, width: 5, height: 2.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [
    TrayEntry(PieceType.road, 2),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.bridge, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(9, 8.2),
    CoinData(16.5, 7.7),
  ],
  goldTimeSeconds: 20,
  waterZones: [(x: 4, width: 2), (x: 11, width: 4)],
);

/// World 1 ke poore 12 levels.
const List<LevelData> world1Levels = [
  level1,
  level2,
  level3,
  level4,
  level5,
  level6,
  level7,
  level8,
  level9,
  level10,
  level11,
  level12,
];
