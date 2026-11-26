// Gari — chassis + 2 wheels, WheelJoint (motor + suspension) se jure hue.
// Build phase mein frozen rehti hai (gravity 0, soyi hui),
// GO par physics on hoti hai. Shakal: lal rectangle + kaale circle wheels.

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/models/car_data.dart';
import '../../services/sprite_service.dart';
import '../track_builder_game.dart';

class Car extends Component {
  Car({
    required this.startPosition,
    this.carData = starterBug,
    this.surface = SurfaceType.normal,
  });

  /// Shuru ki position — chassis ka centre.
  final Vector2 startPosition;

  /// Chuni hui gari — stats motor/grip/stability badalte hain.
  /// Starter Bug (5/5/5) par saare multipliers 1.0 hain.
  final CarData carData;

  /// Level ki surface — ice par grip kam, sand par motor slow.
  final SurfaceType surface;

  /// Phase 4 sprites — load na hon to null, phir purani shape drawing.
  Sprite? _bodySprite;
  Sprite? _wheelSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _bodySprite = await SpriteService.load(SpritePaths.car(carData.id));
    _wheelSprite = await SpriteService.load(SpritePaths.wheel);
  }

  late Body _chassis;
  late Body _frontWheel;
  late Body _rearWheel;
  late WheelJoint _frontJoint;
  late WheelJoint _rearJoint;
  late Forge2DWorld _world;

  bool _active = false;

  /// Gas/brake hold state — motor speed isi se tay hoti hai.
  bool _gasOn = false;
  bool _brakeOn = false;

  /// Booster overdrive — itne second tak motor tez chalti hai.
  /// Sirf velocity set karna kaafi nahi: wheel motor (gas speed)
  /// boosted gari ko wapas 3 m/s par brake kar deta hai.
  double _boostTimer = 0;

  /// Boost ke dauran motor ki speed (rad/s) — ~7.5 m/s.
  static const double _boostMotorSpeed = 22.0;

  /// Boost kitni der chale — gap paar karne ke liye kaafi.
  static const double _boostDurationSeconds = 2.0;

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
        density: CarValues.bodyDensity * carData.stabilityMultiplier,
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
        friction: CarValues.wheelFriction *
            carData.gripMultiplier *
            SurfaceValues.wheelFrictionMultiplier(surface),
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
    _boostTimer = 0;
    _gasOn = false;
    _brakeOn = false;
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
  /// Motor speed par gari aur surface ke multipliers lagte hain.
  void setGas(bool on) {
    if (!_active) return;
    _gasOn = on;
    _refreshMotorSpeed();
  }

  /// Brake / reverse.
  void setBrake(bool on) {
    if (!_active) return;
    _brakeOn = on;
    _refreshMotorSpeed();
  }

  /// Motor speed tay karo — gas/brake/boost state se.
  /// Boost ke dauran motor tez chalti hai (overdrive), warna
  /// booster ka faida foran khatam ho jata hai.
  void _refreshMotorSpeed() {
    if (!_active) return;
    double speed;
    if (_brakeOn) {
      speed = PhysicsValues.motorSpeedBrake *
          carData.motorMultiplier *
          SurfaceValues.motorMultiplier(surface);
    } else if (_gasOn) {
      speed = _boostTimer > 0
          ? _boostMotorSpeed
          : PhysicsValues.motorSpeedGas *
              carData.motorMultiplier *
              SurfaceValues.motorMultiplier(surface);
    } else {
      speed = 0.0;
    }
    _frontJoint.motorSpeed = speed;
    _rearJoint.motorSpeed = speed;
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_boostTimer > 0) {
      _boostTimer -= dt;
      if (_boostTimer <= 0) {
        // Boost khatam — motor wapas normal gas speed par.
        _refreshMotorSpeed();
      }
    }
  }

  /// Booster pad se takrao — car ki raftaar target tak barhao.
  /// Sirf aage ki taraf; peeche jati gari ko nahi khainchta.
  /// Chassis aur dono wheels ki velocity set hoti hai taake
  /// joint khinchao na paida kare. Motor 2 second ke liye
  /// overdrive par chalti hai — warna gas use wapas slow kar deti hai.
  void applyBoost(double targetSpeedX) {
    if (!_active) return;
    for (final body in [_chassis, _frontWheel, _rearWheel]) {
      final velocity = body.linearVelocity;
      if (velocity.x < targetSpeedX) {
        body.linearVelocity = Vector2(targetSpeedX, velocity.y);
      }
    }
    _boostTimer = _boostDurationSeconds;
    _refreshMotorSpeed();
  }

  /// Bahar se dhakka — snowball jaise hazard ke liye.
  /// Sirf drive phase mein, aur sirf active gari par.
  void applyImpulse(Vector2 impulse) {
    if (!_active) return;
    _chassis.applyLinearImpulse(impulse);
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
    // Chassis — sprite ho to image, warna purana lal rectangle.
    canvas.save();
    canvas.translate(_chassis.position.x, _chassis.position.y);
    canvas.rotate(_chassis.angle);
    final bodySprite = _bodySprite;
    if (bodySprite != null) {
      bodySprite.render(
        canvas,
        position: Vector2(
          -CarValues.bodyWidth / 2,
          -CarValues.bodyHeight / 2,
        ),
        size: Vector2(CarValues.bodyWidth, CarValues.bodyHeight),
      );
    } else {
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
    }
    canvas.restore();

    // Wheels — sprite ho to ghoomti hui image (spoke dikhta hai),
    // warna kaala circle + spoke line.
    for (final wheel in [_frontWheel, _rearWheel]) {
      canvas.save();
      canvas.translate(wheel.position.x, wheel.position.y);
      final wheelSprite = _wheelSprite;
      if (wheelSprite != null) {
        canvas.rotate(wheel.angle);
        wheelSprite.render(
          canvas,
          position: Vector2(
            -CarValues.wheelRadius,
            -CarValues.wheelRadius,
          ),
          size: Vector2(
            CarValues.wheelRadius * 2,
            CarValues.wheelRadius * 2,
          ),
        );
      } else {
        canvas.drawCircle(Offset.zero, CarValues.wheelRadius, _wheelPaint);
        canvas.rotate(wheel.angle);
        canvas.drawLine(
          Offset.zero,
          Offset(CarValues.wheelRadius, 0),
          _spokePaint,
        );
      }
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
