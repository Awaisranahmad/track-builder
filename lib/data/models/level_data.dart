// Level ka data model — har level sirf ye data hai, code nahi.
// Design rule 3: level ka data kabhi game code mein hardcode nahi hoga.
import '../../core/constants.dart';
import 'piece_type.dart';

/// Zameen ka fixed hissa — jo hissa player nahi banata.
/// x, y upar-bayein kone ki position (metre), width/height size.
class TerrainSegment {
  const TerrainSegment({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
  });

  final double x;
  final double y;
  final double width;
  final double height;

  /// Is point ke andar hai ya nahi — validation ke liye.
  bool contains(double px, double py) {
    return px >= x && px <= x + width && py >= y && py <= y + height;
  }
}

/// Tray ka ek slot — konsa piece, kitne.
class TrayEntry {
  const TrayEntry(this.type, this.count);

  final PieceType type;
  final int count;
}

/// Coin ki position (metre).
class CoinData {
  const CoinData(this.x, this.y);

  final double x;
  final double y;
}

/// Hazard ki qisam — Phase 4/5: level mein timed khatra.
enum HazardType {
  /// Bridge gari ke touch ke itne second baad toot jata hai (L34 Thin Ice).
  bridgeBreak,

  /// Barf ka gola dhalwan se ludhakta hua raasta kaatta hai (L35).
  snowball,

  /// Lift platform upar-neeche chalti hai (L38, World 4).
  lift,

  /// Timed gate — deewar cycle par khulti/band hoti hai (L42, World 4/7).
  gate,

  /// Lava zone — chhoona = foran fail (L73, World 7).
  lava,

  /// Lava jo waqt ke saath upar aata hai (L80 Rising Lava).
  risingLava,

  /// Pathar upar se girte hain, gari ko dhakka dete hain (L52, World 5).
  rockfall,

  /// Lava geyser — cycle par phoot-ta hai, active ho to fail (L76).
  geyser,

  /// Hawa ka zone — gust par gari ko dhakelti hai (L86, World 8).
  wind,

  /// Bridge gari ke wazan se ahista neeche dhansta hai (L74 Hot Bridge).
  sinkingBridge,
}

/// Ek hazard — level data mein, sirf data hai (design rule 3).
class LevelHazard {
  /// Bridge-break hazard — [afterSeconds] gari ke touch ke baad tootne ka waqt.
  const LevelHazard.bridgeBreak({required this.afterSeconds})
      : type = HazardType.bridgeBreak,
        x = 0,
        y = 0,
        x2 = 0,
        y2 = 0,
        width = 0,
        height = 0,
        intervalSeconds = 0,
        firstAfterSeconds = 0,
        cycleSeconds = 0,
        openSeconds = 0,
        rate = 0,
        strength = 0,
        periodSeconds = 0;

  /// Snowball hazard — [x], [y] spawn point (upar, dhalwan ke upar),
  /// [firstAfterSeconds] pehle gole ka waqt (GO ke baad), phir har
  /// [intervalSeconds] par ek naya gola.
  const LevelHazard.snowball({
    required this.x,
    required this.y,
    this.intervalSeconds = 4.0,
    this.firstAfterSeconds = 2.5,
  }) : type = HazardType.snowball,
       afterSeconds = 0,
       x2 = 0,
       y2 = 0,
       width = 0,
       height = 0,
       cycleSeconds = 0,
       openSeconds = 0,
       rate = 0,
       strength = 0,
       periodSeconds = 0;

  /// Lift hazard — platform [x] par, [y] (neeche) se [y2] (upar) tak
  /// chalti hai; [periodSeconds] ek poora upar-neeche cycle.
  const LevelHazard.lift({
    required this.x,
    required this.y,
    required this.y2,
    this.periodSeconds = 6.0,
  }) : type = HazardType.lift,
       afterSeconds = 0,
       x2 = 0,
       width = 0,
       height = 0,
       intervalSeconds = 0,
       firstAfterSeconds = 0,
       cycleSeconds = 0,
       openSeconds = 0,
       rate = 0,
       strength = 0;

  /// Timed gate — deewar [x] par, zameen [y] (band position ka neeche
  /// wala sira) par; [cycleSeconds] poora cycle, [openSeconds] khula
  /// rehne ka waqt (cycle ke shuru mein khula hota hai).
  const LevelHazard.gate({
    required this.x,
    required this.y,
    this.cycleSeconds = 3.0,
    this.openSeconds = 1.5,
  }) : type = HazardType.gate,
       afterSeconds = 0,
       x2 = 0,
       y2 = 0,
       width = 0,
       height = 0,
       intervalSeconds = 0,
       firstAfterSeconds = 0,
       rate = 0,
       strength = 0,
       periodSeconds = 0;

