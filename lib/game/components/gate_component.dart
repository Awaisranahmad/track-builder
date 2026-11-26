// Timed gate — deewar cycle par khulti/band hoti hai.
// Band ho to rasta poora band (gari takraye to ruk jati hai),
// khuli ho to deewar upar uth jati hai, rasta saaf.
// Cycle ke shuru mein khuli hoti hai, phir band, phir khuli...
// Gari gas-only chalaye to gate ke khulne ka intezar karti hai
// (stuck timer 5s hai, gate cycle 3s — wait karna safe hai).
// Fairness: gari gate ke neeche ho to deewar band nahi hoti —
// sensor zone cycle ko rok deta hai, taake gate kabhi gari ko na dabaye.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';
import 'car.dart';

class GateComponent extends BodyComponent with ContactCallbacks {
  GateComponent({
    required this.x,
    required this.groundY,
    this.cycleSeconds = 3.0,
    this.openSeconds = 1.5,
  });

  /// Deewar ki x position (metre).
  final double x;

  /// Zameen ki satah y (metre) — band deewar yahin se khari hoti hai.
  final double groundY;

  /// Poora cycle (seconds).
  final double cycleSeconds;

  /// Cycle ke shuru mein kitni der khula rehta hai (seconds).
  final double openSeconds;

  /// Cycle mein kitna waqt guzra.
  double _elapsed = 0;

  /// Gari gate ke neeche hai — cycle ruk jata hai.
  int _carInside = 0;

  /// Abhi khula hai ya nahi — test/UI ke liye.
  bool get isOpen {
    if (_carInside > 0) return true;
    final phase = _elapsed % cycleSeconds;
    return phase < openSeconds;
  }

  /// Deewar ki abhi ki y (centre) — test ke liye.
  double get wallCenterY => body.position.y;

  @override
  Body createBody() {
    final bodyDef = BodyDef(
      type: BodyType.kinematic,
      position: Vector2(x, _openY),
      userData: this,
    );
    final body = world.createBody(bodyDef);
    final shape = PolygonShape()
      ..setAsBox(
        GateValues.wallWidth / 2,
        GateValues.wallHeight / 2,
        Vector2.zero(),
        0,
      );
    // Deewar ki friction 0 — warna ghoomta hua wheel deewar par
    // charh kar gari ko ulta kar deta hai (band gate par wait karte hue).
    body.createFixture(FixtureDef(shape, friction: 0.0));
    // Sensor zone — gari is ke andar ho to gate band nahi hota.
    final sensorShape = PolygonShape()
      ..setAsBox(0.9, GateValues.wallHeight / 2 + 0.5, Vector2.zero(), 0);
    body.createFixture(FixtureDef(sensorShape, isSensor: true));
    return body;
  }

  /// Band deewar ka centre y — zameen se upar khari hoti hai.
  double get _closedY => groundY - GateValues.wallHeight / 2;

  /// Khuli deewar ka centre y — gari ke upar, rasta saaf.
  double get _openY => groundY - GateValues.wallHeight - 1.5;

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Car &&
        (contact.fixtureA.isSensor || contact.fixtureB.isSensor)) {
      _carInside++;
    }
  }

  @override
  void endContact(Object other, Contact contact) {
    if (other is Car &&
        (contact.fixtureA.isSensor || contact.fixtureB.isSensor)) {
      if (_carInside > 0) _carInside--;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Cycle sirf drive phase mein chalta hai — build phase mein
    // gate khula rehta hai, GO par cycle deterministic shuru hota hai.
    final game = findGame();
    if (game is! TrackBuilderGame || game.phase != GamePhase.drive) {
      return;
    }
    // Gari neeche ho to cycle ruko — gate khula rahe.
    if (_carInside > 0) {
      body.setTransform(Vector2(x, _openY), 0);
      return;
    }
    _elapsed += dt;
    final phase = _elapsed % cycleSeconds;
    // Transition: khulne/band hone mein 0.4s, smoothstep se.
    final transition = GateValues.transitionSeconds;
    double t;
    if (phase < openSeconds) {
      // Khula — cycle ke aakhir mein band hone lagega.
      t = 0;
    } else if (phase < openSeconds + transition) {
      // Band ho raha hai.
      final u = (phase - openSeconds) / transition;
      t = _smooth(u);
    } else if (phase < cycleSeconds - transition) {
      // Band.
      t = 1;
    } else {
      // Khul raha hai.
      final u = (phase - (cycleSeconds - transition)) / transition;
      t = 1 - _smooth(u);
    }
    final y = _openY + (_closedY - _openY) * t;
    body.setTransform(Vector2(x, y), 0);
  }

  double _smooth(double u) {
    final double clamped = u.clamp(0, 1).toDouble();
    return clamped * clamped * (3 - 2 * clamped);
  }

  final _wallPaint = Paint()..color = const Color(0xFFFFC107);
  final _stripePaint = Paint()..color = const Color(0xFF212121);

  @override
  void render(Canvas canvas) {
    // Body transform renderTree lagata hai — (0,0) deewar ka centre hai.
    canvas.drawRect(
      Rect.fromLTWH(
        -GateValues.wallWidth / 2,
        -GateValues.wallHeight / 2,
        GateValues.wallWidth,
        GateValues.wallHeight,
      ),
      _wallPaint,
    );
    // Kaali patti — gate dikhe.
    canvas.drawRect(
      Rect.fromLTWH(
        -GateValues.wallWidth / 2,
        -0.1,
        GateValues.wallWidth,
        0.2,
      ),
      _stripePaint,
    );
  }
}
