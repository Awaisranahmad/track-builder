// World 7 — Volcano, Levels 73-84.
// Level design doc page 8 se liya gaya: naam, tray, twist.
// Surface: normal for all. Lava chhoona = foran fail — is liye
// lava gaps ke neeche (y=10) hai, road level (y=9) se neeche.
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Coin heights: road par y=8.2, ledge (top y=8.5)
// par y=7.7, jump ki hawa mein flight line par.
// Hal (solution) har level ke comment mein — gameplay_test wahi khelta hai.
//
// NOTE (L78 Cooling Rocks): design doc ke mutabiq pathar 3 second
// baad doobne chahiye — engine ka crumble timer fixed 1.5s hai
// (CrumbleValues.breakAfterSeconds), is liye hops chhote rakhe hain:
// gari har pathar ~0.7s mein paar karti hai.
import '../../core/constants.dart';
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 73 — "Lava Line".
/// Lava pool ke upar familiar bridge level — Volcano tutorial:
/// build World 1 jaisa easy hai, sirf fail state naya hai.
/// Tray: Bridge x1, Road x1.
/// Hal: bridge 6-10 par (tap 6.2, 9.3) — road spare hai.
const LevelData level73 = LevelData(
  id: 73,
  world: 7,
  levelInWorld: 1,
  name: 'Lava Line',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(8, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 14,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.0, width: 4),
  ],
);

/// Level 74 — "Hot Bridge".
/// Bridge gari ke wazan se ahista lava ki taraf dhansta hai —
/// ruko mat, tez guzro. Beech mein support road safety deti hai.
/// Tray: Bridge x1, Road x1.
/// Hal: bridge 6-10 par (tap 6.2, 9.3), road 6-8 par
/// (tap 6.2, 9.3) — bridge ke pehle hisse par support, gari
/// dhanste hisse par kam waqt guzarti hai.
const LevelData level74 = LevelData(
  id: 74,
  world: 7,
  levelInWorld: 2,
  name: 'Hot Bridge',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(7, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.0, width: 4),
    LevelHazard.sinkingBridge(rate: 0.3),
  ],
);

/// Level 75 — "Gate Keeper".
/// Lava channel ke upar do timed gates — boost se gate one se,
/// coast kar ke gate two se guzro.
/// Tray: Booster x1, Road x1.
/// Hal: booster (5.2, 9.3) tap se 5-6 par, road (6.2, 9.3) tap se
/// 6-8 par. Gate one (x=7) 2s tak khula rehta hai — gari ~1.3s par
/// sensor mein hoti hai, gate khula rehta hai. Gate two (x=14) par
/// gari intezar karti hai, 3s par khulta hai.
/// NOTE (probe se): flat booster jump same-height kinare par nahi
/// utar sakta — gari 3m mein ~0.5m gir jati hai aur door wale kinare
/// ki deewar se takrati hai. Is liye far bank 0.5m neeche hai
/// (top 9.5) — gari us ke upar utarti hai. Finish zone (y 6-9)
/// phir bhi gari ko pakarta hai (centre ~8.83).
const LevelData level75 = LevelData(
  id: 75,
  world: 7,
  levelInWorld: 3,
  name: 'Gate Keeper',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 9, y: 9.5, width: 11, height: 2.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.booster, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(8.5, 8.2),
    CoinData(15, 8.7),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.5, width: 3),
    LevelHazard.gate(x: 7, y: 9.0, cycleSeconds: 4.0, openSeconds: 2.0),
    LevelHazard.gate(x: 14, y: 9.5, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

/// Level 76 — "Eruption".
/// Lava geysers cycle par phoot-te hain — ramp se pehle geyser ke
/// upar se jump karo, doosre ke inactive window mein guzro.
/// Tray: Road x2, Ramp x1.
/// Hal: ramp (6.5, 8.5) par — geyser one (x=8) ke upar se jump,
/// gari ~1.8s par guzarti hai (geyser 1-3s inactive). Geyser two
/// (x=14, cycle 5s) 1-5s inactive — gari ~4.2s par guzarti hai.
/// Roads spare hain.
const LevelData level76 = LevelData(
  id: 76,
  world: 7,
  levelInWorld: 4,
  name: 'Eruption',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 20, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(11, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.geyser(x: 8, y: 9.0, cycleSeconds: 3.0, openSeconds: 1.0),
    LevelHazard.geyser(x: 14, y: 9.0, cycleSeconds: 5.0, openSeconds: 1.0),
  ],
);

/// Level 77 — "Lava Run".
/// Lamba level, lava floor poore raaste — ek ghalti = restart.
/// Tray: Bridge x1, Ramp x1, Booster x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, bridge (4.2, 9.3) tap se
/// 4-8 par, ramp (8.5, 8.5) par — low end bridge par. Boost + ramp
/// se jump kar ke island (12-17) par utro, finish 17.
const LevelData level77 = LevelData(
  id: 77,
  world: 7,
  levelInWorld: 5,
  name: 'Lava Run',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 12, y: 9, width: 5, height: 2),
    TerrainSegment(x: 18, y: 9, width: 2, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.booster, 1),
  ],
  coins: [
    CoinData(3, 8.2),
    CoinData(13, 6.5),
    CoinData(15, 7.4),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 4, y: 10.0, width: 8),
    LevelHazard.lava(x: 17, y: 10.0, width: 1),
  ],
);

