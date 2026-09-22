#!/usr/bin/env python3
"""Bake PKG-0186 cast frames onto the Lena 4.1 64x104 canvas.

Flood the charcoal identity-plate background, crop, scale with NEAREST
(never LANCZOS), paste onto 64x104 with pivot (32, 96).
"""
from __future__ import annotations

from collections import deque
from pathlib import Path

from PIL import Image

ROOT = Path(r"C:\getting_strange\assets\characters")
CANVAS_W = 64
CANVAS_H = 104
PIVOT_X = 32
PIVOT_Y = 96
BG = (42, 46, 50)
EDGE_THRESH = 48

CHARS = {
    "marta": {
        "target_h": 86,
        "seated_h": 58,
        "files": {
            "idle": "idle.png",
            "talk_0": "talk_0.png",
            "talk_1": "talk_1.png",
            "listen": "listen.png",
            "gesture": "gesture.png",
            "turn_away": "turn_away.png",
            "seated": "seated.png",
        },
    },
    "jakub": {
        "target_h": 89,
        "seated_h": 58,
        "files": {
            "idle": "idle.png",
            "talk_0": "talk_0.png",
            "talk_1": "talk_1.png",
            "listen": "listen.png",
            "gesture": "gesture.png",
            "turn_away": "turn_away.png",
            "work": "work.png",
        },
    },
    "wierzbicka": {
        "target_h": 88,
        "seated_h": 58,
        "files": {
            "idle": "idle.png",
            "talk_0": "talk_0.png",
            "talk_1": "talk_1.png",
            "listen": "listen.png",
            "gesture": "gesture.png",
            "turn_away": "turn_away.png",
            "seated": "seated.png",
        },
    },
    "vendor": {
        "target_h": 86,
        "seated_h": 50,
        "files": {
            "idle": "idle.png",
            "talk_0": "talk_0.png",
            "talk_1": "talk_1.png",
            "listen": "listen.png",
        },
    },
    "neighbour": {
        "target_h": 86,
        "seated_h": 58,
        "files": {
            "idle": "idle.png",
            "talk_0": "talk_0.png",
            "talk_1": "talk_1.png",
            "listen": "listen.png",
            "gesture": "gesture.png",
        },
    },
}


def dist(p: tuple[int, int, int]) -> int:
    return abs(p[0] - BG[0]) + abs(p[1] - BG[1]) + abs(p[2] - BG[2])


def flood_clear(img: Image.Image) -> Image.Image:
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()
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
        if a == 0 or dist((r, g, b)) > EDGE_THRESH:
            continue
        px[x, y] = (r, g, b, 0)
        q.append((x + 1, y))
        q.append((x - 1, y))
        q.append((x, y + 1))
        q.append((x, y - 1))
    return img


def paste_canvas(cropped: Image.Image, target_h: int) -> Image.Image:
    cw, ch = cropped.size
    tw = max(1, round(cw * target_h / ch))
    tw = min(tw, CANVAS_W)
    scaled = cropped.resize((tw, target_h), Image.Resampling.NEAREST)
    canvas = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
    paste_x = PIVOT_X - tw // 2
    paste_y = PIVOT_Y - target_h
    canvas.paste(scaled, (paste_x, paste_y), scaled)
    return canvas


def process_one(src: Path, dest: Path, target_h: int) -> None:
    img = flood_clear(Image.open(src))
    bbox = img.getbbox()
    if bbox is None:
        raise RuntimeError(f"empty after flood: {src}")
    cropped = img.crop(bbox)
    canvas = paste_canvas(cropped, target_h)
    dest.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(dest)
    vis = canvas.getbbox()
    vis_h = (vis[3] - vis[1]) if vis else 0
    print(f"{src.name} -> {dest} {canvas.size} vis_h={vis_h}")


def main() -> None:
    for char_id, cfg in CHARS.items():
        raw = ROOT / char_id / "raw" / "pkg_0186"
        out = ROOT / char_id
        for stem, out_name in cfg["files"].items():
            src = raw / f"{stem}.png"
            if not src.exists():
                src_jpg = raw / f"{stem}.jpg"
                src = src_jpg if src_jpg.exists() else src
            if not src.exists():
                print("missing", src)
                continue
            height = cfg["seated_h"] if stem == "seated" else cfg["target_h"]
            process_one(src, out / out_name, height)


if __name__ == "__main__":
    main()
