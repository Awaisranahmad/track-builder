// Background — aasman, peeche ki pahadiyan.
// Phase 4: har world ka background sprite — load na ho to purane flat colors.
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../services/sprite_service.dart';

class BackgroundComponent extends PositionComponent {
  BackgroundComponent({this.world = 1})
      : super(
          position: Vector2.zero(),
          size: Vector2(WorldSize.width, WorldSize.height),
          priority: -10,
        );

  /// Kis world ka background — 1 Green Hills, 2 Desert, 3 Snow.
  final int world;

  /// Phase 4 sprite — load na ho to null, phir flat colors.
  Sprite? _sprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _sprite = await SpriteService.load(SpritePaths.background(world));
  }

  Paint get _skyPaint {
    switch (world) {
      case 2:
        return Paint()..color = GameColors.desertSky;
      case 3:
        return Paint()..color = GameColors.snowSky;
      default:
        return Paint()..color = GameColors.sky;
    }
  }

  Paint get _hillPaint {
    switch (world) {
      case 2:
        return Paint()..color = GameColors.dune;
      case 3:
        return Paint()..color = GameColors.snowHill;
      default:
        return Paint()..color = const Color(0xFF81C784);
    }
  }

  Paint get _hillPaint2 {
    switch (world) {
      case 2:
        return Paint()..color = const Color(0xFFF7D9A8);
      case 3:
        return Paint()..color = const Color(0xFFE8F4FA);
      default:
        return Paint()..color = const Color(0xFFA5D6A7);
    }
  }

  @override
  void render(Canvas canvas) {
    // Sprite ho to poori background image — warna flat colors.
    final sprite = _sprite;
    if (sprite != null) {
      sprite.render(canvas, position: Vector2.zero(), size: size);
      return;
    }
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
