// Saari magic values ek jagah — design rule 2.
// Koi bhi number game code mein hardcode nahi hoga, sirf yahan se aayega.
import 'package:flutter/material.dart';

/// Duniya (world) ki size — metre mein.
/// Camera isi size ka fixed viewport dikhata hai, har screen par ek jaisa.
class WorldSize {
  static const double width = 20.0;
  static const double height = 11.0;

  /// Zameen ki upar wali satah (y) — is se neeche zameen, upar hawa.
  static const double groundTop = 9.0;

  /// Is y se neeche girna = fail (khaai / paani mein girna).
  static const double fallFailY = 11.5;

  /// Grid ki ek cell kitni bari — piece isi par snap hota hai.
  static const double gridCell = 1.0;
}

/// Physics ki values — flame_forge2d ke liye.
class PhysicsValues {
  /// Neeche ki taraf gravity (metre/second^2).
  static const double gravityY = 10.0;

  /// Gari ka motor — gas dabane par wheel ki speed (radians/second).
  /// Wheel radius 0.34m: 9 rad/s ≈ 3 m/s — 15m ka safar ~5 second mein.
  static const double motorSpeedGas = 9.0;

  /// Brake / reverse par wheel ki speed.
  static const double motorSpeedBrake = -6.0;

  /// Motor ki taqat — zyada torque = taiz acceleration.
  static const double maxMotorTorque = 25.0;

  /// Wheel joint ki suspension.
  static const double suspensionFrequencyHz = 4.0;
  static const double suspensionDampingRatio = 0.7;
}

/// Gari ki shakal aur physics — poore game mein ek jaisi rehti hai.
class CarValues {
  static const double bodyWidth = 1.3;
  static const double bodyHeight = 0.5;
  static const double bodyDensity = 1.0;
  static const double bodyFriction = 0.6;

  static const double wheelRadius = 0.34;
  static const double wheelDensity = 1.0;
  static const double wheelFriction = 0.9;

  /// Wheel ki position — body ke centre se.
  static const double wheelOffsetX = 0.45;
  static const double wheelOffsetY = 0.28;
}

/// Drive phase ke fail rules.
class DriveRules {
  /// Gari ulta ho jaye (is angle se zyada tilt) to fail.
  static const double flipAngleRadians = 2.2;

  /// Ulta rehne ka waqt — itni der ulta raha to fail.
  static const double flipHoldSeconds = 0.5;

  /// Gari ruk jaye to kitni der baad fail (stuck).
  static const double stuckSeconds = 5.0;

  /// Stuck check kab se shuru ho — GO ke itne second baad.
  static const double stuckGraceSeconds = 1.0;

  /// Ruki hui gari ki speed ki had (metre/second).
  static const double stuckSpeed = 0.05;
}

/// Piece ki sizes — metre mein.
class PieceValues {
  static const double roadLength = 2.0;
  static const double roadThickness = 0.3;

  static const double rampLength = 2.5;
  static const double rampThickness = 0.3;

  /// Ramp ka default angle — degree mein, upar ki taraf.
  static const double rampDefaultAngleDegrees = 30.0;

  /// Rotate karne par kitne degree ghoome — design doc ke mutabiq 15.
  static const double rotateStepDegrees = 15.0;

  /// Coin ki radius.
  static const double coinRadius = 0.25;

  /// Piece ke neeche wale kinaron ki chamfer (metre) — trapezoid shape:
  /// upar ki satah poori lambai, neeche kinare andar dhalwan, taake wheel
  /// thoda neeche dabe to bhi dhalwan use upar dhakel de.
  static const double edgeChamfer = 0.15;

  /// Finish zone ki chaudai.
  static const double finishZoneWidth = 1.5;

  /// Finish zone ki unchai.
  static const double finishZoneHeight = 3.0;
}

/// Prototype ke colors — shapes se bana hai, abhi koi image nahi.
/// Rang ka matlab hai: road bhoora, booster cyan, khatra lal/narangi.
class GameColors {
  static const Color sky = Color(0xFF87CEEB);
  static const Color grass = Color(0xFF4CAF50);
  static const Color dirt = Color(0xFF8D6E63);
  static const Color water = Color(0xFF2196F3);
  static const Color carBody = Color(0xFFE53935);
  static const Color wheel = Color(0xFF212121);
  static const Color road = Color(0xFF8D6E63);
  static const Color ramp = Color(0xFFFF9800);
  static const Color coin = Color(0xFFFFD600);
  static const Color finish = Color(0xFF000000);
  static const Color ghostValid = Color(0x8800E676);
  static const Color ghostInvalid = Color(0x88E53935);
}
