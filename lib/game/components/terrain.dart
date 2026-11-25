// Level ki fixed zameen — jo hissa player nahi banata.
// Ek static body, har segment ek fixture. Paani sirf visual hai;
// girne ka fail DriveManager y-position se pakarta hai.
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/level_data.dart';

class TerrainComponent extends BodyComponent {
  TerrainComponent(this.level);

  final LevelData level;

  final _grassPaint = Paint()..color = GameColors.grass;
  final _dirtPaint = Paint()..color = GameColors.dirt;
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
      body.createFixture(FixtureDef(shape, friction: 0.8));
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
      canvas.drawRect(rect, _dirtPaint);
      // Upar ghaas ki patti.
      canvas.drawRect(
        Rect.fromLTWH(segment.x, segment.y, segment.width, 0.25),
        _grassPaint,
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
