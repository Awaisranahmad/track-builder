// Piece ki qisam — har piece ka size, rang aur unlock level.
import 'package:flutter/material.dart';

import '../../core/constants.dart';

/// Saare 8 pieces — design doc page 3 ke mutabiq.
/// Phase 1 mein sirf road aur ramp ke components bane hain;
/// baaki pieces Phase 2-5 mein aayenge, lekin un ka data abhi se tay hai.
enum PieceType {
  road,
  ramp,
  bridge,
  booster,
  loop,
  spring,
  seesaw,
  magnet,
}

extension PieceTypeInfo on PieceType {
  /// Tray aur UI mein dikhane wala naam.
  String get label {
    switch (this) {
      case PieceType.road:
        return 'Road';
      case PieceType.ramp:
        return 'Ramp';
      case PieceType.bridge:
        return 'Bridge';
      case PieceType.booster:
        return 'Booster';
      case PieceType.loop:
        return 'Loop';
      case PieceType.spring:
        return 'Spring';
      case PieceType.seesaw:
        return 'See-Saw';
      case PieceType.magnet:
        return 'Magnet';
    }
  }

  /// Piece ki lambai (metre) — grid cells mein.
  double get length {
    switch (this) {
      case PieceType.road:
        return PieceValues.roadLength;
      case PieceType.ramp:
        return PieceValues.rampLength;
      case PieceType.bridge:
        return 4.0;
      case PieceType.booster:
        return 1.0;
      case PieceType.loop:
        return 2.0;
      case PieceType.spring:
        return 1.0;
      case PieceType.seesaw:
        return 3.0;
      case PieceType.magnet:
        return 2.0;
    }
  }

  /// Piece ki motai (metre).
  double get thickness {
    switch (this) {
      case PieceType.road:
        return PieceValues.roadThickness;
      case PieceType.ramp:
        return PieceValues.rampThickness;
      default:
        return 0.3;
    }
  }

  /// Prototype ka rang — baad mein sprite aayegi, physics wahi rahega.
  Color get color {
    switch (this) {
      case PieceType.road:
        return GameColors.road;
      case PieceType.ramp:
        return GameColors.ramp;
      case PieceType.bridge:
        return const Color(0xFF795548);
      case PieceType.booster:
        return const Color(0xFF00E5FF);
      case PieceType.loop:
        return const Color(0xFF9C27B0);
      case PieceType.spring:
        return const Color(0xFF4CAF50);
      case PieceType.seesaw:
        return const Color(0xFFFFC107);
      case PieceType.magnet:
        return const Color(0xFF3F51B5);
    }
  }

  /// Kis level se unlock hota hai — design doc ke mutabiq.
  int get unlockLevel {
    switch (this) {
      case PieceType.road:
        return 1;
      case PieceType.ramp:
        return 5;
      case PieceType.bridge:
        return 9;
      case PieceType.booster:
        return 27;
      case PieceType.loop:
        return 40;
      case PieceType.spring:
        return 50;
      case PieceType.seesaw:
        return 66;
      case PieceType.magnet:
        return 61;
    }
  }

  /// Kya is piece ka component Phase 1 mein bana hua hai?
  bool get isImplemented {
    switch (this) {
      case PieceType.road:
      case PieceType.ramp:
        return true;
      default:
        return false;
    }
  }
}
