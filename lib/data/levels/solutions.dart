// Har level ka hal (solution) — hint system ke liye.
// Ye file gameplay test files se generate hui hai
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
/// Khaali list matlab level bina piece lagaye pass hota hai.
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
  37: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(6.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(12.2, 9.3), type: PieceType.road),
  ],
  38: [
  ],
  39: [
    SolutionStep(tap: Vector2(9.5, 8.5), type: PieceType.ramp),
  ],
  40: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(10, 7.0), type: PieceType.loop),
  ],
  41: [
    SolutionStep(tap: Vector2(10, 7.0), type: PieceType.loop),
    SolutionStep(tap: Vector2(13.2, 9.3), type: PieceType.bridge),
  ],
  42: [
  ],
  43: [
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(12.5, 8.5), type: PieceType.ramp),
  ],
  44: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(4.5, 8.5), type: PieceType.ramp),
  ],
  45: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(7, 7.0), type: PieceType.loop),
    SolutionStep(tap: Vector2(13, 7.0), type: PieceType.loop),
  ],
  46: [
    SolutionStep(tap: Vector2(14, 6.0), type: PieceType.loop),
  ],
  47: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
  ],
  48: [
    SolutionStep(tap: Vector2(8.2, 8.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(13.5, 6.0), type: PieceType.loop),
    SolutionStep(tap: Vector2(14.2, 8.3), type: PieceType.road),
  ],
  49: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(11.5, 8.5), type: PieceType.ramp),
  ],
  50: [
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.spring),
  ],
  51: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.spring),
    SolutionStep(tap: Vector2(10.2, 8.3), type: PieceType.spring),
  ],
  52: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(8.2, 7.3), type: PieceType.bridge),
  ],
  53: [
    SolutionStep(tap: Vector2(4.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(9.5, 7.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(14.5, 6.5), type: PieceType.ramp),
  ],
  54: [
    SolutionStep(tap: Vector2(7.2, 9.3), type: PieceType.spring),
  ],
  55: [
    SolutionStep(tap: Vector2(4.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.spring),
    SolutionStep(tap: Vector2(11.2, 7.3), type: PieceType.bridge),
  ],
  56: [
  ],
  57: [
    SolutionStep(tap: Vector2(7.2, 7.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(12.2, 9.3), type: PieceType.spring),
  ],
  58: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.spring),
  ],
  59: [
    SolutionStep(tap: Vector2(4.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(9.5, 7.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(13.2, 7.3), type: PieceType.spring),
  ],
  60: [
    SolutionStep(tap: Vector2(3.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(6.2, 8.3), type: PieceType.spring),
    SolutionStep(tap: Vector2(14.2, 6.3), type: PieceType.bridge),
  ],
  61: [
    SolutionStep(tap: Vector2(4.0, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.road),
  ],
  62: [
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(7.5, 8.0), type: PieceType.magnet),
  ],
  63: [
    SolutionStep(tap: Vector2(6.0, 8.5), type: PieceType.ramp),
  ],
  64: [
  ],
  65: [
    SolutionStep(tap: Vector2(7.5, 8.0), type: PieceType.magnet),
  ],
  66: [
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
  ],
  67: [
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
    SolutionStep(tap: Vector2(12.0, 8.5), type: PieceType.ramp),
  ],
  68: [
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
    SolutionStep(tap: Vector2(11.2, 9.3), type: PieceType.road),
  ],
  69: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(6.5, 8.0), type: PieceType.magnet),
    SolutionStep(tap: Vector2(13, 8.5), type: PieceType.magnet),
  ],
  70: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(5.0, 8.5), type: PieceType.ramp),
  ],
  71: [
    SolutionStep(tap: Vector2(9.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(6.0, 8.5), type: PieceType.ramp),
  ],
  72: [
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
    SolutionStep(tap: Vector2(12.0, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(15.5, 8.0), type: PieceType.magnet),
    SolutionStep(tap: Vector2(17.2, 9.3), type: PieceType.road),
  ],
  73: [
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.bridge),
  ],
  74: [
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.road),
  ],
  75: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.road),
  ],
  76: [
    SolutionStep(tap: Vector2(6.5, 8.5), type: PieceType.ramp),
  ],
  77: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(8.5, 8.5), type: PieceType.ramp),
  ],
  78: [
    SolutionStep(tap: Vector2(10.2, 9.3), type: PieceType.road),
  ],
  79: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(11, 7.0), type: PieceType.loop),
  ],
  80: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.spring),
    SolutionStep(tap: Vector2(12.0, 8.0), type: PieceType.ramp),
  ],
  81: [
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(5.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(9.2, 9.3), type: PieceType.road),
  ],
  82: [
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
    SolutionStep(tap: Vector2(11.2, 9.3), type: PieceType.road),
  ],
  83: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(10.5, 8.5), type: PieceType.ramp),
  ],
  84: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(13, 7.0), type: PieceType.loop),
  ],
  85: [
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(14.2, 9.3), type: PieceType.road),
  ],
  86: [
    SolutionStep(tap: Vector2(5.5, 8.5), type: PieceType.ramp),
  ],
  87: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(4.5, 8.5), type: PieceType.ramp),
  ],
  88: [
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.spring),
    SolutionStep(tap: Vector2(12.2, 6.3), type: PieceType.road),
    SolutionStep(tap: Vector2(16.2, 6.3), type: PieceType.road),
  ],
  89: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(9, 7.0), type: PieceType.loop),
  ],
  90: [
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.seesaw),
  ],
  91: [
    SolutionStep(tap: Vector2(4.5, 8.5), type: PieceType.ramp),
    SolutionStep(tap: Vector2(8, 8.0), type: PieceType.magnet),
  ],
  92: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(6.2, 9.3), type: PieceType.bridge),
    SolutionStep(tap: Vector2(14.2, 9.3), type: PieceType.road),
  ],
  93: [
    SolutionStep(tap: Vector2(8.2, 9.3), type: PieceType.road),
    SolutionStep(tap: Vector2(10.5, 8.5), type: PieceType.ramp),
  ],
  94: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(8, 7.0), type: PieceType.loop),
    SolutionStep(tap: Vector2(13.2, 9.3), type: PieceType.bridge),
  ],
  95: [
    SolutionStep(tap: Vector2(6.5, 8.0), type: PieceType.ramp),
  ],
  96: [
    SolutionStep(tap: Vector2(3.2, 9.3), type: PieceType.booster),
    SolutionStep(tap: Vector2(8, 7.0), type: PieceType.loop),
    SolutionStep(tap: Vector2(13.2, 9.3), type: PieceType.bridge),
  ],
};
