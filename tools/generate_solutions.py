#!/usr/bin/env python3
"""Hint solutions generate karo — test/gameplay_test.dart se.

Level 1 ka hal alag test mein hai (road lagao, GO, gas) — wo haath se
solutions.dart mein pehle se likha hai; ye script sirf 2-36 nikalta hai
aur file ke aakhir mein Level 1 ki entry barkarar rakhta hai.

Chalane ke liye: python3 tools/generate_solutions.py (repo root se)
"""
import re

SRC = "test/gameplay_test.dart"
DST = "lib/data/levels/solutions.dart"

src = open(SRC).read()
pat = re.compile(r"_playLevel\(tester,\s*(\d+),\s*\[(.*?)\]\);", re.S)
step = re.compile(
    r"\(tap:\s*Vector2\(([\d.]+),\s*([\d.]+)\),\s*type:\s*PieceType\.(\w+)\)"
)
levels = {}
for m in pat.finditer(src):
    lid = int(m.group(1))
    steps = step.findall(m.group(2))
    assert steps, f"level {lid}: no steps"
    levels[lid] = steps

out = []
out.append("// Har level ka hal (solution) — hint system ke liye.")
out.append("// Ye file test/gameplay_test.dart se generate hui hai")
out.append("// (tools/generate_solutions.py) — haath se edit mat karo,")
out.append("// test badle to dobara generate karo. Tap points wahi hain")
out.append("// jo headless playtest mein pass hote hain.")
out.append("import 'package:flame/components.dart';")
out.append("")
out.append("import '../models/piece_type.dart';")
out.append("")
out.append("/// Solution ka ek step — konsa piece, kahan tap kar ke lagana hai.")
out.append("class SolutionStep {")
out.append("  const SolutionStep({required this.tap, required this.type});")
out.append("")
out.append("  /// Tap point (world coords) — BuildManager isi se snap karta hai.")
out.append("  final Vector2 tap;")
out.append("  final PieceType type;")
out.append("}")
out.append("")
out.append("/// Level id -> us ka hal (steps, tarteeb se).")
out.append("final Map<int, List<SolutionStep>> levelSolutions = {")
out.append("  1: [")
out.append("    SolutionStep(tap: Vector2(4.2, 9.3), type: PieceType.road),")
out.append("  ],")
for lid in sorted(levels):
    out.append(f"  {lid}: [")
    for (x, y, t) in levels[lid]:
        out.append(f"    SolutionStep(tap: Vector2({x}, {y}), "
                   f"type: PieceType.{t}),")
    out.append("  ],")
out.append("};")
open(DST, "w").write("\n".join(out) + "\n")
print("levels:", len(levels) + 1, "(+ Level 1 haath se)")
