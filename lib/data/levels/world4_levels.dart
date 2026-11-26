// World 4 — Night City, Levels 37-48.
// Level design doc se liya gaya: naam, tray, twist.
// Surface: normal. Geometry (metre, y neeche ki taraf): zameen ki
// satah y=9, duniya 20x11. Coin heights: road par y=8.2, ledge
// (top y=8.5) par y=7.7, jump ki hawa mein flight line par.
// Hal (solution) har level ke comment mein — gameplay test wahi khelta hai.
import '../models/level_data.dart';
import '../models/piece_type.dart';

/// Level 37 — "Rooftops".
/// Chhaton par seedhiyan — upar charho, neeche utro.
/// Tray: Road x2, Ramp x1.
/// Hal: road (5.2, 9.3), ramp (6.5, 8.5), road (12.2, 9.3) — L8 pattern.
const LevelData level37 = LevelData(
  id: 37,
  world: 4,
  levelInWorld: 1,
  name: 'Rooftops',
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

/// Level 38 — "The Lift".
/// Lift par sawaar ho kar upar wali manzil par jao.
/// Tray: Road x1 (spare — lift khud kaam karti hai).
/// Hal: koi piece nahi — scripted drive: gas 0-1.2s, coast 1.2-3.5s,
/// phir gas. Lift 1.5-3.0s mein upar jati hai, gari sawaar ho kar utarti hai.
const LevelData level38 = LevelData(
  id: 38,
  world: 4,
  levelInWorld: 2,
  name: 'The Lift',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7.75, y: 6, width: 12.25, height: 5),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(6.4, 7.0),
    CoinData(12, 5.2),
  ],
  goldTimeSeconds: 18,
  hazards: [
    LevelHazard.lift(x: 6.375, y: 9.0, y2: 6.0, periodSeconds: 6.0),
  ],
);

/// Level 39 — "Neon Alley".
/// Tنگ gali mein dumpster (1m block) — ramp se us ke upar se guzro.
/// Tray: Ramp x1, Road x1 (road spare).
/// Hal: ramp (9.5, 8.5) par — block (10-11) ke upar se (L30 pattern).
const LevelData level39 = LevelData(
  id: 39,
  world: 4,
  levelInWorld: 3,
  name: 'Neon Alley',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 20, height: 2),
    TerrainSegment(x: 10, y: 8, width: 1, height: 1),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 1), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(10.5, 7.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
);

/// Level 40 — "Loop the Loop".
/// Sheher ke beech pehla loop — booster se raftaar pakro.
/// LOOP UNLOCKED.
/// Tray: Loop x1, Booster x1.
/// Hal: booster (3.2, 9.3), loop (10, 7.0). Gas-only bhi pass hota hai.
const LevelData level40 = LevelData(
  id: 40,
  world: 4,
  levelInWorld: 4,
  name: 'Loop the Loop',
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
  goldTimeSeconds: 15,
);

/// Level 41 — "Loop + Landing".
/// Loop ke baad seedha nadi par bridge — landing saaf honi chahiye.
/// Tray: Loop x1, Bridge x1.
/// Hal: loop (10, 7.0), bridge (13.2, 9.3) — loop ke baad bridge par utro.
const LevelData level41 = LevelData(
  id: 41,
  world: 4,
  levelInWorld: 5,
  name: 'Loop + Landing',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 13, height: 2),
    TerrainSegment(x: 17, y: 9, width: 3, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.loop, 1), TrayEntry(PieceType.bridge, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(12, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 13, width: 4)],
);

