// World 5 — Jungle Ruins, Levels 49-60.
// Level design doc se liya gaya: naam, tray, twist.
// Surface: normal for all. SPRING UNLOCKED (Level 50).
// Geometry (metre, y neeche ki taraf): zameen ki satah y=9,
// duniya 20x11. Coin heights: road par y=8.2, ledge (top y=8.5)
// par y=7.7, ledge (top y=8) par y=7.2, ledge (top y=7) par y=6.2,
// ledge (top y=6) par y=5.2, jump ki hawa mein flight line par.
// Hal (solution) har level ke comment mein — gameplay_world5_test
// wahi khelta hai.
//
// Spring physics (tuning test se verify): launch vy=8.5, gravity 10 —
// car centre ~3.6m upar uthta hai. Zameen (y=9, centre 8.33) se
// bounce kar ke ledge top y=6 par utarta hai (centre 5.33); spring
// se ledge tak ~1.5m run-up chahiye taake deewar ke kone se na takraye.
// Finish zone FIXED hai (y 6.0-9.0) — is liye finish wali ledge
// top y=6 ya us se neeche honi chahiye.
// Bridge roof: bridge ko uncha lagao (top y=7) to gari us ke neeche
// se guzar jati hai aur girte pathar bridge par atak jate hain.
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 49 — "Ruins Entrance".
/// Toote pathar ke steps, chhote gaps — jungle tutorial.
/// Tray: Road x2, Ramp x1.
/// Hal: road 4-6 par (tap 4.2, 9.3), road 10-12 par (tap 10.2, 9.3),
/// ramp (11.5, 8.5) par — low end road par, high end step (top y=8.5)
/// par utarta hai.
const LevelData level49 = LevelData(
  id: 49,
  world: 5,
  levelInWorld: 1,
  name: 'Ruins Entrance',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 4, height: 2),
    TerrainSegment(x: 12, y: 8.5, width: 8, height: 2.5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(8, 8.2),
    CoinData(15, 7.7),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 4, width: 2), (x: 10, width: 2)],
);

/// Level 50 — "Bounce!".
/// Deewar itni unchi ke charha na jaye, finish us ke upar.
/// SPRING UNLOCKED.
/// Tray: Spring x1, Road x1.
/// Hal: spring 6-7 par (tap 6.2, 9.3) — bounce kar ke ledge
/// (top y=6) par utro; road spare hai.
const LevelData level50 = LevelData(
  id: 50,
  world: 5,
  levelInWorld: 2,
  name: 'Bounce!',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 8, y: 6, width: 12, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.spring, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(10, 5.2),
    CoinData(15, 5.2),
  ],
  goldTimeSeconds: 16,
);

/// Level 51 — "Double Bounce".
/// Do ledges, seedhi (staircase) style — chained springs.
/// Tray: Spring x2, Road x1.
/// Hal: spring 4-5 par (tap 4.2, 9.3) — ledge1 (top y=8) par utro;
/// spring 10-11 par (tap 10.2, 8.3) — ledge2 (top y=6) par utro.
/// Landing ke beech short controlled stop nahi — gas hi rakho.
/// Road spare hai.
const LevelData level51 = LevelData(
  id: 51,
  world: 5,
  levelInWorld: 3,
  name: 'Double Bounce',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 6, y: 8, width: 7, height: 3),
    TerrainSegment(x: 13, y: 6, width: 7, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.spring, 2), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(9.5, 7.2),
    CoinData(16, 5.2),
  ],
  goldTimeSeconds: 18,
);

/// Level 52 — "Falling Rocks".
/// Har 4 second mein pathar girte hain — bridge roof banao.
/// Tray: Road x2, Bridge x1.
/// Hal: road 4-6 par (tap 4.2, 9.3); bridge roof 8-12 par,
/// top y=7 (tap 8.2, 7.3) — gari us ke neeche se guzarti hai,
/// pathar bridge par atak jate hain. Doosri road spare hai.
const LevelData level52 = LevelData(
  id: 52,
  world: 5,
  levelInWorld: 4,
  name: 'Falling Rocks',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 6, y: 9, width: 14, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.bridge, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(10, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 4, width: 2)],
  hazards: [
    LevelHazard.rockfall(x: 10, y: 2, intervalSeconds: 4.0, firstAfterSeconds: 2.5),
  ],
);

