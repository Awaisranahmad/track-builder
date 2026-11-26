// Hint ka ghost piece — solution ka agla step halke hare rang mein
// dikhata hai (build phase mein). Koi physics nahi, sirf visual;
// kuch second baad khud hat jata hai ya matching piece lagte hi.
// Shakal TrackPiece jaisi hai (trapezoid), taake player ko foran
// samajh aaye kahan kya lagana hai.
import 'dart:math' as math;

import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/piece_type.dart';

class GhostHintComponent extends PositionComponent {
  GhostHintComponent({
    required this.type,
    required Vector2 center,
    this.lifetimeSeconds = HintValues.ghostVisibleSeconds,
  }) : super(
          position: center.clone(),
          size: Vector2(type.length, type.thickness),
          anchor: Anchor.center,
        );

  final PieceType type;

  /// Piece ka centre — position hi centre hai (anchor center).
  Vector2 get hintCenter => position;

  /// Kitni der dikhe, phir khud remove.
  final double lifetimeSeconds;

  double _age = 0;

  /// Ramp ka default angle — solution mein ramp hamesha -30° hota hai.
  double get _angleRadians {
    if (type == PieceType.ramp) {
      return -PieceValues.rampDefaultAngleDegrees * math.pi / 180;
    }
    return 0;
  }

  @override
  void update(double dt) {
    super.update(dt);
    _age += dt;
    if (_age >= lifetimeSeconds) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    // Halka hara, blink karta hua — dhyaan khainchne ke liye.
    final blink = 0.45 + 0.25 * math.sin(_age * 6);
    final paint = Paint()
      ..color = GameColors.ghostValid.withValues(alpha: blink);
    final border = Paint()
      ..color = Colors.white.withValues(alpha: 0.9)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.06;

    canvas.save();
    canvas.rotate(_angleRadians);
    if (type == PieceType.booster) {
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: type.length,
          height: 0.15,
        ),
        paint,
      );
      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: type.length,
          height: 0.15,
        ),
        border,
      );
      canvas.restore();
      return;
    }
    // Trapezoid — TrackPiece jaisa.
    final hl = type.length / 2;
    final ht = type.thickness / 2;
    final c = PieceValues.edgeChamfer;
    final path = Path()
      ..moveTo(-hl, -ht)
      ..lineTo(hl, -ht)
      ..lineTo(hl - c, ht)
      ..lineTo(-hl + c, ht)
      ..close();
    canvas.drawPath(path, paint);
    canvas.drawPath(path, border);
    canvas.restore();
  }
}
