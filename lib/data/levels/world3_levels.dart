// World 3 — Snow Peaks, Levels 25-36.
// Level design doc page 8 se liya gaya: naam, tray, twist.
// Surface: ice — grip kam (brake lambi, jump chhote), is liye
// Booster yahin aata hai. BOOSTER UNLOCKED (Level 27).
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Coin heights: road par y=8.2, ledge (top y=8.5)
// par y=7.7, jump ki hawa mein flight line par.
// Hal (solution) har level ke comment mein — gameplay_test wahi khelta hai.
//
// NOTE (L34 Thin Ice): design doc ke mutabiq bridge 2 second baad
// tootna chahiye — ye timed-break mechanic abhi nahi bana (hazard
// system Phase 4/5 mein). Filhal tight gold time pressure deta hai.
import '../../core/constants.dart';
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 25 — "First Ice".
/// Flat ice rink, ek chhota gap — barf ko mehsoos karo.
/// Tray: Road x2 (ek spare).
/// Hal: road 4-6 par.
const LevelData level25 = LevelData(
  id: 25,
  world: 3,
  levelInWorld: 1,
  name: 'First Ice',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 14, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(5, 8.2),
    CoinData(12, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 14,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 2)],
);

/// Level 26 — "Brake Early".
/// Barf par dhalwan, chhota finish platform — brake jaldi lagao.
/// Tray: Road x1.
/// Hal: road 5-7 par. Finish zone mein ghuste hi level complete —
/// platform se aage slide karna koi masla nahi.
const LevelData level26 = LevelData(
  id: 26,
  world: 3,
  levelInWorld: 2,
  name: 'Brake Early',
  terrain: [
    TerrainSegment(x: 0, y: 8.5, width: 5, height: 2.5),
    TerrainSegment(x: 7, y: 9, width: 5, height: 2),
  ],
  startX: 2,
  startY: 7.83,
  finishX: 10,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(4, 7.7),
    CoinData(6, 8.2),
    CoinData(9, 8.2),
  ],
  goldTimeSeconds: 14,
  surface: SurfaceType.ice,
  waterZones: [(x: 5, width: 2)],
);

/// Level 27 — "Boost!".
/// Gap barf ki speed se nahi bharta. BOOSTER UNLOCKED.
/// Tray: Booster x1, Ramp x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, ramp (5.0, 8.5) par —
/// boost ke saath jump kar ke 6m gap paar karo. Ramp ka low end
/// zameen par hona chahiye (gap ke upar float kare to gari tip par atak jati hai).
const LevelData level27 = LevelData(
  id: 27,
  world: 3,
  levelInWorld: 3,
  name: 'Boost!',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.booster, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3.5, 8.2),
    CoinData(8, 6.9),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 6)],
);

/// Level 28 — "Ice Ice Baby".
/// Barf par bridge — gari halki si slide karti hai.
/// Tray: Bridge x1, Road x1.
/// Hal: bridge 4-8 par (tap 4.2, 9.3) — road spare hai.
const LevelData level28 = LevelData(
  id: 28,
  world: 3,
  levelInWorld: 4,
  name: 'Ice Ice Baby',
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
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 4)],
);

/// Level 29 — "Too Much Boost".
/// Booster, ramp, aur finish ke peeche deewar — full boost par
/// deewar se takrao. Ramp ko upar angle karo.
/// Tray: Booster x1, Ramp x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, ramp (5.0, 8.5) par.
/// Finish (x=12) deewar (x=14) se pehle hai — zone mein ghuste hi jeet.
const LevelData level29 = LevelData(
  id: 29,
  world: 3,
  levelInWorld: 5,
  name: 'Too Much Boost',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 9, y: 9, width: 5, height: 2),
    TerrainSegment(x: 14, y: 7, width: 1, height: 4),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 12,
  tray: [TrayEntry(PieceType.booster, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3.5, 8.2),
    CoinData(8, 6.9),
    CoinData(9.5, 7.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 5)],
);

/// Level 30 — "Pine Forest".
/// Pine trees (1m chauda block) ke beech se — upar se jump karo.
/// Tray: Road x2, Ramp x1.
/// Hal: road 4-6 par, ramp (9.5, 8.5) par — block (10-11) ke upar se.
const LevelData level30 = LevelData(
  id: 30,
  world: 3,
  levelInWorld: 6,
  name: 'Pine Forest',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 14, height: 2),
    TerrainSegment(x: 10, y: 8, width: 1, height: 1),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(11, 7.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 17,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 2)],
);

/// Level 31 — "Frozen Waterfall".
/// Tez barfili chute, gap, unchi ledge. Gold time ke liye boost + ramp dono.
/// Tray: Booster x1, Ramp x1, Road x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, ramp (5.5, 7.0) par
/// (platform top 7.5 se launch) — ledge (top y=8.5) par utro.
const LevelData level31 = LevelData(
  id: 31,
  world: 3,
  levelInWorld: 7,
  name: 'Frozen Waterfall',
  terrain: [
    TerrainSegment(x: 0, y: 7.5, width: 5, height: 3.5),
    TerrainSegment(x: 8, y: 8.5, width: 12, height: 2.5),
  ],
  startX: 2,
  startY: 6.83,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(3.5, 6.8),
    CoinData(8, 5.4),
    CoinData(16, 7.7),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.ice,
  waterZones: [(x: 5, width: 3)],
);

