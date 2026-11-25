// Gari — chassis + 2 wheels, WheelJoint (motor + suspension) se jure hue.
// Build phase mein frozen rehti hai (gravity 0, soyi hui),
// GO par physics on hoti hai. Shakal: lal rectangle + kaale circle wheels.

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';

class Car extends Component {
  Car({required this.startPosition});

  /// Shuru ki position — chassis ka centre.
  final Vector2 startPosition;

  late Body _chassis;
  late Body _frontWheel;
  late Body _rearWheel;
  late WheelJoint _frontJoint;
  late WheelJoint _rearJoint;
  late Forge2DWorld _world;

  bool _active = false;

  final _bodyPaint = Paint()..color = GameColors.carBody;
  final _wheelPaint = Paint()..color = GameColors.wheel;
  final _spokePaint = Paint()
    ..color = Colors.white
    ..strokeWidth = 0.06;

  TrackBuilderGame get _game => findGame()! as TrackBuilderGame;

  @override
  Future<void> onMount() async {
    super.onMount();
    _world = _game.world;
    final world = _world;

    // Chassis — dynamic rectangle.
    final chassisDef = BodyDef(
      type: BodyType.dynamic,
      position: startPosition.clone(),
      userData: this,
    );
    _chassis = world.createBody(chassisDef);
    final chassisShape = PolygonShape()
      ..setAsBox(
        CarValues.bodyWidth / 2,
        CarValues.bodyHeight / 2,
        Vector2.zero(),
        0,
      );
    _chassis.createFixture(
      FixtureDef(
        chassisShape,
        density: CarValues.bodyDensity,
        friction: CarValues.bodyFriction,
      ),
    );

    // Wheels — dynamic circles, chassis ke neeche.
    _frontWheel = _makeWheel(
      world,
      startPosition + Vector2(CarValues.wheelOffsetX, CarValues.wheelOffsetY),
    );
    _rearWheel = _makeWheel(
      world,
      startPosition + Vector2(-CarValues.wheelOffsetX, CarValues.wheelOffsetY),
    );

    // Wheel joints — motor + suspension.
    _frontJoint = _makeJoint(world, _frontWheel);
    _rearJoint = _makeJoint(world, _rearWheel);

    _freeze();
  }

  Body _makeWheel(Forge2DWorld world, Vector2 position) {
    final def = BodyDef(
      type: BodyType.dynamic,
      position: position,
      userData: this,
    );
    final wheel = world.createBody(def);
    final shape = CircleShape()..radius = CarValues.wheelRadius;
    wheel.createFixture(
      FixtureDef(
        shape,
        density: CarValues.wheelDensity,
        friction: CarValues.wheelFriction,
      ),
    );
    return wheel;
  }

  WheelJoint _makeJoint(Forge2DWorld world, Body wheel) {
    final jointDef = WheelJointDef()
      ..initialize(_chassis, wheel, wheel.position, Vector2(0, 1))
      ..motorSpeed = 0
      ..maxMotorTorque = PhysicsValues.maxMotorTorque
      ..enableMotor = true
      ..frequencyHz = PhysicsValues.suspensionFrequencyHz
      ..dampingRatio = PhysicsValues.suspensionDampingRatio;
    final joint = WheelJoint(jointDef);
    world.createJoint(joint);
    return joint;
  }

  /// Build phase ke liye freeze — gravity band, hilegi nahi.
  void _freeze() {
    for (final body in [_chassis, _frontWheel, _rearWheel]) {
      body.gravityScale = Vector2.zero();
      body.setAwake(false);
    }
    _active = false;
  }

  /// GO — physics on.
  void activate() {
    for (final body in [_chassis, _frontWheel, _rearWheel]) {
      body.gravityScale = Vector2(1, 1);
      body.setAwake(true);
    }
    _active = true;
  }

  /// Retry — shuru ki position par wapas, dobara freeze.
  void resetToStart() {
    _freeze();
    _chassis.setTransform(startPosition, 0);
    _chassis.linearVelocity = Vector2.zero();
    _chassis.angularVelocity = 0;
    _frontWheel.setTransform(
      startPosition + Vector2(CarValues.wheelOffsetX, CarValues.wheelOffsetY),
      0,
    );
    _frontWheel.linearVelocity = Vector2.zero();
    _frontWheel.angularVelocity = 0;
    _rearWheel.setTransform(
      startPosition + Vector2(-CarValues.wheelOffsetX, CarValues.wheelOffsetY),
      0,
    );
    _rearWheel.linearVelocity = Vector2.zero();
    _rearWheel.angularVelocity = 0;
    _frontJoint.motorSpeed = 0;
    _rearJoint.motorSpeed = 0;
  }

  /// Gas — dono wheels aage. Sign headless test se verify hoga.
  void setGas(bool on) {
    if (!_active) return;
    final speed = on ? PhysicsValues.motorSpeedGas : 0.0;
    _frontJoint.motorSpeed = speed;
    _rearJoint.motorSpeed = speed;
  }

  /// Brake / reverse.
  void setBrake(bool on) {
    if (!_active) return;
    final speed = on ? PhysicsValues.motorSpeedBrake : 0.0;
    _frontJoint.motorSpeed = speed;
    _rearJoint.motorSpeed = speed;
  }

  /// Gari ki raftaar (metre/second).
  double get speed => _chassis.linearVelocity.length;

  /// Chassis ka angle (radians).
  double get angle => _chassis.angle;

  /// Chassis ki position.
  Vector2 get position => _chassis.position.clone();

  /// Aglay aur pichlay wheel ki position — debug/test ke liye.
  Vector2 get frontWheelPosition => _frontWheel.position.clone();
  Vector2 get rearWheelPosition => _rearWheel.position.clone();

  bool get isActive => _active;

  @override
  void render(Canvas canvas) {
    // Chassis.
    canvas.save();
    canvas.translate(_chassis.position.x, _chassis.position.y);
    canvas.rotate(_chassis.angle);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: CarValues.bodyWidth,
          height: CarValues.bodyHeight,
        ),
        const Radius.circular(0.12),
      ),
      _bodyPaint,
    );
    canvas.restore();

    // Wheels — spin dikhane ke liye spoke line ke saath.
    for (final wheel in [_frontWheel, _rearWheel]) {
      canvas.save();
      canvas.translate(wheel.position.x, wheel.position.y);
      canvas.drawCircle(Offset.zero, CarValues.wheelRadius, _wheelPaint);
      canvas.rotate(wheel.angle);
      canvas.drawLine(
        Offset.zero,
        Offset(CarValues.wheelRadius, 0),
        _spokePaint,
      );
      canvas.restore();
    }
  }

  @override
  void onRemove() {
    _world.destroyJoint(_frontJoint);
    _world.destroyJoint(_rearJoint);
    _world.destroyBody(_chassis);
    _world.destroyBody(_frontWheel);
    _world.destroyBody(_rearWheel);
    super.onRemove();
  }
}
