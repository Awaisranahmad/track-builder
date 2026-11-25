// Timer — har 100ms mein game se waqt parhta hai.
import 'dart:async';

import 'package:flutter/material.dart';

import '../../game/track_builder_game.dart';

class TimerText extends StatefulWidget {
  const TimerText({super.key, required this.game});

  final TrackBuilderGame game;

  @override
  State<TimerText> createState() => _TimerTextState();
}

class _TimerTextState extends State<TimerText> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(
      const Duration(milliseconds: 100),
      (_) => setState(() {}),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${widget.game.elapsed.toStringAsFixed(1)}s',
      style: const TextStyle(color: Colors.white),
    );
  }
}
