// World 6 — Space Station, Levels 61-72.
// Level design doc se liya gaya: naam, tray, twist.
// Surface: normal. Gold times generous (18-24s) — Space levels
// slow tune hain, fantasy tairna hai, girna nahi.
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Coin heights: road par y=8.2, ledge (top y=8.5)
// par y=7.7, jump ki hawa mein flight line par.
// Hal (solution) har level ke comment mein — gameplay_world6_test
// wahi khelta hai.
//
// ENGINE NOTE (Magnet): magnet piece koi ceiling rail nahi banata —
// ye 2m chauda x 5m uncha low-gravity zone hai (gravity 0.15x).
// Gari zone mein tairti hui gap paar karti hai (phase5_tuning_test
// ka magnet level dekho). Is liye "Ceiling Drive" / "Orbit" /
// "Gravity Flip" wale levels mein ceiling par ulta chalna nahi,
// lambi low-gravity float hai — naam aur tray design doc wale hi
// hain, mechanic engine ki haqeeqat ke mutabiq hai.
// FINISH NOTE: finish zone y=6.0-9.0 hai — finish sirf us deck par
// ho sakta hai jis ki top y=9.5 ya upar ho. 1m neeche deck (top 10)
// par gari finish trigger nahi karti (probe P7/P9 se verify).
// Is liye saare lower decks top y=9.5 par hain.
import '../../core/constants.dart';
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 61 — "Zero-G".
/// Lamba gap, ramp jump, road landing pad — halki shuruaat.
/// ZERO-G UNLOCKED (Magnet piece yahin se unlock hota hai).
/// Tray: Ramp x1, Road x1.
/// Hal: ramp (4.0, 8.5) par, road (6.2, 9.3) tap se 6-8 par —
/// ramp se uchhal kar road pad par utro, phir finish.
/// NOTE: tray mein magnet nahi, is liye yahan koi asli zero-G
/// zone nahi — float ramp jump hai; magnet pehli dafa L62 mein
/// lagta hai.
const LevelData level61 = LevelData(
  id: 61,
  world: 6,
  levelInWorld: 1,
  name: 'Zero-G',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 8, y: 9, width: 12, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(6.5, 7.4),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.normal,
  waterZones: [(x: 5, width: 3)],
);

/// Level 62 — "Ceiling Drive".
/// Magnet zone ke andar tair kar gap paar — pehli float.
/// Tray: Magnet x1, Road x1.
/// Hal: road (4.2, 9.3) tap se 4-6 runway par, magnet (7.5, 8.0)
/// par — kinare se drive off karo, zone mein tair kar 0.5m neeche
/// deck (8.5 se, top 9.5) par utro. Deck ka kinara zone ke aakhir
/// par hai, is liye landing halki hoti hai.
/// NOTE: engine mein ceiling rail nahi — magnet low-gravity float
/// zone hai, ulta chalna nahi.
const LevelData level62 = LevelData(
  id: 62,
  world: 6,
  levelInWorld: 2,
  name: 'Ceiling Drive',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 8.5, y: 9.5, width: 11.5, height: 1.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.magnet, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(7.5, 8.0),
    CoinData(15, 8.7),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  waterZones: [(x: 6, width: 2.5)],
);

/// Level 63 — "Float and Drop".
/// Ramp jump, hawa mein float, phir neeche finish deck par drop.
/// Tray: Ramp x1.
/// Hal: ramp (6.0, 8.5) par — kinare ke paas ramp se uchhal kar
/// 3m gap paar karo, 0.5m neeche deck (9 se, top 9.5) par utro.
/// Ramp aage lagana zaroori hai: (4.5, 8.5) par jump chhota par
/// kar gap mein girta hai (probe P3).
/// NOTE: tray mein magnet nahi, is liye drop jump arc hai, asli
/// zero-G zone nahi. Deck top 9.5 hai — top 10 par finish zone
/// (y=6.0-9.0) gari tak nahi pahunchta (probe P7).
const LevelData level63 = LevelData(
  id: 63,
  world: 6,
  levelInWorld: 3,
  name: 'Float and Drop',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 9, y: 9.5, width: 11, height: 1.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(8, 7.2),
    CoinData(15, 8.7),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  waterZones: [(x: 6, width: 3)],
);