/// Level 78 — "Cooling Rocks".
/// Lava par tairte pathar — stepping stones, chhote hops.
/// Tray: Road x1.
/// Hal: road (10.2, 9.3) tap se 10-12 par — teesre pathar par
/// reinforcement; pathar 6-8, 8-10, 10-12 aur 12-14 par se guzro.
/// NOTE: pathar engine ke 1.5s crumble timer se toot-te hain
/// (design doc ke 3s nahi) — gari har pathar ~0.7s mein paar karti hai.
/// NOTE (probe se): patharon ke beech 1m gap nahi rakh sakte — gari
/// gap mein gir kar agle pathar ki side se takra kar wapas phisalti
/// hai aur lava mein girti hai. Is liye pathar aapas mein mile hue
/// hain; challenge crumble timer hi hai.
const LevelData level78 = LevelData(
  id: 78,
  world: 7,
  levelInWorld: 6,
  name: 'Cooling Rocks',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 14, y: 9, width: 6, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(10, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.0, width: 8),
  ],
  crumblePlatforms: [
    TerrainSegment(x: 6, y: 9, width: 2, height: 2),
    TerrainSegment(x: 8, y: 9, width: 2, height: 2),
    TerrainSegment(x: 10, y: 9, width: 2, height: 2),
    TerrainSegment(x: 12, y: 9, width: 2, height: 2),
  ],
);

/// Level 79 — "Double Gate Loop".
/// Loop jiska entrance ek timed gate hai — gate timer aur loop
/// speed dono poori karni hain.
/// Tray: Loop x1, Booster x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, loop (11, 7.0) par.
/// Gate (x=7) cycle ke shuru mein khula hota hai — gari ~1.2s par
/// guzarti hai, sensor gate ko khula rakhta hai.
const LevelData level79 = LevelData(
  id: 79,
  world: 7,
  levelInWorld: 7,
  name: 'Double Gate Loop',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 20, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.loop, 1), TrayEntry(PieceType.booster, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(14, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.gate(x: 7, y: 9.0, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

/// Level 80 — "Rising Lava".
/// Lava steadily upar aata hai — route upar charhta hai.
/// Springs escape tools bante hain. World 7 ka wahid rising-lava level.
/// Tray: Ramp x2, Spring x1, Road x1.
/// Hal: spring (5.2, 9.3) tap se 5-6 par — bounce kar ke ledge
/// (7-11, top 8.5) par utro; ramp (12.0, 8.0) par — ledge se
/// charh kar ledge two (13-20, top 8) par. Lava 0.25 m/s se upar
/// aata hai, gari ~5s mein finish karti hai (lava tab ~9.25 par).
/// Doosri ramp aur road spare hain.
const LevelData level80 = LevelData(
  id: 80,
  world: 7,
  levelInWorld: 8,
  name: 'Rising Lava',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7, y: 8.5, width: 4, height: 2.5),
    TerrainSegment(x: 13, y: 8, width: 7, height: 3),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.ramp, 2),
    TrayEntry(PieceType.spring, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(3, 8.2),
    CoinData(8, 4.7),
    CoinData(15, 7.2),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.risingLava(x: 0, y: 10.5, width: 20, rate: 0.25),
  ],
);

/// Level 81 — "Ember Rain".
/// Upar se pathar girte hain — bridge ko roads se reinforce karo.
/// Tray: Bridge x1, Road x2.
/// Hal: bridge 5-9 par (tap 5.2, 9.3), road 5-7 par (tap 5.2, 9.3)
/// — bridge ka pehla hissa support; doosri road 9-11 par
/// (tap 9.2, 9.3) landing ke baad. Pehla pathar 2.5s par girta hai,
/// gari tab tak 9 se aage hoti hai.
const LevelData level81 = LevelData(
  id: 81,
  world: 7,
  levelInWorld: 9,
  name: 'Ember Rain',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 9, y: 9, width: 11, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(4, 8.2),
    CoinData(7, 8.2),
    CoinData(14, 8.2),
  ],
  goldTimeSeconds: 16,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 5, y: 10.0, width: 4),
    LevelHazard.rockfall(
      x: 7,
      y: 2,
      intervalSeconds: 6.0,
      firstAfterSeconds: 2.5,
    ),
  ],
);

