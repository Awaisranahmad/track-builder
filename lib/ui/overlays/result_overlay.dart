// Result overlay — level khatam hone par: stars, coins, time, buttons.
// Win aur fail dono isi se dikhte hain.
import 'package:flutter/material.dart';

import '../../game/managers/drive_manager.dart';

class ResultOverlay extends StatelessWidget {
  const ResultOverlay({
    super.key,
    required this.result,
    required this.levelName,
    required this.onRetry,
    required this.onNext,
    required this.onLevelSelect,
  });

  final LevelResult result;
  final String levelName;
  final VoidCallback onRetry;
  final VoidCallback onNext;
  final VoidCallback onLevelSelect;

  String get _failText {
    switch (result.failReason) {
      case 'flip':
        return 'Gari ulta ho gayi!';
      case 'fall':
        return 'Gari khaai mein gir gayi!';
      case 'stuck':
        return 'Gari atak gayi!';
      default:
        return 'Level fail ho gaya!';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black54,
      child: Center(
        child: Card(
          margin: const EdgeInsets.all(24),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  result.passed ? levelName : _failText,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (i) {
                    final filled = i < result.stars;
                    return Icon(
                      filled ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 40,
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Text(
                  'Coins: ${result.coinsCollected}/${result.totalCoins}'
                  '   •   Time: ${result.timeSeconds.toStringAsFixed(1)}s',
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ElevatedButton(
                      onPressed: onRetry,
                      child: const Text('Retry'),
                    ),
                    const SizedBox(width: 12),
                    if (result.passed)
                      ElevatedButton(
                        onPressed: onNext,
                        child: const Text('Next Level'),
                      ),
                    const SizedBox(width: 12),
                    TextButton(
                      onPressed: onLevelSelect,
                      child: const Text('Levels'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
