// App — MaterialApp aur routes.
// Routes: '/' Home, '/worlds' World Map, '/levels' Level Select
// (arguments: world id), '/game' Game Screen (arguments: level id),
// '/garage' Garage, '/settings' Settings.
import 'package:flutter/material.dart';

import '../data/levels/worlds.dart';
import '../data/models/player_progress.dart';
import '../data/save_service.dart';
import '../garage/garage_screen.dart';
import '../ui/screens/game_screen.dart';
import '../ui/screens/home_screen.dart';
import '../ui/screens/level_select_screen.dart';
import '../ui/screens/settings_screen.dart';
import '../ui/screens/world_map_screen.dart';

class TrackBuilderApp extends StatelessWidget {
  const TrackBuilderApp({
    super.key,
    required this.progress,
    required this.saveService,
  });

  final PlayerProgress progress;
  final SaveService saveService;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Track Builder',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (_) => HomeScreen(
              progress: progress,
              saveService: saveService,
            ),
          );
        }
        if (settings.name == '/worlds') {
          return MaterialPageRoute(
            builder: (_) => WorldMapScreen(
              progress: progress,
              saveService: saveService,
            ),
          );
        }
        if (settings.name == '/garage') {
          return MaterialPageRoute(
            builder: (_) => GarageScreen(
              progress: progress,
              saveService: saveService,
            ),
          );
        }
        if (settings.name == '/settings') {
          return MaterialPageRoute(
            builder: (_) => SettingsScreen(
              progress: progress,
              saveService: saveService,
            ),
          );
        }
        if (settings.name == '/levels') {
          final worldId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (_) => LevelSelectScreen(
              worldId: worldId,
              progress: progress,
              saveService: saveService,
            ),
          );
        }
        if (settings.name == '/game') {
          final levelId = settings.arguments as int;
          final level = levelById(levelId);
          if (level == null) {
            return MaterialPageRoute(
              builder: (_) => HomeScreen(
                progress: progress,
                saveService: saveService,
              ),
            );
          }
          return MaterialPageRoute(
            builder: (_) => GameScreen(
              level: level,
              progress: progress,
              saveService: saveService,
            ),
          );
        }
        return null;
      },
    );
  }
}
