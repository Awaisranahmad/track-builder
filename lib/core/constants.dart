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

  /// Booster pad ki raftaar — car is se tez nahi, is se kam ho to
  /// itni kar di jati hai (metre/second). 7.5 m/s se 30° ramp
  /// ~5m aage utarta hai aur 6m gap paar karta hai (playtest se tune hua).
  /// 6.5 par landing gap ke kinare par hoti thi — gari peeche gir jati thi.
  static const double boosterTargetSpeed = 7.5;

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

/// Zameen ki surface — friction tay karti hai.
/// LevelData mein istemal hota hai; values SurfaceValues mein hain.
enum SurfaceType { normal, sand, ice }

/// Zameen ki surface ki physics — LevelData.surface se aati hai.
/// normal: Green Hills. sand: Desert (motor halka slow).
/// ice: Snow Peaks (grip kam — brake lambi, jump chhote).
class SurfaceValues {
  /// Terrain fixture ki friction.
  /// Ice 0.55 hai (0.15 nahi) — itni kam friction par gari 30° ramp
  /// par charh nahi sakti (traction < gravity component). 0.55 par
  /// combined friction ~0.67 hoti hai — brake lambi rehti hai lekin
  /// ramp climb ho jata hai (playtest se tune hua).
  static double terrainFriction(SurfaceType surface) {
    switch (surface) {
      case SurfaceType.normal:
        return 0.8;
      case SurfaceType.sand:
        return 1.0;
      case SurfaceType.ice:
        return 0.55;
    }
  }

  /// Wheel friction ka multiplier (CarValues.wheelFriction par lagta hai).
  static double wheelFrictionMultiplier(SurfaceType surface) {
    switch (surface) {
      case SurfaceType.normal:
        return 1.0;
      case SurfaceType.sand:
        return 1.0;
      case SurfaceType.ice:
        return 0.9;
    }
  }

  /// Motor speed ka multiplier — ret mein gari halki slow chalti hai.
  static double motorMultiplier(SurfaceType surface) {
    switch (surface) {
      case SurfaceType.normal:
        return 1.0;
      case SurfaceType.sand:
        return 0.8;
      case SurfaceType.ice:
        return 1.0;
    }
  }}

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

  /// Bridge ki lambai — road se dugni, chauda gap cover karta hai.
  static const double bridgeLength = 4.0;
  static const double bridgeThickness = 0.3;

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
  // World 2 — Desert Dunes: ret aur garm aasman.
  static const Color desertSky = Color(0xFFFFE0B2);
  static const Color sand = Color(0xFFEDC987);
  static const Color sandDirt = Color(0xFFD9A45B);
  static const Color dune = Color(0xFFF0C078);
  // World 3 — Snow Peaks: barf aur halka neela aasman.
  static const Color snowSky = Color(0xFFD6ECF5);
  static const Color snow = Color(0xFFF4FAFD);
  static const Color snowDirt = Color(0xFFB9D3E0);
  static const Color snowHill = Color(0xFFFFFFFF);
  static const Color ghostValid = Color(0x8800E676);
  static const Color ghostInvalid = Color(0x88E53935);
}

/// Ads ki values — design doc §6 system 8 (Ads / Earning).
/// Rule: drive ke beech mein kabhi ad nahi; interstitial sirf fail ke
/// baad, har 3rd fail par; rewarded hint / coins / skip ke liye.
class AdsValues {
  /// Interstitial kitne fails ke baad — har 3rd fail par.
  static const int interstitialEveryNFails = 3;

  /// Do interstitials ke beech kam az kam waqfa (seconds).
  static const int interstitialCooldownSeconds = 60;

  /// Rewarded ad dekhne par kitne coins (Garage mein).
  static const int rewardedCoinsAmount = 50;

  /// Do rewarded ads ke beech kam az kam waqfa (seconds).
  static const int rewardedCooldownSeconds = 30;
}

/// Hints ki values — rewarded ad se hint milta hai, ghost solution dikhta hai.
class HintValues {
  /// Shuru mein kitne free hints milte hain.
  static const int startingHints = 3;

  /// Ghost solution kitni der dikhe (seconds).
  static const double ghostVisibleSeconds = 6.0;
}

/// Particles / effects ki values — design doc §6, effects manager.
class EffectsValues {
  /// Coin collect par kitne sparks.
  static const int coinSparkCount = 12;

  /// Crash par kitne smoke puffs.
  static const int crashSmokeCount = 10;

  /// Win par kitne confetti pieces.
  static const int winConfettiCount = 40;

  /// Booster flame — kitne particles, kitni der.
  static const int boostFlameCount = 8;

  /// Camera shake kitni der (seconds) aur kitna (metre).
  static const double shakeDurationSeconds = 0.35;
  static const double shakeAmountMetres = 0.12;

  /// Crash shake thoda zyada.
  static const double crashShakeAmountMetres = 0.2;
}
