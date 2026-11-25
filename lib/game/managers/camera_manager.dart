// Camera — Phase 1 mein fixed: poora level ek screen par dikhta hai,
// taake build phase mein poori problem nazar aaye.
// Drive mein follow Phase 2 mein aayega (lambe levels ke liye).
import 'package:flame/camera.dart';
import 'package:flame/components.dart';

import '../../core/constants.dart';
import '../track_builder_game.dart';

class CameraManager {
  CameraManager(this.game);

  final TrackBuilderGame game;

  /// Fixed resolution viewport — har screen par duniya ek jaisi dikhe.
  void setupFixedCamera() {
    game.camera.viewport = FixedResolutionViewport(
      resolution: Vector2(WorldSize.width, WorldSize.height),
    );
    game.camera.viewfinder.anchor = Anchor.topLeft;
    game.camera.viewfinder.position = Vector2.zero();
  }
}
