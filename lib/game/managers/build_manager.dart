// Build phase ki logic — piece lagana, ghumana, hatana, undo.
// Sirf logic hai, koi drawing nahi: piece components game ko
// callback se deta hai, game unhe world mein add karta hai.
import 'package:flame/components.dart';

import '../../core/constants.dart';
import '../../data/models/level_data.dart';
import '../../data/models/piece_type.dart';
import '../components/track_piece.dart';

class BuildManager {
  BuildManager({
    required this.level,
    required this.onPieceAdded,
    required this.onPieceRemoved,
  }) {
    for (final entry in level.tray) {
      _remaining[entry.type] = entry.count;
    }
  }

  final LevelData level;

  /// Game ko batana ke piece add hua — game use world mein dalta hai.
  final void Function(TrackPiece piece) onPieceAdded;

  /// Game ko batana ke piece hata — game use world se nikalta hai.
  final void Function(TrackPiece piece) onPieceRemoved;

  final Map<PieceType, int> _remaining = {};
  final List<TrackPiece> _placed = [];

  /// Tray mein chuna hua piece — null matlab kuch nahi chuna.
  PieceType? selectedPiece;

  List<TrackPiece> get placedPieces => List.unmodifiable(_placed);

  int remainingCount(PieceType type) => _remaining[type] ?? 0;

  /// Is point par piece lagao — theek laga to piece wapas, warna null.
  TrackPiece? placeAt(Vector2 worldPos, PieceType type) {
    if (remainingCount(type) <= 0) return null;

    final center = _snapCenter(type, worldPos);
    if (!_inBounds(center, type)) return null;

    final piece = TrackPiece(
      type: type,
      pieceCenter: center,
      surface: level.surface,
      // Bridge-break hazard (L34) — sirf bridge par, level data se.
      breakAfterSeconds: type == PieceType.bridge
          ? level.bridgeBreakSeconds
          : null,
    );
    _placed.add(piece);
    _remaining[type] = remainingCount(type) - 1;
    onPieceAdded(piece);
    return piece;
  }

  /// Tap par piece ghumao — mila to true.
  bool rotateAt(Vector2 point) {
    final piece = findPieceAt(point);
    if (piece == null) return false;
    piece.rotate();
    return true;
  }

  /// Double-tap par piece hatao aur tray mein wapas karo.
  bool removeAt(Vector2 point) {
    final piece = findPieceAt(point);
    if (piece == null) return false;
    _remove(piece);
    return true;
  }

  /// Aakhri lagaya hua piece wapas lo.
  bool undo() {
    if (_placed.isEmpty) return false;
    _remove(_placed.last);
    return true;
  }

  /// Saare pieces wapas tray mein.
  void clear() {
    for (final piece in List.of(_placed)) {
      _remove(piece);
    }
  }

  TrackPiece? findPieceAt(Vector2 point) {
    for (var i = _placed.length - 1; i >= 0; i--) {
      if (_placed[i].containsPoint(point)) return _placed[i];
    }
    return null;
  }

  void _remove(TrackPiece piece) {
    _placed.remove(piece);
    _remaining[piece.type] = remainingCount(piece.type) + 1;
    onPieceRemoved(piece);
  }

  /// Tap point se piece ka centre nikalo — grid snapping.
  /// Road, Bridge aur Booster: top-left cell par snap, taake zameen se flush baithe.
  /// Ramp: centre 0.5 grid par snap.
  /// Static taake HintManager (ghost solution) wahi centre nikal sake.
  static Vector2 snapCenterFor(PieceType type, Vector2 point) {
    if (type == PieceType.road ||
        type == PieceType.bridge ||
        type == PieceType.booster) {
      final cellX = point.x.floorToDouble();
      final cellY = point.y.floorToDouble();
      return Vector2(cellX + type.length / 2, cellY + type.thickness / 2);
    }
    return Vector2(
      (point.x * 2).roundToDouble() / 2,
      (point.y * 2).roundToDouble() / 2,
    );
  }

  Vector2 _snapCenter(PieceType type, Vector2 point) =>
      snapCenterFor(type, point);

  bool _inBounds(Vector2 center, PieceType type) {
    final half = type.length / 2;
    if (center.x - half < 0 || center.x + half > WorldSize.width) {
      return false;
    }
    if (center.y < 0 || center.y > WorldSize.height) return false;
    return true;
  }
}
