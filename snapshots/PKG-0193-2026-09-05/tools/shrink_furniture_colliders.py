#!/usr/bin/env python3
"""Shrink giant furniture colliders to WORLD_SCALE. Doors stay barriers."""
from __future__ import annotations

import re
from pathlib import Path

LEVELS = Path(r"C:\getting_strange\scenes\levels")
TABLE_H = 39.0
CHAIR_H = 23.0
FURNITURE = ("desk", "bench", "table", "chair", "counter", "console", "stool")


def parse_vec2(s: str) -> tuple[float, float] | None:
    m = re.search(r"Vector2\(\s*([-\d.]+)\s*,\s*([-\d.]+)\s*\)", s)
    if not m:
        return None
    return float(m.group(1)), float(m.group(2))


def process(path: Path) -> list[str]:
    text = path.read_text(encoding="utf-8")
    lines = text.splitlines(keepends=True)
    notes: list[str] = []

    shapes: dict[str, tuple[float, float]] = {}
    current_id = ""
    for line in lines:
        stripped = line.strip()
        if stripped.startswith("[sub_resource") and "RectangleShape2D" in stripped:
            m = re.search(r'id="([^"]+)"', stripped)
            current_id = m.group(1) if m else ""
        elif current_id and stripped.startswith("size = Vector2("):
            vec = parse_vec2(stripped)
            if vec:
                shapes[current_id] = vec
        elif stripped.startswith("[node") or stripped.startswith("[ext_resource"):
            current_id = ""

    floor_top = 296.0
    nodes: list[dict] = []
    current: dict | None = None
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("[node "):
            if current:
                nodes.append(current)
            name_m = re.search(r'name="([^"]+)"', stripped)
            type_m = re.search(r'type="([^"]+)"', stripped)
            parent_m = re.search(r'parent="([^"]+)"', stripped)
            current = {
                "line": i,
                "name": name_m.group(1) if name_m else "",
                "type": type_m.group(1) if type_m else "",
                "parent": parent_m.group(1) if parent_m else "",
                "pos_line": None,
                "pos": None,
                "shape_id": None,
            }
        elif current is not None:
            if stripped.startswith("position = Vector2("):
                current["pos_line"] = i
                current["pos"] = parse_vec2(stripped)
            elif stripped.startswith("shape = SubResource("):
                m = re.search(r'SubResource\("([^"]+)"\)', stripped)
                if m:
                    current["shape_id"] = m.group(1)
    if current:
        nodes.append(current)

    bodies: dict[str, dict] = {}
    for n in nodes:
        key = n["parent"] + "/" + n["name"] if n["parent"] else n["name"]
        bodies[key] = n

    for n in nodes:
        if n["type"] != "CollisionShape2D" and n["name"] != "CollisionShape2D":
            continue
        parent = bodies.get(n["parent"])
        if parent is None:
            continue
        if n["shape_id"]:
            parent["shape_id"] = n["shape_id"]

    for n in nodes:
        if n["name"] in ("Floor", "FloorMain") and n["pos"] and n["shape_id"] in shapes:
            body_y = n["pos"][1]
            sh = shapes[n["shape_id"]][1]
            floor_top = body_y - sh * 0.5

    shape_new: dict[str, tuple[float, float]] = {}
    pos_new: dict[int, tuple[float, float]] = {}

    for n in nodes:
        lname = n["name"].lower()
        if n["type"] == "CollisionShape2D" or n["name"] == "CollisionShape2D":
            continue
        if not any(token in lname for token in FURNITURE):
            continue
        if n["shape_id"] not in shapes or n["pos"] is None or n["pos_line"] is None:
            continue
        w, h = shapes[n["shape_id"]]
        if h <= TABLE_H + 1.0:
            continue
        target_h = CHAIR_H if "chair" in lname or "stool" in lname else TABLE_H
        bottom = n["pos"][1] + h * 0.5
        new_bottom = min(bottom, floor_top)
        new_y = new_bottom - target_h * 0.5
        shape_new[n["shape_id"]] = (w, target_h)
        pos_new[n["pos_line"]] = (n["pos"][0], new_y)
        notes.append(
            f"{path.name}:{n['name']} h {h:.1f}->{target_h:.1f} y {n['pos'][1]:.1f}->{new_y:.1f}"
        )

    if not notes:
        return notes

    out: list[str] = []
    current_id = ""
    for i, line in enumerate(lines):
        stripped = line.strip()
        if stripped.startswith("[sub_resource") and "RectangleShape2D" in stripped:
            m = re.search(r'id="([^"]+)"', stripped)
            current_id = m.group(1) if m else ""
            out.append(line)
            continue
        if current_id and stripped.startswith("size = Vector2(") and current_id in shape_new:
            w, h = shape_new[current_id]
            indent = line[: len(line) - len(line.lstrip())]
            out.append(f"{indent}size = Vector2({w:g}, {h:g})\n")
            current_id = ""
            continue
        if i in pos_new:
            x, y = pos_new[i]
            indent = line[: len(line) - len(line.lstrip())]
            out.append(f"{indent}position = Vector2({x:g}, {y:g})\n")
            continue
        if stripped.startswith("[node") or stripped.startswith("[ext_resource"):
            current_id = ""
        out.append(line)
    path.write_text("".join(out), encoding="utf-8", newline="\n")
    return notes


def main() -> None:
    changed = 0
    for tscn in sorted(LEVELS.glob("station_*.tscn")):
        notes = process(tscn)
        if notes:
            changed += 1
            for n in notes:
                print(n)
    print(f"stations_touched={changed}")


if __name__ == "__main__":
    main()
