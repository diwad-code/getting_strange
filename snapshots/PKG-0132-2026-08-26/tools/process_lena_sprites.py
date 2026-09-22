#!/usr/bin/env python3
"""Crop generated Lena frames to 87px standing height with edge flood-fill."""
from __future__ import annotations

from collections import deque
from pathlib import Path

from PIL import Image

ROOT = Path(r"C:\getting_strange\assets\characters\lena")
RAW = ROOT / "raw"
TARGET_H = 87
BG = (42, 46, 50)
EDGE_THRESH = 38

MAP = {
    "5639cc4c-7e10-41da-ad32-8e69c538a007.png": "idle.png",
    "269c4db3-4d69-4b57-8cd4-0a430d974f57.png": "walk_0.png",
    "8445d31c-31cd-4542-96cc-a1151bf8d7f7.png": "walk_1.png",
    "3e713ffc-b0cb-4ce8-b9c6-e1f4bb0c703a.png": "walk_2.png",
    "9b091b5e-0351-405b-bb23-f07a1a962e5e.png": "walk_3.png",
    "46437334-c377-4972-963e-da6b56359d5f.png": "walk_4.png",
    "c42cfb50-ec66-41b2-b98d-7879a4d2ebf9.png": "run_0.png",
    "3f3a139b-9f4b-45fe-93c3-13b21ddbc49c.png": "run_1.png",
    "e4ed15e8-8dd2-4961-8d55-59fa800b3163.png": "run_2.png",
    "a98316a3-c822-4aea-bf10-eb2fd4533b9f.png": "run_3.png",
    "6866ef5a-cb1b-4b76-aad9-b68ef9fc7223.png": "jump_rise.png",
    "a3891791-c927-4871-8d3c-bdbe80e0a58c.png": "climb.png",
    "6d61c9dd-790a-47b2-9bdf-9f05ea26cbb1.png": "jump_fall.png",
    "a800947e-7900-4ebb-a6f3-9ae32f2ff523.png": "land.png",
    "711d3ded-a500-4535-8464-da17ffe35202.png": "interact.png",
    "45bd5b5d-e6e8-44bf-a2b1-96d3cadc95b0.png": "examine.png",
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


def process_one(src: Path, dest: Path) -> None:
    img = flood_clear(Image.open(src))
    bbox = img.getbbox()
    if bbox is None:
        raise RuntimeError(f"empty after flood: {src}")
    cropped = img.crop(bbox)
    cw, ch = cropped.size
    tw = max(1, round(cw * TARGET_H / ch))
    scaled = cropped.resize((tw, TARGET_H), Image.Resampling.LANCZOS)
    dest.parent.mkdir(parents=True, exist_ok=True)
    scaled.save(dest)
    print(f"{src.name} -> {dest.name} {scaled.size}")


def main() -> None:
    for raw_name, out_name in MAP.items():
        src = RAW / raw_name
        if not src.exists():
            print("missing", src)
            continue
        process_one(src, ROOT / out_name)


if __name__ == "__main__":
    main()