  /// Lava zone — [x] se [x] + [width] tak, upar ki satah [y] par.
  /// Chhoona = foran fail.
  const LevelHazard.lava({
    required this.x,
    required this.y,
    required this.width,
  }) : type = HazardType.lava,
       afterSeconds = 0,
       x2 = 0,
       y2 = 0,
       height = 0,
       intervalSeconds = 0,
       firstAfterSeconds = 0,
       cycleSeconds = 0,
       openSeconds = 0,
       rate = 0,
       strength = 0,
       periodSeconds = 0;

  /// Rising lava — lava zone jaisi, lekin satah [rate] metre/second
  /// se upar aati hai (GO se shuru).
  const LevelHazard.risingLava({
    required this.x,
    required this.y,
    required this.width,
    this.rate = LavaValues.riseRate,
  }) : type = HazardType.risingLava,
       afterSeconds = 0,
       x2 = 0,
       y2 = 0,
       height = 0,
       intervalSeconds = 0,
       firstAfterSeconds = 0,
       cycleSeconds = 0,
       openSeconds = 0,
       strength = 0,
       periodSeconds = 0;

  /// Rockfall — pathar [x], [y] se girte hain; pehla [firstAfterSeconds]
  /// baad, phir har [intervalSeconds] par.
  const LevelHazard.rockfall({
    required this.x,
    required this.y,
    this.intervalSeconds = 4.0,
    this.firstAfterSeconds = 2.0,
  }) : type = HazardType.rockfall,
       afterSeconds = 0,
       x2 = 0,
       y2 = 0,
       width = 0,
       height = 0,
       cycleSeconds = 0,
       openSeconds = 0,
       rate = 0,
       strength = 0,
       periodSeconds = 0;

  /// Geyser — [x] par column, zameen [y] se [height] uncha;
  /// [cycleSeconds] ka cycle, [openSeconds] active rehne ka waqt.
  const LevelHazard.geyser({
    required this.x,
    required this.y,
    this.height = 3.0,
    this.cycleSeconds = 3.0,
    this.openSeconds = 1.0,
  }) : type = HazardType.geyser,
       afterSeconds = 0,
       x2 = 0,
       y2 = 0,
       width = 0,
       intervalSeconds = 0,
       firstAfterSeconds = 0,
       rate = 0,
       strength = 0,
       periodSeconds = 0;

  /// Wind zone — [x] se [x] + [width] tak, [y] se [y] + [height] tak;
  /// gust [cycleSeconds] ka cycle, [openSeconds] gust ki lambai;
  /// [strength] +1 matlab dahine, -1 matlab bayein dhakelna.
  const LevelHazard.wind({
    required this.x,
    required this.y,
    required this.width,
    this.height = 5.0,
    this.cycleSeconds = 4.0,
    this.openSeconds = 2.0,
    this.strength = 1.0,
  }) : type = HazardType.wind,
       afterSeconds = 0,
       x2 = 0,
       y2 = 0,
       intervalSeconds = 0,
       firstAfterSeconds = 0,
       rate = 0,
       periodSeconds = 0;

  /// Sinking bridge — tray ka bridge gari ke wazan se [rate]
  /// metre/second neeche dhansta hai.
  const LevelHazard.sinkingBridge({this.rate = 0.3})
      : type = HazardType.sinkingBridge,
        afterSeconds = 0,
        x = 0,
        y = 0,
        x2 = 0,
        y2 = 0,
        width = 0,
        height = 0,
        intervalSeconds = 0,
        firstAfterSeconds = 0,
        cycleSeconds = 0,
        openSeconds = 0,
        strength = 0,
        periodSeconds = 0;

  final HazardType type;

  /// Bridge-break: tootne ka waqt (seconds).
  final double afterSeconds;

  /// Hazard ki position (metre) — snowball/rockfall spawn,
  /// lift/gate/geyser x, lava/wind zone ka bayein kinara.
  final double x;
  final double y;

  /// Lift: upar wala sira (y2) — doosri position.
  final double x2;
  final double y2;

  /// Lava/wind zone ki chaudai.
  final double width;

  /// Geyser/wind zone ki unchai.
  final double height;

  /// Snowball/rockfall: gole/pathar ke beech waqfa (seconds).
  final double intervalSeconds;

  /// Snowball/rockfall: pehla gole/pathar GO ke kitne second baad.
  final double firstAfterSeconds;

  /// Gate/geyser/wind: poora cycle (seconds).
  final double cycleSeconds;

  /// Gate/geyser/wind: khula/active rehne ka waqt (seconds).
  final double openSeconds;

  /// Rising lava / sinking bridge: raftaar (metre/second).
  final double rate;

  /// Wind: direction (+1 dahine, -1 bayein).
  final double strength;