/// Level 32 — "Whiteout".
/// Barf ka toofan (sirf visual) — build par bharosa karo.
/// Tray: Road x2, Bridge x1.
/// Hal: bridge 4-8 par, road 10-12 par.
const LevelData level32 = LevelData(
  id: 32,
  world: 3,
  levelInWorld: 8,
  name: 'Whiteout',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 2, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.bridge, 1)],
  coins: [
    CoinData(6, 8.2),
    CoinData(11, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 4), (x: 10, width: 2)],
);

/// Level 33 — "Double Boost".
/// Do bade gaps, booster chain — beech mein landing flat honi chahiye.
/// Tray: Booster x2, Ramp x2.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, ramp (4.5, 8.5) par,
/// booster (10.2, 9.3) tap se 10-11 par, ramp (13.0, 8.5) par.
/// Doosri ramp ka low end island par hona chahiye (gap ke upar float
/// kare to gari tip par atak jati hai).
const LevelData level33 = LevelData(
  id: 33,
  world: 3,
  levelInWorld: 9,
  name: 'Double Boost',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 10, y: 9, width: 2, height: 2),
    TerrainSegment(x: 18, y: 9, width: 2, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [TrayEntry(PieceType.booster, 2), TrayEntry(PieceType.ramp, 2)],
  coins: [
    CoinData(3.5, 8.2),
    CoinData(6, 7.6),
    CoinData(15, 7.3),
    CoinData(17, 7.2),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 6), (x: 12, width: 6)],
);

/// Level 34 — "Thin Ice".
/// Bridge tooti hui barf par — ek dafa, saaf cross karo, ruko mat.
/// Tray: Bridge x1.
/// Hal: bridge 4-8 par (tap 4.2, 9.3).
/// Hazard (Phase 4): bridge gari ke touch ke 2 second baad toot jata hai —
/// car ~1.3s mein paar kar leti hai, rukna mana hai.
const LevelData level34 = LevelData(
  id: 34,
  world: 3,
  levelInWorld: 10,
  name: 'Thin Ice',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 12, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(6, 8.2),
    CoinData(14, 8.2),
  ],
  goldTimeSeconds: 14,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 4)],
  hazards: [LevelHazard.bridgeBreak(afterSeconds: 2.0)],
);

/// Level 35 — "Avalanche Alley".
/// Barf ke gole dhalwan se guzarte hain (timing ka preview) —
/// filhal ramp se gap jump karo, phir aage.
/// Tray: Road x1, Ramp x1.
/// Hal: road 4-6 par, ramp (10.5, 8.5) se 10-12 gap jump karo
/// (hawa wala coin 11, 7.2 par hai).
/// Hazard (Phase 4): snowball (8, 4.5) se girta hai, island (6-10) par
/// ludhakta hua raasta kaatta hai — pehla gola GO ke 2.5s baad, phir har 4s.
/// NOTE: pehle island top 8.5 par tha aur ramp se climb karna tha —
/// barf par ramp climb flip kar deta hai (traction kam, pitch zyada),
/// is liye island flat (top 9.0) kar diya aur ramp jump banaya.
const LevelData level35 = LevelData(
  id: 35,
  world: 3,
  levelInWorld: 11,
  name: 'Avalanche Alley',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 4, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(8, 8.2),
    CoinData(11, 7.2),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 2), (x: 10, width: 2)],
  hazards: [
    LevelHazard.snowball(x: 8, y: 4.5, intervalSeconds: 4.0, firstAfterSeconds: 2.5),
  ],
);

/// Level 36 — "Peaks Exam".
/// Barf, boost, bridge aur deewar wala finish — World 3 ka test.
/// Tray: Booster x1, Bridge x1, Ramp x1, Road x1.
/// Hal: bridge 4-8 par, booster (8.2, 9.3) tap se 8-9 par,
/// ramp (11.0, 8.5) par — finish (x=17) deewar (x=19) se pehle.
/// Ramp ka low end island par hona chahiye (gap ke upar float
/// kare to gari tip par atak jati hai).
const LevelData level36 = LevelData(
  id: 36,
  world: 3,
  levelInWorld: 12,
  name: 'Peaks Exam',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 2, height: 2),
    TerrainSegment(x: 14, y: 9, width: 5, height: 2),
    TerrainSegment(x: 19, y: 7, width: 1, height: 4),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(6, 8.2),
    CoinData(9, 8.2),
    CoinData(13, 7.3),
    CoinData(15, 7.2),
  ],
  goldTimeSeconds: 22,
  surface: SurfaceType.ice,
  waterZones: [(x: 4, width: 4), (x: 10, width: 4)],
);

/// World 3 ke poore 12 levels.
const List<LevelData> world3Levels = [
  level25,
  level26,
  level27,
  level28,
  level29,
  level30,
  level31,
  level32,
  level33,
  level34,
  level35,
  level36,
];
