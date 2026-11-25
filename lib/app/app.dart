// App — MaterialApp aur routes.
import 'package:flutter/material.dart';

import '../data/levels/world1_levels.dart';
import '../data/models/player_progress.dart';
import '../data/save_service.dart';
import '../ui/screens/game_screen.dart';
import '../ui/screens/home_screen.dart';

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
