#!/usr/bin/env python3
"""Hint solutions generate karo — gameplay test files se.

Level 1 ka hal alag test mein hai (road lagao, GO, gas) — wo haath se
solutions.dart mein pehle se likha hai; ye script baaki levels nikalta hai.

Patterns (har world test file ka apna harness hai):
- A: _playLevel(tester, N, [...]) — gameplay_test.dart, world6, world8.
- B: level = levelById(N)!; ... _play(tester, level, [...]) — world5, world7.
- C: _play(tester, levelNN, [...]) / _playScripted(tester, levelNN, [...])
  — world4 (level variable ka naam id deta hai).
Khaali placements ([]) matlab level bina piece lagaye pass hota hai —
solution khaali rehti hai (hint kuch nahi dikhata).

Chalane ke liye: python3 tools/generate_solutions.py (repo root se)
"""
import re

FILES = [
    "test/gameplay_test.dart",
    "test/gameplay_world4_test.dart",
    "test/gameplay_world5_test.dart",
    "test/gameplay_world6_test.dart",
    "test/gameplay_world7_test.dart",
    "test/gameplay_world8_test.dart",
]
DST = "lib/data/levels/solutions.dart"

step = re.compile(
    r"\(tap:\s*Vector2\(([\d.]+),\s*([\d.]+)\),\s*type:\s*PieceType\.(\w+)\)"
)
# Pattern A: _playLevel(tester, N, [...])
pat_a = re.compile(r"_playLevel\(tester,\s*(\d+),\s*\[(.*?)\]\);", re.S)
# Pattern C: _play/_playScripted(tester, levelNN, [...])
pat_c = re.compile(
    r"_play(?:Scripted)?\(tester,\s*level(\d+),\s*\[(.*?)\]", re.S
)
# Pattern B: levelById(N) phir _play(tester, level, [...])
pat_b_id = re.compile(r"levelById\((\d+)\)")
pat_b_play = re.compile(r"_play\(tester,\s*level,\s*\[(.*?)\]", re.S)

levels = {}
for fname in FILES:
    src = open(fname).read()
    for m in pat_a.finditer(src):
        lid = int(m.group(1))
        steps = step.findall(m.group(2))
        # Khaali placements theek hain (bina piece ke pass).
        assert lid not in levels, f"level {lid} do dafa ({fname})"
        levels[lid] = steps
    for m in pat_c.finditer(src):
        lid = int(m.group(1))
        steps = step.findall(m.group(2))
        # Khaali placements theek hain (bina piece ke pass).
        assert lid not in levels, f"level {lid} do dafa ({fname})"
        levels[lid] = steps
    # Pattern B: har _play ko us se pehle wale levelById se jodo.
    id_positions = [(m.start(), int(m.group(1))) for m in pat_b_id.finditer(src)]
    for m in pat_b_play.finditer(src):
        prev = [lid for pos, lid in id_positions if pos < m.start()]
        assert prev, f"{fname}: _play ka levelById nahi mila"
        lid = prev[-1]
        steps = step.findall(m.group(1))
        assert lid not in levels, f"level {lid} do dafa ({fname})"
        levels[lid] = steps

missing = [i for i in range(2, 97) if i not in levels]
assert not missing, f"levels missing: {missing}"

out = []
out.append("// Har level ka hal (solution) — hint system ke liye.")
out.append("// Ye file gameplay test files se generate hui hai")
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
out.append("/// Khaali list matlab level bina piece lagaye pass hota hai.")
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
empty = [lid for lid in sorted(levels) if not levels[lid]]
print("khaali solutions (bina piece ke pass):", empty)
