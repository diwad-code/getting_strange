#!/usr/bin/env python3
from __future__ import annotations

import re
from pathlib import Path

p = Path(r"C:\getting_strange\tests\smoke_test.gd")
t = p.read_text(encoding="utf-8")
t = t.replace('\\"', '"')

pat = re.compile(
    r"\tvar player := station.get_node_or_null\(\"Player\"\) as PrototypePlayer\n"
    r"\tif player:\n"
    r"\t\tplayer\.global_position = Vector2\([0-9.]+, [0-9.]+\)\n"
    r"\t\tawait physics_frame\n"
    r"\t\tawait physics_frame\n"
    r"\t_expect\(station\.is_level_completed, \"([^\"]+)\"\)"
)
t, n = pat.subn(
    r"\tawait _cross_exit(station)\n\t_expect(station.is_level_completed, \"\1\")",
    t,
)
print("generic replacements", n)

pat2 = re.compile(
    r"\tvar player := station.get_node_or_null\(\"Player\"\) as PrototypePlayer\n"
    r"\tif player:\n"
    r"\t\tplayer\.global_position = Vector2\([0-9.]+, [0-9.]+\)\n"
    r"\t\tfor f in range\(\d+\):\n"
    r"\t\t\tawait physics_frame\n"
    r"\t_expect\(station\.is_level_completed, \"([^\"]+)\"\)"
)
t, n2 = pat2.subn(
    r"\tawait _cross_exit(station)\n\t_expect(station.is_level_completed, \"\1\")",
    t,
)
print("loop replacements", n2)

pat3 = re.compile(
    r"\tplayer\.global_position = Vector2\((?:606|610)\.0, (?:238|245)\.0\)\n"
    r"\tfor f in range\(5\):\n"
    r"\t\tawait physics_frame\n\n"
    r"\t_expect\(station\.is_level_completed, \"(station 42[abc] completed upon entering airlock|station 43 completed upon entering airlock)\"\)"
)
t, n3 = pat3.subn(
    r"\tawait _cross_exit(station)\n\t_expect(station.is_level_completed, \"\1\")",
    t,
)
print("finale replacements", n3)

p.write_text(t, encoding="utf-8")
print("wrote", p)
