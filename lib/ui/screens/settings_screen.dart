// Settings Screen — music on/off, SFX on/off, progress reset.
// Design doc §8: settings_screen.dart. Toggles foran save hote hain
// aur AudioService ko bhi batate hain.
import 'package:flutter/material.dart';

import '../../data/models/player_progress.dart';
import '../../data/save_service.dart';
import '../../services/audio_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.progress,
    required this.saveService,
  });

  final PlayerProgress progress;
  final SaveService saveService;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  PlayerProgress get _progress => widget.progress;

  Future<void> _setMusic(bool on) async {
    setState(() => _progress.musicOn = on);
    await audioService.setMusicEnabled(on);
    await widget.saveService.saveProgress(_progress);
  }

  Future<void> _setSfx(bool on) async {
    setState(() => _progress.sfxOn = on);
    audioService.setSfxEnabled(on);
    await widget.saveService.saveProgress(_progress);
  }

  Future<void> _confirmReset() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset progress?'),
        content: const Text(
          'Saare stars, coins aur unlocked levels khatam ho jayenge. '
          'Ye wapas nahi aayega.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Reset',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    _progress.reset();
    await widget.saveService.saveProgress(_progress);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Progress reset ho gayi')),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Music'),
            subtitle: const Text('Background music on/off'),
            value: _progress.musicOn,
            onChanged: _setMusic,
          ),
          SwitchListTile(
            title: const Text('Sound Effects'),
            subtitle: const Text('Coin, win, crash aur engine sounds'),
            value: _progress.sfxOn,
            onChanged: _setSfx,
          ),
          const Divider(),
          ListTile(
            title: Text(
              'Reset Progress',
              style: TextStyle(color: Colors.red[700]),
            ),
            subtitle: const Text('Stars, coins aur unlocks saaf karo'),
            trailing: const Icon(Icons.delete_forever, color: Colors.red),
            onTap: _confirmReset,
          ),
          const Divider(),
          ListTile(
            title: const Text('Track Builder'),
            subtitle: Text(
              'Version 1.0.0 — ${_progress.totalStars} stars, '
              '${_progress.totalCoins} coins',
            ),
          ),
        ],
      ),
    );
  }
}
