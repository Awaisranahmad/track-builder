// Player ka lagaya hua piece — Road ya Ramp.
// Build phase mein ye sirf sensor hota hai (gari se takrata nahi),
// GO dabane par solid ho jata hai. Retry par dobara sensor.
// Shakal default render se banti hai: fixture `paint` ke rang mein draw hoti hai.
import 'dart:math' as math;

import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/piece_type.dart';

class TrackPiece extends BodyComponent {
  TrackPiece({
    required this.type,
    required this.pieceCenter,
    this.angleDegrees = 0,
  }) {
    paint = Paint()..color = type.color;
  }

  final PieceType type;

  /// Piece ka centre (metre, world coords).
  final Vector2 pieceCenter;

  /// Rotation — degree mein. Ramp ka default -30 (upar ki taraf).
  double angleDegrees;

  /// Is piece ko lagane par kitne grid cells ghere — placement ke liye.
  double get length => type.length;

  @override
  Body createBody() {
    final angle = type == PieceType.ramp && angleDegrees == 0
        ? -PieceValues.rampDefaultAngleDegrees * math.pi / 180
        : angleDegrees * math.pi / 180;
    final bodyDef = BodyDef(
      type: BodyType.static,
      position: pieceCenter,
      angle: angle,
      userData: this,
    );
    final body = world.createBody(bodyDef);
    // Trapezoid — upar ki satah poori lambai (zameen se flush, koi dip nahi),
    // neeche ke kinare andar ki taraf dhalwan: wheel thoda neeche dabe to
    // bhi dhalwan use upar dhakel deti hai, vertical edge se nahi takrata.
    // Winding setAsBox jaisi hai: top-left → top-right → bottom-right → bottom-left.
    final hl = type.length / 2;
    final ht = type.thickness / 2;
    final c = PieceValues.edgeChamfer;
    final shape = PolygonShape()
      ..set([
        Vector2(-hl, -ht),
        Vector2(hl, -ht),
        Vector2(hl - c, ht),
        Vector2(-hl + c, ht),
      ]);
    // Shuru mein sensor — build phase mein gari se takraye baghair.
    body.createFixture(FixtureDef(shape, friction: 0.8, isSensor: true));
    return body;
  }

  /// GO dabane par chahiye ya nahi — body async banta hai, is liye
  /// flag mein rakho; body banne par onMount mein lag jayega.
  bool _wantSolid = false;

  @override
  void onMount() {
    super.onMount();
    if (_wantSolid) _applySolid();
  }

  /// GO dabane par — piece solid ho jaye, gari is par chale.
  void makeSolid() {
    _wantSolid = true;
    if (isMounted) _applySolid();
  }

  /// Retry / build mein wapas — dobara sensor.
  void makeGhost() {
    _wantSolid = false;
    if (isMounted) _applyGhost();
  }

  void _applySolid() {
    for (final fixture in body.fixtures) {
      fixture.setSensor(false);
    }
  }

  void _applyGhost() {
    for (final fixture in body.fixtures) {
      fixture.setSensor(true);
    }
  }

  /// Tap par rotate — 15 degree ke step mein.
  void rotate() {
    angleDegrees += PieceValues.rotateStepDegrees;
    if (angleDegrees > 90) angleDegrees -= 180;
    body.setTransform(
      body.position,
      angleDegrees * math.pi / 180,
    );
  }

  /// Tap point is piece ke andar hai ya nahi — hit test ke liye.
  @override
  bool containsPoint(Vector2 point) {
    final dx = point.x - pieceCenter.x;
    final dy = point.y - pieceCenter.y;
    final angle = angleDegrees * math.pi / 180;
    // Point ko piece ke local frame mein lao (rotation ulta karo).
    final localX = dx * math.cos(angle) + dy * math.sin(angle);
    final localY = -dx * math.sin(angle) + dy * math.cos(angle);
    return localX.abs() <= type.length / 2 + 0.2 &&
        localY.abs() <= type.thickness / 2 + 0.3;
  }
}
