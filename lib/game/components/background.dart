// Background — aasman, peeche ki pahadiyan. Flat colors, Phase 1.
// Camera fixed hai, is liye background bhi fixed size ka hai.
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';

class BackgroundComponent extends PositionComponent {
  BackgroundComponent()
      : super(
          position: Vector2.zero(),
          size: Vector2(WorldSize.width, WorldSize.height),
          priority: -10,
        );

  final _skyPaint = Paint()..color = GameColors.sky;
  final _hillPaint = Paint()..color = const Color(0xFF81C784);
  final _hillPaint2 = Paint()..color = const Color(0xFFA5D6A7);

  @override
  void render(Canvas canvas) {
    canvas.drawRect(size.toRect(), _skyPaint);

    // Peeche ki halki pahadiyan — do bade circles se.
    canvas.drawCircle(const Offset(4, 11.5), 4.5, _hillPaint2);
    canvas.drawCircle(const Offset(13, 12), 5.5, _hillPaint2);
    canvas.drawCircle(const Offset(18, 11.5), 3.5, _hillPaint);

    // Sooraj.
    canvas.drawCircle(
      const Offset(17.5, 1.5),
      0.8,
      Paint()..color = const Color(0xFFFFF59D),
    );
  }
}
