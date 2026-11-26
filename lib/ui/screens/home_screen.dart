// Home Screen — game ki pehli shakal.
// Play → World Map. Stars/coins upar. Garage aur Settings
// Phase 3 mein ban gaye — ab asli screens khulti hain.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../data/models/player_progress.dart';
import '../../data/save_service.dart';
import '../../services/audio_service.dart';

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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Build the track. Then drive it.',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.star, color: Colors.amber),
                Text(' ${progress.totalStars} stars'),
                const SizedBox(width: 16),
                const Icon(Icons.monetization_on, color: Colors.amber),
                Text(' ${progress.totalCoins} coins'),
              ],
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () {
                unawaited(audioService.playSfx('click'));
                Navigator.of(context).pushNamed('/worlds');
              },
              icon: const Icon(Icons.play_arrow, size: 32),
              label: const Text(
                'Play',
                style: TextStyle(fontSize: 24),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 20),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/garage'),
                    icon: const Icon(Icons.directions_car),
                    label: const Text('Garage'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/settings'),
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
                  ),
                ),
              ],
            ),
            const Spacer(),
            const Text(
              'World 1-3: 36 levels — Green Hills, Desert, Snow',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