/// Level 53 — "Temple Steps".
/// Mandir ki bari seedhi — teen steps upar.
/// Tray: Ramp x3.
/// Hal: ramp (4.5, 8.5) par — step1 (top y=8) par;
/// ramp (9.5, 7.5) par — step2 (top y=7) par;
/// ramp (14.5, 6.5) par — step3 (top y=6) par, finish wahin.
const LevelData level53 = LevelData(
  id: 53,
  world: 5,
  levelInWorld: 5,
  name: 'Temple Steps',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 5, y: 8, width: 5, height: 3),
    TerrainSegment(x: 10, y: 7, width: 5, height: 4),
    TerrainSegment(x: 15, y: 6, width: 5, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 3)],
  coins: [
    CoinData(3, 8.2),
    CoinData(7.5, 7.2),
    CoinData(12.5, 6.2),
  ],
  goldTimeSeconds: 20,
);

/// Level 54 — "The Well".
/// Gehra kunwan, finish neeche, coins upar kinare par.
/// Tray: Spring x1, Road x1.
/// Hal: spring 7-8 par (tap 7.2, 9.3) — bounce karte hue
/// hawa wale coins (8.8, 5.2) aur (10.7, 5.2) lo, phir
/// kunwan (bottom y=10.5) mein gir kar finish (x=14.5) karo.
/// Road spare hai.
const LevelData level54 = LevelData(
  id: 54,
  world: 5,
  levelInWorld: 6,
  name: 'The Well',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 8, height: 2),
    TerrainSegment(x: 8, y: 10.5, width: 8, height: 0.5),
    TerrainSegment(x: 16, y: 9, width: 4, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 14.5,
  tray: [TrayEntry(PieceType.spring, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(8.8, 5.2),
    CoinData(10.7, 5.2),
  ],
  goldTimeSeconds: 18,
);

/// Level 55 — "Vine Swing".
/// Chaudi khaai, beech ke jazeere par spring.
/// Tray: Spring x1, Ramp x1, Bridge x1.
/// Hal: ramp (4.5, 8.5) se 2m gap jump kar ke jazeere (7-10) par;
/// spring 8-9 par (tap 8.2, 9.3) — tez bounce se khaai paar karo,
/// bridge 11-15 par (tap 11.2, 7.3, top y=7) landing pad hai
/// (car bridge ki height par utarta hai, is liye bridge khaai ke
/// bayein kinare se shuru hona chahiye); finish (x=17) far ground par.
const LevelData level55 = LevelData(
  id: 55,
  world: 5,
  levelInWorld: 7,
  name: 'Vine Swing',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7, y: 9, width: 3, height: 2),
    TerrainSegment(x: 15, y: 7, width: 5, height: 4),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [
    TrayEntry(PieceType.spring, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.bridge, 1),
  ],
  coins: [
    CoinData(3, 8.2),
    CoinData(10, 5.2),
    CoinData(12, 5.2),
  ],
  goldTimeSeconds: 20,
  waterZones: [(x: 5, width: 2), (x: 10, width: 5)],
);

/// Level 56 — "Crumble Stone".
/// Pathar ke platforms gari ke touch ke 1.5s baad toot jate hain.
/// Tray: Road x2.
/// Hal: kuch lagana nahi — gas hi rakho, ruko mat. Do 3m crumble
/// sections, beech mein 2m solid island. Roads spare hain.
const LevelData level56 = LevelData(
  id: 56,
  world: 5,
  levelInWorld: 8,
  name: 'Crumble Stone',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 8, y: 9, width: 2, height: 2),
    TerrainSegment(x: 13, y: 9, width: 7, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(3, 8.2),
    CoinData(6.5, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 5, width: 3), (x: 10, width: 3)],
  crumblePlatforms: [
    TerrainSegment(x: 5, y: 9, width: 3, height: 2),
    TerrainSegment(x: 10, y: 9, width: 3, height: 2),
  ],
);

/// Level 57 — "Rock Rain".
/// Bhari pathar barish, aakhir mein spring escape.
/// Tray: Bridge x1, Spring x1.
/// Hal: bridge roof 7-11 par, top y=7 (tap 7.2, 7.3) — gari
/// neeche se guzre, pathar upar atkein. Roof spring se pehle khatam
/// hona chahiye, warna spring bounce par gari roof se takra kar
/// atak jati hai; spring 12-13 par (tap 12.2, 9.3) — bounce kar ke
/// ledge (top y=6) par utro, finish wahin (x=18).
const LevelData level57 = LevelData(
  id: 57,
  world: 5,
  levelInWorld: 9,
  name: 'Rock Rain',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 14, height: 2),
    TerrainSegment(x: 14, y: 6, width: 6, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 18,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.spring, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(10, 8.2),
    CoinData(17, 5.2),
  ],
  goldTimeSeconds: 18,
  hazards: [
    LevelHazard.rockfall(x: 10, y: 2, intervalSeconds: 2.0, firstAfterSeconds: 2.5),
  ],
);

