// Hold karne wala button — dabaye rakho to gas/brake, chhoro to band.
import 'package:flutter/material.dart';

class HoldButton extends StatelessWidget {
  const HoldButton({super.key, required this.label, required this.onHold});

  final String label;
  final void Function(bool on) onHold;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => onHold(true),
      onPointerUp: (_) => onHold(false),
      onPointerCancel: (_) => onHold(false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.black45,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white70),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
