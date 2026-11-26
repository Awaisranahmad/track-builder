// Level ki fixed zameen — jo hissa player nahi banata.
// Ek static body, har segment ek fixture. Paani sirf visual hai;
// girne ka fail DriveManager y-position se pakarta hai.
// Surface ke hisab se friction aur rang badalta hai:
// sand par ret, ice par barf.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/level_data.dart';

class TerrainComponent extends BodyComponent {
  TerrainComponent(this.level);

  final LevelData level;

  Paint get _topPaint {
    switch (level.surface) {
      case SurfaceType.sand:
        return Paint()..color = GameColors.sand;
      case SurfaceType.ice:
        return Paint()..color = GameColors.snow;
      case SurfaceType.normal:
        return Paint()..color = GameColors.grass;
    }
  }

  Paint get _bodyPaint {
    switch (level.surface) {
      case SurfaceType.sand:
        return Paint()..color = GameColors.sandDirt;
      case SurfaceType.ice:
        return Paint()..color = GameColors.snowDirt;
      case SurfaceType.normal:
        return Paint()..color = GameColors.dirt;
    }
  }

  final _waterPaint = Paint()..color = GameColors.water;

  @override
  Body createBody() {
    final bodyDef = BodyDef(type: BodyType.static, userData: this);
    final body = world.createBody(bodyDef);
    for (final segment in level.terrain) {
      final shape = PolygonShape()
        ..setAsBox(
          segment.width / 2,
          segment.height / 2,
          Vector2(segment.x + segment.width / 2, segment.y + segment.height / 2),
          0,
        );
      body.createFixture(
        FixtureDef(
          shape,
          friction: SurfaceValues.terrainFriction(level.surface),
        ),
      );
    }
    return body;
  }

  @override
  void render(Canvas canvas) {
    // NOTE: BodyComponent.renderTree body ki position/angle khud lagata
    // hai — yahan local coords (body origin) par draw karo, dobara
    // translate mat karo.
    for (final segment in level.terrain) {
      final rect = Rect.fromLTWH(segment.x, segment.y, segment.width, segment.height);
      canvas.drawRect(rect, _bodyPaint);
      // Upar ki patti — ghaas / ret / barf.
      canvas.drawRect(
        Rect.fromLTWH(segment.x, segment.y, segment.width, 0.25),
        _topPaint,
      );
    }
    // Paani — gap mein neela hissa.
    for (final zone in level.waterZones) {
      canvas.drawRect(
        Rect.fromLTWH(zone.x, WorldSize.groundTop, zone.width, 2),
        _waterPaint,
      );
    }
  }
}