/// Level 58 — "Hidden Coins".
/// Aam sa level lagta hai; 2 coins main route ke neeche hain.
/// Tray: Road x2, Spring x1.
/// Hal: spring 4-5 par (tap 4.2, 9.3) — ledge (top y=8) par utro,
/// ledge coin (10.5, 7.2) lo, ledge ke end (x=12) se 0.5m neeche
/// low ground par giro — wahan 2 coins (13.5, 8.2) aur (15, 8.2)
/// hain; finish bhi neeche hai (x=17). Roads spare hain.
const LevelData level58 = LevelData(
  id: 58,
  world: 5,
  levelInWorld: 10,
  name: 'Hidden Coins',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 20, height: 2),
    TerrainSegment(x: 5, y: 8, width: 7, height: 3),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 2), TrayEntry(PieceType.spring, 1)],
  coins: [
    CoinData(10.5, 7.2),
    CoinData(13.5, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
);

/// Level 59 — "Temple Run".
/// Lambi charhai — crumble + pathar. Gold time ke liye zero hesitation.
/// Tray: Ramp x2, Spring x1, Road x1.
/// Hal: ramp (4.5, 8.5) se step1 (top y=8) par; ramp (9.5, 7.5)
/// se step2 (top y=7) par — crumble (11-13.5) tez paar karo;
/// spring 13-14 par (tap 13.2, 7.3) — final ledge (top y=6) par
/// utro, finish (x=19) wahin. Road spare hai.
const LevelData level59 = LevelData(
  id: 59,
  world: 5,
  levelInWorld: 11,
  name: 'Temple Run',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 5, y: 8, width: 5, height: 3),
    TerrainSegment(x: 10, y: 7, width: 1, height: 4),
    TerrainSegment(x: 13.5, y: 7, width: 1.5, height: 4),
    TerrainSegment(x: 15, y: 6, width: 5, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [
    TrayEntry(PieceType.ramp, 2),
    TrayEntry(PieceType.spring, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(3, 8.2),
    CoinData(7, 7.2),
    CoinData(12, 6.2),
  ],
  goldTimeSeconds: 22,
  hazards: [
    LevelHazard.rockfall(x: 12, y: 2, intervalSeconds: 4.0, firstAfterSeconds: 4.0),
  ],
  crumblePlatforms: [
    TerrainSegment(x: 11, y: 7, width: 2.5, height: 2),
  ],
);

/// Level 60 — "Ruins Exam".
/// Deewar, khaai, pathar barish aur mandir top finish — World 5 ka test.
/// Tray: Spring x1, Bridge x1, Ramp x1, Road x1.
/// Hal: ramp (3.5, 8.5) se step (top y=8) par — ramp step se pehle
/// khatam hona chahiye, warna gari step ke kone se takra kar
/// uchhalti hai; spring 6-7 par (tap 6.2, 8.3) — ledge (top y=6)
/// par utro (spring deewar ke qareeb honi chahiye, warna gari
/// deewar ke kone par gir kar flip hoti hai); bridge 14-18 par
/// (tap 14.2, 6.3, top y=6) — khaai paar karo; finish (x=19)
/// temple top (top y=6) par. Road spare hai.
const LevelData level60 = LevelData(
  id: 60,
  world: 5,
  levelInWorld: 12,
  name: 'Ruins Exam',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 5, y: 8, width: 4, height: 3),
    TerrainSegment(x: 9, y: 6, width: 5, height: 5),
    TerrainSegment(x: 18, y: 6, width: 2, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [
    TrayEntry(PieceType.spring, 1),
    TrayEntry(PieceType.bridge, 1),
    TrayEntry(PieceType.ramp, 1),
    TrayEntry(PieceType.road, 1),
  ],
  coins: [
    CoinData(2, 8.2),
    CoinData(10.5, 5.2),
    CoinData(16, 5.2),
  ],
  goldTimeSeconds: 22,
  waterZones: [(x: 14, width: 4)],
  hazards: [
    LevelHazard.rockfall(x: 16, y: 2, intervalSeconds: 4.0, firstAfterSeconds: 6.0),
  ],
);

/// World 5 ke poore 12 levels.
const List<LevelData> world5Levels = [
  level49,
  level50,
  level51,
  level52,
  level53,
  level54,
  level55,
  level56,
  level57,
  level58,
  level59,
  level60,
];