/// Level 82 — "The Crucible".
/// Lava ke upar see-saw, phir timed gate — Space ka sabr plus
/// Volcano ki ghari.
/// Tray: See-Saw x1, Road x1.
/// Hal: see-saw (8.2, 9.3) tap se 8-11 par (lava ke upar),
/// road (11.2, 9.3) tap se 11-13 par landing. Gate (x=14)
/// 3s par khulta hai — gari intezar karti hai.
const LevelData level82 = LevelData(
  id: 82,
  world: 7,
  levelInWorld: 10,
  name: 'The Crucible',
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
  goldTimeSeconds: 18,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 8, y: 10.0, width: 3),
    LevelHazard.gate(x: 14, y: 9.0, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

/// Level 83 — "Last Bridge".
/// Bohat bari lava lake, minimal tray — bridge akela paar nahi
/// kar sakta: bridge ke end se boost-jump karo.
/// Tray: Bridge x1, Booster x1, Ramp x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, bridge (6.2, 9.3) tap se
/// 6-10 par, ramp (10.5, 8.5) par — low end bridge par. Boost + ramp
/// se jump, finish (17) hawa mein hi trigger ho jata hai.
const LevelData level83 = LevelData(
  id: 83,
  world: 7,
  levelInWorld: 11,
  name: 'Last Bridge',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 14, y: 9, width: 6, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.ramp, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(14, 6.4),
    CoinData(16, 6.9),
  ],
  goldTimeSeconds: 18,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.0, width: 8),
  ],
);

/// Level 84 — "Volcano Exam".
/// Gates, geysers, loop aur sinking bridge ek hi run mein —
/// World 7 ka test.
/// Tray: Loop x1, Bridge x1, Booster x1, Road x1.
/// Hal: booster (3.2, 9.3) tap se 3-4 par, bridge (6.2, 9.3) tap se
/// 6-10 par (dhansta hua — tez guzro), loop (13, 7.0) par,
/// gate (x=17, cycle 6s, open 3s) gari ke aane par khula hota hai —
/// loop se gari ~2.3s par 8 m/s se aati hai, band gate se takra kar
/// atak jati thi (probe se), is liye gate ka cycle lamba hai.
/// Geyser (x=18.5, cycle 5s) ~2.8s par inactive. Road spare hai.
const LevelData level84 = LevelData(
  id: 84,
  world: 7,
  levelInWorld: 12,
  name: 'Volcano Exam',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 10, y: 9, width: 10, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [
    TrayEntry(PieceType.loop, 1),
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(5, 8.2),
    CoinData(16, 8.2),
    CoinData(18, 8.2),
  ],
  goldTimeSeconds: 22,
  surface: SurfaceType.normal,
  hazards: [
    LevelHazard.lava(x: 6, y: 10.0, width: 4),
    LevelHazard.sinkingBridge(rate: 0.3),
    LevelHazard.gate(x: 17, y: 9.0, cycleSeconds: 6.0, openSeconds: 3.0),
    LevelHazard.geyser(x: 18.5, y: 9.0, cycleSeconds: 5.0, openSeconds: 1.0),
  ],
);

/// World 7 ke poore 12 levels.
const List<LevelData> world7Levels = [
  level73,
  level74,
  level75,
  level76,
  level77,
  level78,
  level79,
  level80,
  level81,
  level82,
  level83,
  level84,
];
