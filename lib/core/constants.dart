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
  // World 4 — Night City: gehra neela aasman, neon sheher.
  static const Color nightSky = Color(0xFF1A1A40);
  static const Color nightDirt = Color(0xFF2D2D5A);
  static const Color nightTop = Color(0xFF3D3D7A);
  // World 5 — Jungle Ruins: gehra sabz, pathar.
  static const Color jungleSky = Color(0xFFBFE3B4);
  static const Color jungleDirt = Color(0xFF6D4C41);
  static const Color jungleTop = Color(0xFF2E7D32);
  // World 6 — Space Station: kala aasman, sitaray.
  static const Color spaceSky = Color(0xFF0B0B1E);
  static const Color spaceDirt = Color(0xFF3A3A55);
  static const Color spaceTop = Color(0xFF5A5A8A);
  // World 7 — Volcano: narangi aasman, kala pathar.
  static const Color volcanoSky = Color(0xFFFFCC80);
  static const Color volcanoDirt = Color(0xFF4E342E);
  static const Color volcanoTop = Color(0xFF6D4C41);
  // World 8 — Sky Islands: halka neela, badal.
  static const Color skyIslandsSky = Color(0xFFB3E5FC);
  static const Color skyIslandsDirt = Color(0xFF8D6E63);
  static const Color skyIslandsTop = Color(0xFFA5D6A7);
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

  /// AdMob test ad unit IDs (Google ke official test IDs) —
  /// asal App ID / ad unit IDs aane tak in se wiring test hoti hai.
  /// Awais ke AdMob account ke asal IDs milne par yahan badlo.
  static const String testInterstitialAdUnitId =
      'ca-app-pub-3940256099942544/1033173712';
  static const String testRewardedAdUnitId =
      'ca-app-pub-3940256099942544/5224354917';

  /// AdMob App ID (test) — AndroidManifest / Info.plist mein bhi hai.
  static const String testAppId = 'ca-app-pub-3940256099942544~3349999999';
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

/// Loop piece ki values — Phase 5, World 4 (Night City).
/// Ring ka radius: booster speed (7.5 m/s) se top par bhi
/// centripetal force gravity se zyada rehti hai (v²/R = 35 > 10).
/// Radius 1.6m hai — 1.2m par gari ki pitch bahut tez badalti thi
/// (probe: entry par 72° in 0.24s, gari ulta ho jati thi).
/// Gap 60° hai — entry tangent 30° (gentle), chord 1.6m (gari fit hoti hai).
/// DESIGN (probe se seekha): ChainShape two-sided hoti hai (forge2d ka
/// collideEdgeAndCircle normal ko circle ki taraf flip karta hai) —
/// is liye ring ki bahar wali face bhi takrati hai. Gari seedha circle
/// se takra kar wapas uchhalti hai. Is liye loop mein entry/exit RAMP
/// hain (30° trapezoid, Ramp piece jaisa): gari ramp par charh kar
/// circle ke tangent se milti hai, phir circle ke andar chalti hai.
/// Circle ka centre y=7.0 par hona chahiye (zameen y=9.0) — ramp
/// usi hisab se banta hai.
class LoopValues {
  /// Ring ka radius (metre) — diameter 3.2m.
  static const double radius = 1.6;

  /// Ring ke neeche khula hissa — is angle (degree) ke andar
  /// arc nahi hoti (entry/exit ramp wahan milte hain).
  /// Neeche ka gap: 60° se 120° tak khula (y neeche ki taraf).
  static const double gapStartDegrees = 30.0; // right gap point — gari zameen par neeche se guzar sake
  static const double gapEndDegrees = 120.0;
  /// Arc (ring) shuru hota hai yahan se — gap se bara, taake wheel entry
  /// pe arc se na takraye. Ramp gapEnd (120 deg) pe khatam hota hai.
  static const double arcStartDegrees = 150.0;

  /// Arc kitne segments mein banti hai (gap ke bahar).
  static const int arcSegments = 12;

  /// Arc ki motai (metre).
  static const double arcThickness = 0.15;

  /// Entry/exit ramp ki motai (metre).
  static const double rampThickness = 0.3;

  /// Entry/exit ramp ka angle — 30° par gari ramp ki base se
  /// uchhal kar arc ki bahar wali face se takrati thi (probe se).
  /// 20° par gari ramp par rehti hai aur gap se andar dakhil hoti hai.
  static const double rampAngleDegrees = 20.0;
}