  /// Lift: poora upar-neeche cycle (seconds).
  final double periodSeconds;
}

/// Poore level ki definition — ek record, koi code nahi.
class LevelData {
  const LevelData({
    required this.id,
    required this.world,
    required this.levelInWorld,
    required this.name,
    required this.terrain,
    required this.startX,
    required this.startY,
    required this.finishX,
    required this.tray,
    required this.coins,
    required this.goldTimeSeconds,
    this.surface = SurfaceType.normal,
    this.waterZones = const [],
    this.hazards = const [],
    this.crumblePlatforms = const [],
  });

  /// Global number (1-96).
  final int id;

  /// World number (1-8).
  final int world;

  /// World ke andar number (1-12).
  final int levelInWorld;

  final String name;

  /// Fixed zameen.
  final List<TerrainSegment> terrain;

  /// Gari ki shuru ki position.
  final double startX;
  final double startY;

  /// Finish flag ki position (x).
  final double finishX;

  /// Is level mein konsay pieces, kitne.
  final List<TrayEntry> tray;

  /// Coins ki positions.
  final List<CoinData> coins;

  /// Teesre star ke liye gold time (seconds).
  final double goldTimeSeconds;

  final SurfaceType surface;

  /// Paani wale hisse — girna = fail. Har zone: x, width.
  final List<({double x, double width})> waterZones;

  /// Hazards — bridge-break, snowball waghera (Phase 4/5).
  /// Fairness rule (level design doc): har hazard GO se pehle dikhta hai.
  final List<LevelHazard> hazards;

  /// Crumble platforms — gari ke touch ke 1.5s baad tootne wale
  /// pathar (World 5) ya lava par tairte pathar (World 7, L78).
  /// Terrain se alag hain — in ka apna component banta hai.
  final List<TerrainSegment> crumblePlatforms;

  /// Bridge-break hazard ho to us ka waqt, warna null.
  double? get bridgeBreakSeconds {
    for (final hazard in hazards) {
      if (hazard.type == HazardType.bridgeBreak) {
        return hazard.afterSeconds;
      }
    }
    return null;
  }

  /// Sinking-bridge hazard ho to us ki raftaar, warna null.
  double? get sinkingBridgeRate {
    for (final hazard in hazards) {
      if (hazard.type == HazardType.sinkingBridge) {
        return hazard.rate;
      }
    }
    return null;
  }

  /// Snowball hazard ho to wo, warna null.
  LevelHazard? get snowballHazard {
    for (final hazard in hazards) {
      if (hazard.type == HazardType.snowball) return hazard;
    }
    return null;
  }

  /// Is qisam ke saare hazards — lift, gate, lava waghera.
  List<LevelHazard> hazardsOf(HazardType type) {
    return hazards.where((h) => h.type == type).toList();
  }

  /// Tray mein is piece ki kul tadad.
  int trayCount(PieceType type) {
    var total = 0;
    for (final entry in tray) {
      if (entry.type == type) total += entry.count;
    }
    return total;
  }

