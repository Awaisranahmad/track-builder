// Drive phase ki logic — timer, fail detection, stars.
// Sirf logic hai: physics car se parhta hai, faisla yahan hota hai.
import '../../core/constants.dart';
import '../../data/models/level_data.dart';
import '../components/car.dart';

/// Level khatam hone ka natija — UI aur save isi se banta hai.
class LevelResult {
  const LevelResult({
    required this.stars,
    required this.coinsCollected,
    required this.totalCoins,
    required this.timeSeconds,
    required this.failed,
    this.failReason,
  });

  /// Mile hue stars (0-3).
  final int stars;

  final int coinsCollected;
  final int totalCoins;
  final double timeSeconds;

  /// true matlab fail (flip / girna / stuck).
  final bool failed;

  /// Fail ki wajah — 'flip', 'fall' ya 'stuck'.
  final String? failReason;

  bool get passed => !failed;
}

class DriveManager {
  DriveManager(this.level);

  final LevelData level;

  double elapsed = 0;
  int coinsCollected = 0;
  bool finished = false;
  bool failed = false;
  String? failReason;

  double _flipTimer = 0;
  double _stuckTimer = 0;

  /// GO dabane par — timer aur counters zero.
  void start() {
    elapsed = 0;
    coinsCollected = 0;
    finished = false;
    failed = false;
    failReason = null;
    _flipTimer = 0;
    _stuckTimer = 0;
  }

  /// Har frame — fail conditions check karo.
  void update(double dt, Car car) {
    if (finished || failed) return;
    elapsed += dt;

    // Ulta ho gaya? (Loop ke andar flip check nahi hota — wahan ulta
    // hona hi maqsad hai. Angle wrap kiya jata hai taake poora loop
    // ghumne ke baad gari seedhi gini jaye.)
    if (!car.isInLoop) {
      final wrapped = _wrapAngle(car.angle);
      if (wrapped.abs() > DriveRules.flipAngleRadians) {
        _flipTimer += dt;
        if (_flipTimer >= DriveRules.flipHoldSeconds) {
          _fail('flip');
          return;
        }
      } else {
        _flipTimer = 0;
      }
    } else {
      _flipTimer = 0;
    }

    // Khaai mein gir gaya?
    if (car.position.y > WorldSize.fallFailY) {
      _fail('fall');
      return;
    }

    // Atak gaya? (GO ke 1 second baad se check.)
    if (elapsed > DriveRules.stuckGraceSeconds) {
      if (car.speed < DriveRules.stuckSpeed) {
        _stuckTimer += dt;
        if (_stuckTimer >= DriveRules.stuckSeconds) {
          _fail('stuck');
          return;
        }
      } else {
        _stuckTimer = 0;
      }
    }
  }

  void onCoinCollected() {
    if (finished || failed) return;
    coinsCollected++;
  }

  void onFinish() {
    if (finished || failed) return;
    finished = true;
  }

  void _fail(String reason) {
    failed = true;
    failReason = reason;
  }

  /// Bahar se fail — lava ya geyser chhoone par (game bulata hai).
  void fail(String reason) {
    if (finished || failed) return;
    _fail(reason);
  }

  /// Angle ko -π..π mein lao.
  static double _wrapAngle(double angle) {
    const twoPi = 2 * 3.141592653589793;
    var wrapped = angle % twoPi;
    if (wrapped > 3.141592653589793) wrapped -= twoPi;
    if (wrapped < -3.141592653589793) wrapped += twoPi;
    return wrapped;
  }

  /// Stars gino: finish = 1, saare coins = 1, gold time + no crash = 1.
  LevelResult buildResult() {
    var stars = 0;
    if (finished) stars += 1;
    if (finished && coinsCollected >= level.coins.length) stars += 1;
    if (finished && elapsed <= level.goldTimeSeconds && !failed) {
      stars += 1;
    }
    return LevelResult(
      stars: stars,
      coinsCollected: coinsCollected,
      totalCoins: level.coins.length,
      timeSeconds: elapsed,
      failed: failed,
      failReason: failReason,
    );
  }
}