/// Level 42 — "Traffic Lights".
/// Timed gate — laal batti par ruko, hari par guzro.
/// Tray: Road x1, Booster x1 (dono spare).
/// Hal: koi piece nahi — gas-only; gari band gate par rukti hai,
/// khulne par guzar jati hai.
const LevelData level42 = LevelData(
  id: 42,
  world: 4,
  levelInWorld: 6,
  name: 'Traffic Lights',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.road, 1), TrayEntry(PieceType.booster, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(12, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 16,
  hazards: [
    LevelHazard.gate(x: 10, y: 9.0, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

/// Level 43 — "Parking Garage".
/// Garage ki do manzilein — upar wali manzil (top 8.5) se neeche
/// wali (top 9) par utro, phir ramp se wapas upar charho.
/// Tray: Ramp x2, Road x1.
/// Hal: road (6.2, 9.3) se 6-8 gap bharo (upar se 0.5m drop, flat
/// landing), ramp (12.5, 8.5) se 12-14 par charho — us ka low end
/// neeche wali manzil (top 9) par hai, high end upar wali (top 8.5)
/// par utarta hai. Doosra ramp spare hai.
const LevelData level43 = LevelData(
  id: 43,
  world: 4,
  levelInWorld: 7,
  name: 'Parking Garage',
  terrain: [
    TerrainSegment(x: 0, y: 8.5, width: 6, height: 2.5),
    TerrainSegment(x: 8, y: 9, width: 4, height: 2),
    TerrainSegment(x: 14, y: 8.5, width: 6, height: 2.5),
  ],
  startX: 2,
  startY: 7.83,
  finishX: 17,
  tray: [TrayEntry(PieceType.ramp, 2), TrayEntry(PieceType.road, 1)],
  coins: [
    CoinData(4, 7.7),
    CoinData(10, 8.2),
    CoinData(16, 7.7),
  ],
  goldTimeSeconds: 18,
  waterZones: [(x: 6, width: 2), (x: 12, width: 2)],
);

/// Level 44 — "Billboard Jump".
/// Billboard ke neeche se boost kar ke chauda gap paar karo.
/// Tray: Booster x1, Ramp x1.
/// Hal: booster (3.2, 9.3), ramp (4.5, 8.5) — L27 pattern, 6m gap.
const LevelData level44 = LevelData(
  id: 44,
  world: 4,
  levelInWorld: 8,
  name: 'Billboard Jump',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 6, height: 2),
    TerrainSegment(x: 12, y: 9, width: 8, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.booster, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(5, 8.2),
    CoinData(9, 7.0),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 6, width: 6)],
);

/// Level 45 — "Double Loop".
/// Do loops, ek ke baad ek — raftaar barkarar rakho.
/// Tray: Loop x2, Booster x1.
/// Hal: booster (3.2, 9.3), loop (7, 7.0), loop (13, 7.0) — gas on rakho.
/// Pehla coin booster par (3, 8.2); doosra loopon ke beech (10, 8.2).
const LevelData level45 = LevelData(
  id: 45,
  world: 4,
  levelInWorld: 9,
  name: 'Double Loop',
  terrain: [TerrainSegment(x: 0, y: 9, width: 20, height: 2)],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.loop, 2), TrayEntry(PieceType.booster, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(10, 8.2),
    CoinData(16, 8.2),
  ],
  goldTimeSeconds: 18,
);

/// Level 46 — "Rush Hour".
/// Lift, phir loop, phir timed gate — teeno ek run mein.
/// Tray: Loop x1, Road x2 (roads spare).
/// Hal: loop (14, 6.0) — scripted drive: gas 0-1.2s, coast 1.2-3.5s
/// (lift par sawaar), phir gas. Gate (x=18) band ho to gari ruk kar
/// khulne ka intezar karti hai, phir finish (x=19).
/// NOTE (loop + lift): loop ka entry ramp zameen y=9 ke hisab se
/// banta hai (groundTop fixed) — 3m lift (y2=6) par loop (4.0) ka
/// ramp poori level mein phail kar lift ko kaat-ta hai (probe:
/// gari lift par ulta ho jati hai). Is liye lift sirf 1m (y2=8)
/// aur loop upar wali manzil (top 8) par centre (14, 6.0) —
/// ramp ka nichla hissa manzil ke andar daba rehta hai, lift se
/// takrata nahi. Twist wahi hai: moving lift + loop + gate.
const LevelData level46 = LevelData(
  id: 46,
  world: 4,
  levelInWorld: 10,
  name: 'Rush Hour',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7.75, y: 8, width: 12.25, height: 3),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [TrayEntry(PieceType.loop, 1), TrayEntry(PieceType.road, 2)],
  coins: [
    CoinData(3, 8.2),
    CoinData(6.4, 7.8),
    CoinData(17, 7.2),
  ],
  goldTimeSeconds: 20,
  hazards: [
    LevelHazard.lift(x: 6.375, y: 9.0, y2: 8.0, periodSeconds: 6.0),
    LevelHazard.gate(x: 18, y: 8.0, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

/// Level 47 — "Blackout".
/// Andheri gali mein nadi par bridge — dheere, saaf.
/// Tray: Bridge x1, Ramp x1 (ramp spare).
/// Hal: bridge (4.2, 9.3) — 4m gap par.
const LevelData level47 = LevelData(
  id: 47,
  world: 4,
  levelInWorld: 11,
  name: 'Blackout',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 4, height: 2),
    TerrainSegment(x: 8, y: 9, width: 12, height: 2),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 17,
  tray: [TrayEntry(PieceType.bridge, 1), TrayEntry(PieceType.ramp, 1)],
  coins: [
    CoinData(3, 8.2),
    CoinData(6, 8.2),
    CoinData(15, 8.2),
  ],
  goldTimeSeconds: 16,
  waterZones: [(x: 4, width: 4)],
);

/// Level 48 — "City Exam".
/// Night City ka imtihan — chhat (top 9) se lift par upar wali
/// chhat (top 8), booster + loop, road se 14-16 gap, phir timed gate.
/// Tray: Loop x1, Booster x1, Road x2, Ramp x1 (ramp spare, ek road spare).
/// Hal: booster (8.2, 8.3), loop (13.5, 6.0), road (14.2, 8.3) —
/// scripted drive: gas 0-1.2s, coast 1.2-3.5s (lift), phir gas.
/// Gate (x=18) band ho to gari ruk kar khulne ka intezar karti hai.
/// NOTE: L46 wali wajah se lift 1m (y2=8) hai — 3m lift par loop ka
/// entry ramp lift ko kaat-ta hai (probe se verify).
const LevelData level48 = LevelData(
  id: 48,
  world: 4,
  levelInWorld: 12,
  name: 'City Exam',
  terrain: [
    TerrainSegment(x: 0, y: 9, width: 5, height: 2),
    TerrainSegment(x: 7.75, y: 8, width: 6.25, height: 3),
    TerrainSegment(x: 16, y: 8, width: 4, height: 3),
  ],
  startX: 2,
  startY: 8.33,
  finishX: 19,
  tray: [
    TrayEntry(PieceType.loop, 1),
    TrayEntry(PieceType.booster, 1),
    TrayEntry(PieceType.road, 2),
    TrayEntry(PieceType.ramp, 1),
  ],
  coins: [
    CoinData(3, 8.2),
    CoinData(6.4, 7.8),
    CoinData(17, 7.2),
  ],
  goldTimeSeconds: 22,
  hazards: [
    LevelHazard.lift(x: 6.375, y: 9.0, y2: 8.0, periodSeconds: 6.0),
    LevelHazard.gate(x: 18, y: 8.0, cycleSeconds: 3.0, openSeconds: 1.5),
  ],
);

/// World 4 ke 12 levels.
const List<LevelData> world4Levels = [
  level37,
  level38,
  level39,
  level40,
  level41,
  level42,
  level43,
  level44,
  level45,
  level46,
  level47,
  level48,
];