/// Level 64 — "Airlock".
/// Do timed gates, alag cycles — timing wapas, ab Space mein.
/// Tray: Road x1, Booster x1 (dono spare — gas-only).
/// Hal: koi piece nahi — gas-only; gari band gate par rukti hai,
/// khulne par guzar jati hai. Gate 1 (x=8, cycle 3s, open 1.5s),
/// gate 2 (x=13, cycle 4s, open 2s) — cycle lambi alag honay se
/// darwaze baari-bari khulte hain (gate mein phase offset nahi hai).
const LevelData level64 = LevelData(
  id: 64,
  world: 6,
  levelInWorld: 4,
  name: 'Airlock',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1), TrayEntry(PieceType.booster, 1)],
  coins: [
    CoinData(4, 8.2),
    CoinData(10.5, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.gate(x: 8, y: 9.0, cycleSeconds: 3.0, openSeconds: 1.5),
    LevelHazard.gate(x: 13, y: 9.0, cycleSeconds: 4.0, openSeconds: 2.0),
  ],
);

/// Level 65 — "Orbit".
/// Unchi deck se lambi low-gravity float neeche deck tak.
/// Tray: Magnet x1.
/// Hal: magnet (7.5, 8.0) par — unchi deck (top 8) ke kinare se
/// drive off karo, zone mein ahista tair kar neeche deck
/// (8.5 se, top 9.5) par utro.
/// NOTE: poora ulta chakkar engine mein mumkin nahi — magnet
/// zone sirf 2m chauda hai. Ye lambi neeche ki taraf float hai,
/// orbit ka ehsas deti hai.
const LevelData level65 = LevelData(
  id: 65,
  world: 6,
  levelInWorld: 5,
  name: 'Orbit',
  terrain: [
    TerrainSegment(x: 0, y: 8, width: 6, height: 3),
    TerrainSegment(x: 8.5, y: 9.5, width: 11.5, height: 1.5),
  ],
  startX: 2,
  startY: 7.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.magnet, 1)],
  coins: [
    CoinData(3, 7.2),
    CoinData(7.5, 7.0),
    CoinData(15, 8.7),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  waterZones: [(x: 6, width: 2.5)],
);

/// Level 66 — "Balance Point".
/// Gap par see-saw — gari ke wazan se takhta jhukta hai.
/// SEE-SAW UNLOCKED.
/// Tray: See-Saw x1.
/// Hal: seesaw (8.2, 9.3) par — gas-only; takhta jhuk kar gari
/// ko paar le jata hai (seesaw tuning template). Design mein
/// beech mein rukna skill hai, playtest gas-only se bhi pass
/// hota hai.
const LevelData level66 = LevelData(
  id: 66,
  world: 6,
  levelInWorld: 6,
  name: 'Balance Point',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 11, y: 9, width: 9, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.seesaw, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(9.5, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  waterZones: [(x: 8, width: 3)],
);

/// Level 67 — "Tip and Launch".
/// See-saw tip ho kar gari ko ramp par gira deti hai — chain reaction.
/// Tray: See-Saw x1, Ramp x1.
/// Hal: seesaw (8.2, 9.3) par, ramp (12.0, 8.5) par (island 11-14
/// par) — tip kar ke island par utro, phir ramp se 2m gap jump karo.
const LevelData level67 = LevelData(
  id: 67,
  world: 6,
  levelInWorld: 7,
  name: 'Tip and Launch',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 11, y: 9, width: 3, height: 2),
    TerrainSegment(x: 16, y: 9, width: 4, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.seesaw, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(9.5, 8.2),
    CoinData(15, 7.2),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  waterZones: [(x: 8, width: 3), (x: 14, width: 2)],
);

/// Level 68 — "Low-G Seesaw".
/// See-saw, lamba aur ahista — road landing strip ke saath.
/// Tray: See-Saw x1, Road x1.
/// Hal: seesaw (8.2, 9.3) par, road (11.2, 9.3) tap se 11-13
/// landing strip par — tip kar ke road par utro.
/// NOTE: tray mein magnet nahi, is liye koi asli low-G zone nahi —
/// "slow tip" standard seesaw crossing hai, road strip ke saath.
const LevelData level68 = LevelData(
  id: 68,
  world: 6,
  levelInWorld: 8,
  name: 'Low-G Seesaw',
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
  goldTimeSeconds: 22,
  surface: SurfaceType.normal,
  waterZones: [(x: 8, width: 3)],
);

/// Level 69 — "Gravity Flip".
/// Do floats: floor route, phir do magnet zones se neeche decks tak.
/// Tray: Magnet x2, Road x1.
/// Hal: road (3.2, 9.3) tap se 3-5 runway par, magnet (6.5, 8.0)
/// par (gap 1: 5-7.5, mid deck top 9.5), magnet (13, 8.5) par
/// (gap 2: 12-14, final deck top 9.5) — do zones poora level
/// tay karte hain.
/// NOTE: ceiling nahi — do low-gravity floats, decks 0.5m neeche.
/// Final deck top 9.5 hai warna finish trigger nahi hota (probe P9).
const LevelData level69 = LevelData(
  id: 69,
  world: 6,
  levelInWorld: 9,
  name: 'Gravity Flip',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7.5, y: 9.5, width: 4.5, height: 1.5),
    TerrainSegment(x: 14, y: 9.5, width: 6, height: 1.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.magnet, 2), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(6.5, 8.0),
    CoinData(13, 8.8),
  ],
  goldTimeSeconds: 22,
  surface: SurfaceType.normal,
  waterZones: [(x: 5, width: 2.5), (x: 12, width: 2)],
);

