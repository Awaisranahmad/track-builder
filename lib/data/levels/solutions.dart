// Har level ka hal (solution) — hint system ke liye.
// Ye file test/gameplay_test.dart se generate hui hai
// (tools/generate_solutions.py) — haath se edit mat karo,
// test badle to dobara generate karo. Tap points wahi hain
// jo headless playtest mein pass hote hain.
import 'package:flame/components.dart';

import '../models/piece_type.dart';

/// Solution ka ek step — konsa piece, kahan tap kar ke lagana hai.
class SolutionStep {
  const SolutionStep({required this.tap, required this.type});

  /// Tap point (world coords) — BuildManager isi se snap karta hai.
  final Vector2 tap;
  final PieceType type;
}

/// Level id -> us ka hal (steps, tarteeb se).
final Map<int, List<SolutionStep>> levelSolutions = {
  1: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
  ],
  2: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.road),
  ],
  3: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.road),
  ],
  4: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
  ],
  5: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(6.5, 8.5), type: PieceType.ramp),
  ],
  6: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(6.5, 8.5), type: PieceType.ramp),
  ],
  7: [
    SolutionStep(tap: Vector2(4.5, 7.5), type: PieceType.ramp),
  ],
  8: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(6.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(12.2, 9.3), type: PieceType.road),
  ],
  9: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
  ],
  10: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(11.5, 8.5), type: PieceType.ramp),
  ],
  11: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(12.2, 9.3), type: PieceType.bridge),
  ],
  12: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(11.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(14.5, 8.5), type: PieceType.ramp),
  ],
  13: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.road),
  ],
  14: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
  ],
  15: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(8.5, 8.5), type: PieceType.ramp),
  ],
  16: [
    SolutionStep(tap: Vector2(5.0, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(11, 9.5), type: PieceType.ramp),
  ],
  17: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.road),
  ],
  18: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(9.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(15.2, 9.3), type: PieceType.road),
  ],
  19: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(9.5, 8.5), type: PieceType.ramp),
  ],
  20: [
    SolutionStep(tap: Vector2(12.2, 9.3), type: PieceType.road),
  ],
  21: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.bridge),
  ],
  22: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.bridge),
  ],
  23: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(9.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(16.2, 9.3), type: PieceType.road),
  ],
  24: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(14.5, 8.5), type: PieceType.ramp),
  ],
  25: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
  ],
  26: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.road),
  ],
  27: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(5.0, 8.5), type: PieceType.ramp),
  ],
  28: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
  ],
  29: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(5.0, 8.5), type: PieceType.ramp),
  ],
  30: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(9.5, 8.5), type: PieceType.ramp),
  ],
  31: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(5.5, 7.0), type: PieceType.ramp),
  ],
  32: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.road),
  ],
  33: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(4.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(13.0, 8.5), type: PieceType.ramp),
  ],
  34: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
  ],
  35: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(10.5, 8.5), type: PieceType.ramp),
  ],
  36: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(11.0, 8.5), type: PieceType.ramp),
  ],
};
