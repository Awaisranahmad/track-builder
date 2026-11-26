// World Map Screen — 8 worlds ki list.
// Agla world tab khulta hai jab pichle mein 20+ stars hon
// (PlayerProgress.isWorldUnlocked). Locked world par taala.
// Jin worlds ke levels abhi nahi bane, un par "jald aayega".
import 'package:flutter/material.dart';

import '../../data/levels/worlds.dart';
import '../../data/models/player_progress.dart';
import '../../data/save_service.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({
    super.key,
    required this.progress,
    required this.saveService,
  });

  final PlayerProgress progress;
  final SaveService saveService;

  int _worldStars(WorldInfo world) {
    var total = 0;
    for (final level in world.levels) {
      total += progress.starsForLevel(level.id);
    }
    return total;
  }

  void _openWorld(BuildContext context, WorldInfo world) {
    if (!progress.isWorldUnlocked(world.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Pehle World ${world.id - 1} mein 20 stars kamao',
          ),
        ),
      );
      return;
    }
    if (world.levels.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ye world abhi ban raha hai')),
      );
      return;
    }
    Navigator.of(context).pushNamed('/levels', arguments: world.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Worlds'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: worlds.length,
        itemBuilder: (context, index) {
          final world = worlds[index];
          final unlocked = progress.isWorldUnlocked(world.id);
          final stars = _worldStars(world);
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                child: Text('${world.id}'),
              ),
              title: Text(world.name),
              subtitle: Text(
                world.levels.isEmpty
                    ? '${world.subtitle} — jald aayega'
                    : '${world.subtitle} • $stars/${world.maxStars} stars',
              ),
              trailing: unlocked
                  ? const Icon(Icons.play_arrow)
                  : const Icon(Icons.lock),
              onTap: () => _openWorld(context, world),
            ),
          );
        },
      ),
    );
  }
}
