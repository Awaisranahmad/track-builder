// Home Screen — Phase 1 mein simple level list.
// Phase 2 mein ye World Map ban jayega.
import 'package:flutter/material.dart';

import '../../data/levels/world1_levels.dart';
import '../../data/models/player_progress.dart';
import '../../data/save_service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
    required this.progress,
    required this.saveService,
  });

  final PlayerProgress progress;
  final SaveService saveService;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Builder'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Build the track. Then drive it.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(' ${progress.totalStars} stars'),
                const SizedBox(width: 16),
                const Icon(Icons.monetization_on, color: Colors.amber),
                Text(' ${progress.totalCoins} coins'),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'World 1 — Green Hills',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: world1Levels.length,
                itemBuilder: (context, index) {
                  final level = world1Levels[index];
                  final stars = progress.starsForLevel(level.id);
                  final unlocked = progress.isLevelUnlocked(level.id);
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        child: Text('${level.id}'),
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
            ),
          ],
        ),
      ),
    );
  }
}