/// Level 70 — "Asteroid Field".
/// Booster jump, upar se pathar girte hain — beech se guzro.
/// Tray: Ramp x1, Booster x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, ramp (5.0, 8.5) par —
/// boost ke saath 6m gap jump karo. Rockfall (7, 2) se: pehla
/// pathar GO ke 5s baad, phir har 6s — gari us se pehle guzar
/// jati hai, ahista khelne wale ko pathar milte hain.
const LevelData level70 = LevelData(
  id: 70,
  world: 6,
  levelInWorld: 10,
  name: 'Asteroid Field',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 1), TrayEntry(PieceType.booster, 1)],
  coins: [
    CoinData(3.5, 8.2),
    CoinData(7, 6.9),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  waterZones: [(x: 4, width: 6)],
  hazards: [
    LevelHazard.rockfall(x: 7, y: 2, intervalSeconds: 6.0, firstAfterSeconds: 5.0),
  ],
);

/// Level 71 — "Docking Bay".
/// Chhota finish dock — upar se jump kar ke seedha dock par utro.
/// Tray: Road x1, Ramp x1.
/// Hal: road (9.2, 9.3) tap se 9-11 dock pad par, ramp (6.0, 8.5)
/// par — kinare ke paas ramp se uchhal kar dock pad par utro,
/// finish (x=11) pad par hi hai. Dock kaafi chauda hai taake
/// landing fair ho.
const LevelData level71 = LevelData(
  id: 71,
  world: 6,
  levelInWorld: 11,
  name: 'Docking Bay',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 9, y: 9, width: 11, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 11,
  tray: [TrayEntry(PieceType.road, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(7.5, 7.2),
    CoinData(10, 8.2),
  ],
  goldTimeSeconds: 20,
  surface: SurfaceType.normal,
  waterZones: [(x: 6, width: 3)],
);

/// Level 72 — "Station Exam".
/// See-saw, ramp jump, magnet float aur airlock gate — World 6 ka test.
/// Tray: Magnet x1, See-Saw x1, Road x1, Ramp x1.
/// Hal: seesaw (8.2, 9.3) par, ramp (12.0, 8.5) par (island 11-14),
/// magnet (15.5, 8.0) par (gap 14-17 float), road (17.2, 9.3) tap
/// se 17-19 landing strip par — phir airlock gate (x=18, cycle 4s,
/// open 2s) par ruko, khulne par finish (x=19).
/// NOTE: pehli koshish mein gate ramp par tha (x=12) aur gari flip
/// ho jati thi — gate final deck par le jaya gaya (probe P15c).
const LevelData level72 = LevelData(
  id: 72,
  world: 6,
  levelInWorld: 12,
  name: 'Station Exam',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 11, y: 9, width: 3, height: 2),
    TerrainSegment(x: 17, y: 9, width: 3, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [
    TrayEntry(PieceType.magnet, 1),
    TrayEntry(PieceType.seesaw, 1),
    TrayEntry(PieceType.road, 1),
    TrayEntry(PieceType.ramp, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(9.5, 8.2),
    CoinData(15.5, 7.8),
  ],
  goldTimeSeconds: 24,
  surface: SurfaceType.normal,
  waterZones: [(x: 8, width: 3), (x: 14, width: 3)],
  hazards: [
    LevelHazard.gate(x: 18, y: 9.0, cycleSeconds: 4.0, openSeconds: 2.0),
  ],
);

/// World 6 ke poore 12 levels.
const List<LevelData> world6Levels = [
  level61,
  level62,
  level63,
  level64,
  level65,
  level66,
  level67,
  level68,
  level69,
  level70,
  level71,
  level72,
];
