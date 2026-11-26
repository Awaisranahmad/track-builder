// Lift — moving platform, do manzilon ke beech upar-neeche.
// Kinematic body: neeche wale siray se upar wale siray tak chalti hai,
// har siray par thodi der rukti hai. Gari is par khari ho kar
// upar jati hai (friction + normal force use uthate hain).
// Cycle deterministic hai (period data se) — test mein waqt gin kar
// gas chhorna/dabana mumkin hai.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';

class LiftComponent extends BodyComponent {
  LiftComponent({
    required this.x,
    required this.bottomY,
    required this.topY,
    this.periodSeconds = 6.0,
  });

  /// Platform ka centre x (metre).
  final double x;

  /// Neeche wale siray ki y (platform top).
  final double bottomY;

  /// Upar wale siray ki y (platform top).
  final double topY;

  /// Poora upar-neeche cycle (seconds).
  final double periodSeconds;

  /// Kitna waqt guzra (GO ke baad).
  double _elapsed = 0;

  /// Platform top ki abhi ki y — test ke liye.
  double get platformTopY => body.position.y - LiftValues.platformThickness / 2;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.kinematic,
      position: Vector2(x, bottomY + LiftValues.platformThickness / 2),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = PolygonShape()
      ..setAsBox(
        LiftValues.platformWidth / 2,
        LiftValues.platformThickness / 2,
        Vector2.zero(),
        0,
      );
    body.createFixture(FixtureDef(shape, friction: 0.9));
    return body;
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Cycle sirf drive phase mein chalta hai — build phase mein
    // lift neeche rehti hai, GO par cycle deterministic shuru hota hai.
    final game = findGame();
    if (game is! TrackBuilderGame || game.phase != GamePhase.drive) {
      body.linearVelocity = Vector2.zero();
      return;
    }
    _elapsed += dt;
    // Cycle: neeche ruko (dwell) → upar jao → upar ruko → neeche aao.
    // Har hissa period ka 1/4 hai.
    final quarter = periodSeconds / 4;
    final phase = _elapsed % periodSeconds;
    double top;
    if (phase < quarter) {
      // Neeche ruka hua.
      top = bottomY;
    } else if (phase < 2 * quarter) {
      // Upar ja raha hai — smooth.
      final u = (phase - quarter) / quarter;
      top = bottomY + (topY - bottomY) * _smooth(u);
    } else if (phase < 3 * quarter) {
      // Upar ruka hua.
      top = topY;
    } else {
      // Neeche aa raha hai — smooth.
      final u = (phase - 3 * quarter) / quarter;
      top = topY + (bottomY - topY) * _smooth(u);
    }
    // Kinematic body ko velocity se chalao, setTransform se nahi:
    // setTransform platform ko teleport karta hai — upar wali gari
    // kinare se takra kar ulta hoti thi (probe se). Velocity se
    // friction gari ko sahi tareeqe se upar le jata hai.
    final currentTop =
        body.position.y - LiftValues.platformThickness / 2;
    final vy = dt > 0.0001 ? (top - currentTop) / dt : 0.0;
    body.linearVelocity = Vector2(0, vy.clamp(-5.0, 5.0));
  }

  double _smooth(double u) {
    final double clamped = u.clamp(0, 1).toDouble();
    return clamped * clamped * (3 - 2 * clamped);
  }

  final _platformPaint = Paint()..color = const Color(0xFF607D8B);
  final _edgePaint = Paint()..color = const Color(0xFFFFC107);

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) platform ka centre hai.
    canvas.drawRect(
      Rect.fromLTWH(
        -LiftValues.platformWidth / 2,
        -LiftValues.platformThickness / 2,
        LiftValues.platformWidth,
        LiftValues.platformThickness,
      ),
      _platformPaint,
    );
    // Peeli kinari — lift dikhe.
    canvas.drawRect(
      Rect.fromLTWH(
        -LiftValues.platformWidth / 2,
        -LiftValues.platformThickness / 2,
        LiftValues.platformWidth,
        0.08,
      ),
      _edgePaint,
    );
  }
}
