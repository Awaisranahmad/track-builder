// Tray ka ek piece — drag bhi hota hai, tap se select bhi hota hai.
import 'package:flutter/material.dart';

import '../../data/models/piece_type.dart';

class TrayChip extends StatelessWidget {
  const TrayChip({
    super.key,
    required this.type,
    required this.remaining,
    required this.selected,
    required this.onTap,
  });

  final PieceType type;
  final int remaining;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final chip = Opacity(
      opacity: remaining > 0 ? 1 : 0.35,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : type.color,
          borderRadius: BorderRadius.circular(10),
          border:
              selected ? Border.all(color: Colors.yellow, width: 3) : null,
        ),
        child: Text(
          '${type.label} x$remaining',
          style: TextStyle(
            color: selected ? Colors.black : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    if (remaining <= 0) return chip;
    return Draggable<PieceType>(
      data: type,
      feedback: Material(child: chip),
      childWhenDragging: Opacity(opacity: 0.4, child: chip),
      child: GestureDetector(onTap: onTap, child: chip),
    );
  }
}
