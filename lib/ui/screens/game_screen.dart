// Game Screen — Flame ka GameWidget + Flutter HUD.
// Upar: level naam, coins, timer, pause.
// Neeche: build phase mein piece tray + GO, drive phase mein 2 controls.
// Result aate hi overlay — game se ValueNotifier se baat hoti hai.
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../../data/levels/worlds.dart';
import '../../data/models/level_data.dart';
import '../../data/models/piece_type.dart';
import '../../data/models/player_progress.dart';
import '../../data/save_service.dart';
import '../../game/track_builder_game.dart';
import '../../services/ads_service.dart';
import '../overlays/result_overlay.dart';
import '../widgets/hold_button.dart';
import '../widgets/timer_text.dart';
import '../widgets/tray_chip.dart';

class GameScreen extends StatefulWidget {
  GameScreen({
    super.key,
    required this.level,
    required this.progress,
    required this.saveService,
    AdsService? ads,
  }) : ads = ads ?? adsService;

  final LevelData level;
  final PlayerProgress progress;
  final SaveService saveService;

  /// Ads — default app ka shared service; tests mein testMode wala do.
  final AdsService ads;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late final TrackBuilderGame _game;
  PieceType? _selectedPiece;

  @override
  void initState() {
    super.initState();
    _game = TrackBuilderGame(
      level: widget.level,
      progress: widget.progress,
      saveService: widget.saveService,
      ads: widget.ads,
    );
  }

  @override
  void dispose() {
    _game.phaseNotifier.dispose();
    _game.coinsNotifier.dispose();
    _game.resultNotifier.dispose();
    super.dispose();
  }

  void _selectPiece(PieceType type) {
    setState(() {
      _selectedPiece = _selectedPiece == type ? null : type;
    });
    _game.selectPiece(_selectedPiece);
  }

  void _onPieceDropped(DragTargetDetails<PieceType> details) {
    final worldPos = _game.screenToWorld(
      Vector2(details.offset.dx, details.offset.dy),
    );
    _game.buildManager.placeAt(worldPos, details.data);
    setState(() {});
  }

  Future<void> _onHintPressed() async {
    // Hint baaki ho to foran istemal karo.
    if (_game.hintsLeft > 0) {
      final shown = _game.useHint();
      if (shown) {
        setState(() {});
        return;
      }
    }
    // Koi hint nahi — rewarded ad se +1 hint.
    final watch = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No hints left'),
        content: const Text(
          'Ek chhota sa ad dekho aur +1 hint pao — ghost solution '
          'agle piece ki jagah dikhayega.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Watch Ad'),
          ),
        ],
      ),
    );
    if (watch != true || !mounted) return;
    final rewarded = await widget.ads.showRewarded(placement: 'hint');
    if (!mounted) return;
    if (!rewarded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ad abhi tayyar nahi — baad mein try karo')),
      );
      return;
    }
    widget.progress.grantHint();
    await widget.saveService.saveProgress(widget.progress);
    _game.useHint();
    if (!mounted) return;
    setState(() {});
  }

  Future<void> _showPauseDialog() async {
    _game.pauseGame();
    final action = await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Paused'),
        content: Text(widget.level.name),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop('resume'),
            child: const Text('Resume'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('restart'),
            child: const Text('Restart Level'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop('quit'),
            child: const Text('Quit to Levels'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (action == 'resume') {
      _game.resumeGame();
    } else if (action == 'restart') {
      _game.resumeGame();
      _game.restartLevel();
      setState(() {});
    } else if (action == 'quit') {
      _game.resumeGame();
      Navigator.of(context).pop();
    } else {
      _game.resumeGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          DragTarget<PieceType>(
            onAcceptWithDetails: _onPieceDropped,
            builder: (context, candidateData, rejectedData) {
              return GameWidget(game: _game);
            },
          ),
          _buildHud(),
          _buildBottomBar(),
          ValueListenableBuilder(
            valueListenable: _game.resultNotifier,
            builder: (context, result, child) {
              if (result == null) return const SizedBox.shrink();
              return ResultOverlay(
                result: result,
                levelName: widget.level.name,
                onRetry: () {
                  _game.retry();
                  setState(() {});
                },
                onNext: () {
                  final next = widget.level.id + 1;
                  if (levelById(next) == null) {
                    // Aakhri level — wapas Level Select par.
                    Navigator.of(context).pop();
                    return;
                  }
                  Navigator.of(context).pushReplacementNamed(
                    '/game',
                    arguments: next,
                  );
                },
                onLevelSelect: () => Navigator.of(context).pop(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHud() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            IconButton(
              onPressed: _showPauseDialog,
              icon: const Icon(Icons.pause),
              color: Colors.white,
            ),
            Expanded(
              child: Text(
                'Level ${widget.level.id} — ${widget.level.name}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            ValueListenableBuilder<int>(
              valueListenable: _game.coinsNotifier,
              builder: (context, coins, child) {
                return Row(
                  children: [
                    const Icon(Icons.monetization_on, color: Colors.amber),
                    Text(
                      '$coins/${widget.level.coins.length}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(width: 12),
            ValueListenableBuilder<GamePhase>(
              valueListenable: _game.phaseNotifier,
              builder: (context, phase, child) {
                if (phase != GamePhase.drive) return const SizedBox.shrink();
                return TimerText(game: _game);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: ValueListenableBuilder<GamePhase>(
            valueListenable: _game.phaseNotifier,
            builder: (context, phase, child) {
              if (phase == GamePhase.drive) return _buildDriveControls();
              if (phase == GamePhase.result) return const SizedBox.shrink();
              return _buildTray();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTray() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_selectedPiece != null)
          const Padding(
            padding: EdgeInsets.only(bottom: 6),
            child: Text(
              'Tap the track to place — tap a placed piece to rotate, '
              'double-tap to remove',
              style: TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final entry in widget.level.tray)
              TrayChip(
                type: entry.type,
                remaining: _game.buildManager.remainingCount(entry.type),
                selected: _selectedPiece == entry.type,
                onTap: () => _selectPiece(entry.type),
              ),
            const SizedBox(width: 8),
            IconButton(
              onPressed: _game.canUndo
                  ? () => setState(() => _game.undo())
                  : null,
              icon: const Icon(Icons.undo),
              color: Colors.white,
              tooltip: 'Undo',
            ),
            IconButton(
              onPressed: _game.canUndo
                  ? () => setState(() => _game.clearBuild())
                  : null,
              icon: const Icon(Icons.delete),
              color: Colors.white,
              tooltip: 'Clear all',
            ),
            const SizedBox(width: 8),
            ElevatedButton.icon(
              onPressed: () => setState(() => _game.startDrive()),
              icon: const Icon(Icons.play_arrow),
              label: const Text('GO'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Hint — ghost solution dikhata hai (ad se +1 jab khatam hon).
            OutlinedButton.icon(
              onPressed: _onHintPressed,
              icon: const Icon(Icons.lightbulb, size: 18),
              label: Text('Hint (${_game.hintsLeft})'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Colors.white70),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 8,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDriveControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        HoldButton(
          label: '◀ BRAKE',
          onHold: (on) => _game.setBrake(on),
        ),
        HoldButton(
          label: 'GAS ▶',
          onHold: (on) => _game.setGas(on),
        ),
      ],
    );
  }
}
