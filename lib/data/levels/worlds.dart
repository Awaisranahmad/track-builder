// 8 worlds ki list — World Map screen isi se banti hai.
// Level design doc page 5 ke mutabiq: naam, naya idea, feel.
// Phase 3 mein World 1-3 ke levels hain; baaki worlds
// Phase 4-5 mein aayenge (levels khaali = "jald aayega").
import '../models/level_data.dart';
import 'world1_levels.dart';
import 'world4_levels.dart';
import 'world5_levels.dart';
import 'world6_levels.dart';
import 'world7_levels.dart';
import 'world8_levels.dart';
import 'world2_levels.dart';
import 'world3_levels.dart';

/// Ek world ki info — naam, naya idea, us ke levels.
class WorldInfo {
  const WorldInfo({
    required this.id,
    required this.name,
    required this.subtitle,
    required this.levels,
  });

  final int id;
  final String name;

  /// Is world mein kya naya hai — ek line.
  final String subtitle;

  final List<LevelData> levels;

  /// Kul stars jo is world mein mil sakte hain.
  int get maxStars => levels.length * 3;
}

/// Saare 8 worlds — design doc ke mutabiq.
const List<WorldInfo> worlds = [
  WorldInfo(
    id: 1,
    name: 'Green Hills',
    subtitle: 'Road, Ramp, Bridge seekho',
    levels: world1Levels,
  ),
  WorldInfo(
    id: 2,
    name: 'Desert Dunes',
    subtitle: 'Slopes aur lambe bridges',
    levels: world2Levels,
  ),
  WorldInfo(
    id: 3,
    name: 'Snow Peaks',
    subtitle: 'Booster aur low grip',
    levels: world3Levels,
  ),
  WorldInfo(
    id: 4,
    name: 'Night City',
    subtitle: 'Loop aur moving platforms',
    levels: world4Levels,
  ),
  WorldInfo(
    id: 5,
    name: 'Jungle Ruins',
    subtitle: 'Spring Pad aur vertical levels',
    levels: world5Levels,
  ),
  WorldInfo(
    id: 6,
    name: 'Space Station',
    subtitle: 'See-Saw aur Zero-G',
    levels: world6Levels,
  ),
  WorldInfo(
    id: 7,
    name: 'Volcano',
    subtitle: 'Timed gates aur lava',
    levels: world7Levels,
  ),
  WorldInfo(
    id: 8,
    name: 'Sky Islands',
    subtitle: 'Sab kuch combined — finale',
    levels: world8Levels,
  ),
];

/// World id se dhoondho — na mile to null.
WorldInfo? worldById(int id) {
  for (final world in worlds) {
    if (world.id == id) return world;
  }
  return null;
}

/// Saare bane hue levels — World 1-8 (Phase 5 tak 96).
const List<LevelData> allLevels = [
  ...world1Levels,
  ...world2Levels,
  ...world3Levels,
  ...world4Levels,
  ...world5Levels,
  ...world6Levels,
  ...world7Levels,
  ...world8Levels,
];

/// Level id se dhoondho — na mile to null.
LevelData? levelById(int id) {
  for (final level in allLevels) {
    if (level.id == id) return level;
  }
  return null;
}
