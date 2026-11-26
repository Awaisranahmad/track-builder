// Level Select Screen — ek world ke 12 levels.
// Har level par mile hue stars dikhte hain. Locked level tap nahi hota.
import 'package:flutter/material.dart';

import '../../data/levels/worlds.dart';
import '../../data/models/player_progress.dart';
import '../../data/save_service.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({
    super.key,
    required this.worldId,
    required this.progress,
    required this.saveService,
  });

  final int worldId;
  final PlayerProgress progress;
  final SaveService saveService;

  @override
  Widget build(BuildContext context) {
    final world = worldById(worldId);
    if (world == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Levels')),
        body: const Center(child: Text('World nahi mila')),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('World ${world.id} — ${world.name}'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: world.levels.length,
        itemBuilder: (context, index) {
          final level = world.levels[index];
          final stars = progress.starsForLevel(level.id);
          final unlocked = progress.isLevelUnlocked(level.id);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${level.levelInWorld}'),
              ),
              title: Text(level.name),
              subtitle: Row(
                children: List.generate(3, (i) {
                  return Icon(
                    i < stars ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  );
                }),
              ),
              trailing: unlocked
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.lock),
              onTap: unlocked
                  ? () => Navigator.of(context).pushNamed(
                        '/game',
                        arguments: level.id,
                      )
                  : null,
            ),
          );
        },
      ),
    );
  }
}