  /// Level ki basic validation — ghaltiyon ki list (khaali = theek).
  /// levels_test.dart isi ko har level par chalata hai.
  List<String> validate({required double worldWidth, required double worldHeight}) {
    final errors = <String>[];

    if (id <= 0) errors.add('id $id positive hona chahiye');
    if (world < 1 || world > 8) errors.add('world 1-8 ke andar hona chahiye');
    if (levelInWorld < 1 || levelInWorld > 12) {
      errors.add('levelInWorld 1-12 ke andar hona chahiye');
    }
    if (name.isEmpty) errors.add('name khaali nahi hona chahiye');
    if (terrain.isEmpty) errors.add('terrain khaali nahi hona chahiye');
    if (tray.isEmpty) errors.add('tray khaali nahi honi chahiye');
    if (coins.isEmpty) errors.add('kam az kam ek coin hona chahiye');
    if (goldTimeSeconds <= 0) errors.add('goldTimeSeconds positive hona chahiye');

    for (final entry in tray) {
      if (entry.count <= 0) {
        errors.add('tray mein ${entry.type.label} ka count positive hona chahiye');
      }
      if (!entry.type.isImplemented) {
        errors.add('${entry.type.label} ka component abhi bana nahi — '
            'ye level abhi khela nahi ja sakta');
      }
    }

    if (startX < 0 || startX > worldWidth) {
      errors.add('startX duniya se bahar hai');
    }
    if (startY < 0 || startY > worldHeight) {
      errors.add('startY duniya se bahar hai');
    }
    if (finishX <= startX) {
      errors.add('finishX startX se aage hona chahiye');
    }
    if (finishX > worldWidth) errors.add('finishX duniya se bahar hai');

    // Start position kisi terrain par honi chahiye (gari hawa mein na ho).
    final startOnGround = terrain.any(
      (s) => startX >= s.x && startX <= s.x + s.width,
    );
    if (!startOnGround) errors.add('start position kisi terrain par nahi hai');

    // Coins duniya ke andar hon.
    for (var i = 0; i < coins.length; i++) {
      final c = coins[i];
      if (c.x < 0 || c.x > worldWidth || c.y < 0 || c.y > worldHeight) {
        errors.add('coin $i duniya se bahar hai (${c.x}, ${c.y})');
      }
    }

    // Hazards valid hon.
    for (final hazard in hazards) {
      switch (hazard.type) {
        case HazardType.bridgeBreak:
          if (hazard.afterSeconds <= 0) {
            errors.add('bridgeBreak ka afterSeconds positive hona chahiye');
          }
          if (trayCount(PieceType.bridge) == 0) {
            errors.add('bridgeBreak hazard hai lekin tray mein bridge nahi');
          }
        case HazardType.snowball:
          if (hazard.x < 0 || hazard.x > worldWidth) {
            errors.add('snowball spawn x duniya se bahar hai');
          }
          if (hazard.y < 0 || hazard.y > worldHeight) {
            errors.add('snowball spawn y duniya se bahar hai');
          }
          if (hazard.intervalSeconds <= 0) {
            errors.add('snowball intervalSeconds positive hona chahiye');
          }
        case HazardType.lift:
          if (hazard.x < 0 || hazard.x > worldWidth) {
            errors.add('lift x duniya se bahar hai');
          }
          if (hazard.y2 <= 0 || hazard.y2 >= hazard.y) {
            errors.add('lift y2 (upar) y (neeche) se upar hona chahiye');
          }
          if (hazard.periodSeconds <= 0) {
            errors.add('lift periodSeconds positive hona chahiye');
          }
        case HazardType.gate:
          if (hazard.x < 0 || hazard.x > worldWidth) {
            errors.add('gate x duniya se bahar hai');
          }
          if (hazard.cycleSeconds <= 0 ||
              hazard.openSeconds <= 0 ||
              hazard.openSeconds >= hazard.cycleSeconds) {
            errors.add('gate cycle/openSeconds ghalat hain');
          }
        case HazardType.lava:
          if (hazard.x < 0 || hazard.x + hazard.width > worldWidth) {
            errors.add('lava zone duniya se bahar hai');
          }
          if (hazard.y < 0 || hazard.y > worldHeight) {
            errors.add('lava y duniya se bahar hai');
          }
        case HazardType.risingLava:
          if (hazard.x < 0 || hazard.x + hazard.width > worldWidth) {
            errors.add('risingLava zone duniya se bahar hai');
          }
          if (hazard.rate <= 0) {
            errors.add('risingLava rate positive hona chahiye');
          }
        case HazardType.rockfall:
          if (hazard.x < 0 || hazard.x > worldWidth) {
            errors.add('rockfall spawn x duniya se bahar hai');
          }
          if (hazard.intervalSeconds <= 0) {
            errors.add('rockfall intervalSeconds positive hona chahiye');
          }
        case HazardType.geyser:
          if (hazard.x < 0 || hazard.x > worldWidth) {
            errors.add('geyser x duniya se bahar hai');
          }
          if (hazard.cycleSeconds <= 0 ||
              hazard.openSeconds <= 0 ||
              hazard.openSeconds >= hazard.cycleSeconds) {
            errors.add('geyser cycle/openSeconds ghalat hain');
          }
        case HazardType.wind:
          if (hazard.x < 0 || hazard.x + hazard.width > worldWidth) {
            errors.add('wind zone duniya se bahar hai');
          }
          if (hazard.cycleSeconds <= 0 ||
              hazard.openSeconds <= 0 ||
              hazard.openSeconds >= hazard.cycleSeconds) {
            errors.add('wind cycle/openSeconds ghalat hain');
          }
          if (hazard.strength == 0) {
            errors.add('wind strength zero nahi ho sakti');
          }
        case HazardType.sinkingBridge:
          if (hazard.rate <= 0) {
            errors.add('sinkingBridge rate positive hona chahiye');
          }
          if (trayCount(PieceType.bridge) == 0) {
            errors.add('sinkingBridge hazard hai lekin tray mein bridge nahi');
          }
      }
    }

    // Crumble platforms duniya ke andar hon.
    for (final platform in crumblePlatforms) {
      if (platform.x < 0 ||
          platform.x + platform.width > worldWidth ||
          platform.y < 0 ||
          platform.y > worldHeight) {
        errors.add('crumble platform duniya se bahar hai');
      }
    }

    return errors;
  }
}