/// Spring Pad ki values — Phase 5, World 5 (Jungle Ruins).
/// Fixed bounce: launch velocity se ~3.6m uncha bounce (v²/2g).
class SpringValues {
  /// Upar ki taraf launch velocity (metre/second).
  static const double launchVelocity = 8.5;

  /// Pad ki chaudai (metre) — piece length 1.0 se match.
  static const double padWidth = 1.0;
}

/// See-Saw ki values — Phase 5, World 6 (Space Station).
/// Plank pivot par jhulti hai; gari ka wazan use jhukata hai.
class SeesawValues {
  /// Plank ki lambai (metre) — piece length 3.0 se match.
  static const double plankLength = 3.0;

  /// Plank ki motai (metre).
  static const double plankThickness = 0.3;

  /// Plank ki density — halki, taake gari ke wazan se jhuke.
  static const double plankDensity = 0.5;

  /// Jhukne ki had (radians) — dono taraf ~26°.
  static const double maxTiltRadians = 0.45;

  /// Jhukna slow ho — gari ke paar jane ka waqt mile.
  static const double angularDamping = 1.5;
}

/// Magnet / Zero-G zone ki values — Phase 5, World 6.
/// Zone ke andar gravity kam ho jati hai — gari tairti hai.
class MagnetValues {
  /// Zone ki chaudai (metre) — piece length 2.0 se match.
  static const double zoneWidth = 2.0;

  /// Zone ki unchai (metre) — piece centre se upar/neeche.
  static const double zoneHeight = 5.0;

  /// Zone ke andar gravity ka scale — 0.15x (floaty, slow).
  static const double gravityScale = 0.15;
}

/// Lift (moving platform) ki values — Phase 5, World 4.
class LiftValues {
  /// Platform ki chaudai (metre).
  static const double platformWidth = 2.5;

  /// Platform ki motai (metre).
  static const double platformThickness = 0.3;

  /// Upar/neeche aane-jane ki raftaar (metre/second).
  static const double speed = 1.0;

  /// Har siray par rukne ka waqt (seconds) — gari charh/utar sake.
  static const double dwellSeconds = 0.8;
}

/// Timed gate ki values — Phase 5, World 4/7.
/// Deewar khulti/band hoti hai — cycle par.
class GateValues {
  /// Deewar ki chaudai (metre).
  static const double wallWidth = 0.3;

  /// Deewar ki unchai (metre) — band ho to rasta poora band.
  static const double wallHeight = 2.5;

  /// Khulne/band hone mein lagne wala waqt (seconds).
  static const double transitionSeconds = 0.4;
}

/// Lava ki values — Phase 5, World 7 (Volcano).
/// Lava chhoona = foran fail (design doc: lava is an instant fail).
class LavaValues {
  /// Rising lava kitni tez upar aata hai (metre/second).
  static const double riseRate = 0.25;
}

/// Hawa (wind) ki values — Phase 5, World 8 (Sky Islands).
/// Gusts gari ko dhakelti hain — flags se timing dikhti hai.
class WindValues {
  /// Hawa ki taqat — chassis par force (newton, mass ~1.5).
  /// 3.0 N se ~2 m/s² acceleration — jump ko halka mod deti hai.
  static const double pushForce = 3.0;
}

/// Falling rocks ki values — Phase 5, World 5/7.
/// Pathar upar se girta hai, gari ko dhakka deta hai.
class RockValues {
  /// Pathar ka radius (metre).
  static const double radius = 0.35;

  /// Zameen par girne ke kitne second baad pathar ghayab ho.
  static const double despawnAfterSeconds = 2.5;

  /// Gari se takrao par dhakka (impulse) — snowball jaisa.
  static const double hitImpulseX = -1.2;
  static const double hitImpulseY = -0.8;
}

/// Lava geyser ki values — Phase 5, World 7.
class GeyserValues {
  /// Geyser column ki chaudai (metre).
  static const double columnWidth = 0.6;
}

/// Crumble stone ki values — Phase 5, World 5.
/// Platform gari ke touch ke itne second baad toot jata hai.
class CrumbleValues {
  /// Touch ke baad tootne ka waqt (seconds).
  static const double breakAfterSeconds = 1.5;

  /// Tootne ke baad fade (seconds).
  static const double fadeSeconds = 0.4;
}
