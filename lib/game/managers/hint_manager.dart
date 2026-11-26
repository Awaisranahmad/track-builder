// Hint Manager — solution ka agla step dhoondho, ghost dikhao.
// Solution data lib/data/levels/solutions.dart mein hai (playtest ke
// hal se generate hua). Ek hint = agla step jo abhi laga nahi.
// Player ne step khud laga liya ho to hint usay chhor kar agle par jata hai.
import '../../data/levels/solutions.dart';
import '../../data/models/level_data.dart';
import 'build_manager.dart';
import '../components/ghost_hint.dart';

class HintManager {
  HintManager({required this.level, required this.buildManager});

  final LevelData level;
  final BuildManager buildManager;

  /// Is level ka hal — na ho to khaali.
  List<SolutionStep> get solution => levelSolutions[level.id] ?? const [];

  /// Agla step jo abhi laga nahi — koi na bache to null.
  SolutionStep? nextStep() {
    for (final step in solution) {
      if (!_isPlaced(step)) return step;
    }
    return null;
  }

  /// Kitne steps baaki hain (hint se dikhane ke liye).
  int get remainingSteps {
    var count = 0;
    for (final step in solution) {
      if (!_isPlaced(step)) count++;
    }
    return count;
  }

  /// Kya ye step pehle se laga hua hai — type + centre milna chahiye.
  bool _isPlaced(SolutionStep step) {
    final center = BuildManager.snapCenterFor(step.type, step.tap);
    for (final piece in buildManager.placedPieces) {
      if (piece.type != step.type) continue;
      if ((piece.pieceCenter - center).length < 0.05) return true;
    }
    return false;
  }

  /// Agle step ka ghost component banao — game use world mein dalega.
  /// Koi step na bache to null.
  GhostHintComponent? ghostForNextStep() {
    final step = nextStep();
    if (step == null) return null;
    return GhostHintComponent(
      type: step.type,
      center: BuildManager.snapCenterFor(step.type, step.tap),
    );
  }
}

