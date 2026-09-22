#!/usr/bin/env python3
"""Bake PKG-0174 Lena threshold frames onto the 64x104 pivot canvas (32, 96)."""
from __future__ import annotations

from collections import deque
from pathlib import Path

from PIL import Image

ROOT = Path(r"C:\getting_strange\assets\characters\lena")
RAW = ROOT / "raw" / "pkg_0174"
OUT = ROOT
CANVAS_W = 64
CANVAS_H = 104
PIVOT_X = 32
PIVOT_Y = 96
TARGET_H = 87
EDGE_THRESH = 48

MAP = {
    "enter_door_0.jpg": "enter_door_0.png",
    "enter_door_1.jpg": "enter_door_1.png",
    "enter_door_2.jpg": "enter_door_2.png",
    "board_vehicle_0.jpg": "board_vehicle_0.png",
    "board_vehicle_1.jpg": "board_vehicle_1.png",
}


def dist(p: tuple[int, int, int], bg: tuple[int, int, int]) -> int:
    return abs(p[0] - bg[0]) + abs(p[1] - bg[1]) + abs(p[2] - bg[2])


def flood_clear(img: Image.Image) -> Image.Image:
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()
    bg = px[2, 2][:3]
    seen = [[False] * w for _ in range(h)]
    q: deque[tuple[int, int]] = deque()
    for x in range(w):
        q.append((x, 0))
        q.append((x, h - 1))
    for y in range(h):
        q.append((0, y))
        q.append((w - 1, y))
    while q:
        x, y = q.popleft()
        if x < 0 or y < 0 or x >= w or y >= h or seen[y][x]:
            continue
        seen[y][x] = True
        r, g, b, a = px[x, y]
        if a == 0 or dist((r, g, b), bg) > EDGE_THRESH:
            continue
        px[x, y] = (r, g, b, 0)
        q.append((x + 1, y))
        q.append((x - 1, y))
        q.append((x, y + 1))
        q.append((x, y - 1))
    return img


def make_canvas(cropped: Image.Image) -> Image.Image:
    cw, ch = cropped.size
    tw = max(1, round(cw * TARGET_H / ch))
    scaled = cropped.resize((tw, TARGET_H), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
    paste_x = PIVOT_X - tw // 2
    paste_y = PIVOT_Y - TARGET_H
    canvas.paste(scaled, (paste_x, paste_y), scaled)
    return canvas


def process_one(src: Path, dest: Path) -> None:
    img = flood_clear(Image.open(src))
    bbox = img.getbbox()
    if bbox is None:
        raise RuntimeError(f"empty after flood: {src}")
    cropped = img.crop(bbox)
    canvas = make_canvas(cropped)
    dest.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(dest)
    print(f"{src.name} -> {dest.name} {canvas.size} bbox={bbox}")


def main() -> None:
    for raw_name, out_name in MAP.items():
        src = RAW / raw_name
        if not src.exists():
            print("missing", src)
            continue
        process_one(src, OUT / out_name)


if __name__ == "__main__":
    main()
