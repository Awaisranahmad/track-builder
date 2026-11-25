// Level ka data model — har level sirf ye data hai, code nahi.
// Design rule 3: level ka data kabhi game code mein hardcode nahi hoga.
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

/// Zameen ki surface — friction tay karti hai.
enum SurfaceType { normal, sand, ice }

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

    return errors;
  }
}
