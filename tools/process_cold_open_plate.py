#!/usr/bin/env python3
"""Bake the PKG-0176 cold open shot 2 plate from its gen-ai source.

`COLD_OPEN_SPEC.md` §3 (ujecie 2) asks for a close shot of the rail: the
clamped sensor, the cable and Lena's gloved hands on the mount, with her face
still out of frame. Lena is a gen-ai character (D-186, `CAST_AND_NPC_BIBLE.md`);
her anatomy may never be extended with engine primitives. The plate therefore
comes from the same pipeline as every other Lena frame:

    reference frame  ->  gen-ai character (ideogram-character)  ->  this script

Source prompt: `assets/characters/lena/raw/pkg_0176/prompt_cold_open_crouch.txt`
Reference:     `assets/characters/lena/raw/pkg_0173/step_up_0.jpg`

What this script does, and nothing else:

1. Crops a 16:9 window that starts BELOW her chin, so the shot keeps shoulders,
   arms, gloves and the mount, and drops the face. That is a framing decision,
   not a repaint.
2. Replaces the generator's flat backdrop with the stage ink from
   `VectorStageStyle.INK`, blending the anti-aliased rim so no halo survives.
3. Resizes to the logical frame 640x360.

Run: py tools/process_cold_open_plate.py
"""
from __future__ import annotations

from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parent.parent
SOURCE = ROOT / "assets" / "characters" / "lena" / "raw" / "pkg_0176" / "ccc20a7e-0ca8-4016-9c09-1c044614d50d.png"
OUTPUT = ROOT / "assets" / "cold_open" / "shot2_rail_hands.png"

## Gorna krawedz kadru siedzi ponizej brody: twarz zostaje poza ujeciem.
CROP_TOP = 560
FRAME = (640, 360)
## Plaskie tlo generatora i tusz sceny (`VectorStageStyle.INK`).
BACKDROP = (54, 55, 72)
INK = (11, 16, 22)
## Ponizej `SOLID_DIST` piksel jest tlem, powyzej `EDGE_DIST` nalezy do rysunku.
SOLID_DIST = 14
EDGE_DIST = 40


def channel_distance(pixel: tuple[int, int, int], reference: tuple[int, int, int]) -> int:
    return sum(abs(a - b) for a, b in zip(pixel, reference))


def replace_backdrop(image: Image.Image) -> Image.Image:
    image = image.convert("RGB")
    width, height = image.size
    pixels = image.load()
    for y in range(height):
        for x in range(width):
            pixel = pixels[x, y]
            distance = channel_distance(pixel, BACKDROP)
            if distance <= SOLID_DIST:
                pixels[x, y] = INK
                continue
            if distance >= EDGE_DIST:
                continue
            weight = (distance - SOLID_DIST) / float(EDGE_DIST - SOLID_DIST)
            pixels[x, y] = tuple(
                int(round(INK[i] * (1.0 - weight) + pixel[i] * weight)) for i in range(3)
            )
    return image


def main() -> None:
    if not SOURCE.exists():
        raise SystemExit("missing gen-ai source: %s" % SOURCE)
    source = Image.open(SOURCE).convert("RGB")
    width, height = source.size
    window_height = int(round(width * FRAME[1] / FRAME[0]))
    bottom = min(height, CROP_TOP + window_height)
    plate = source.crop((0, CROP_TOP, width, bottom))
    plate = replace_backdrop(plate)
    plate = plate.resize(FRAME, Image.LANCZOS)
    OUTPUT.parent.mkdir(parents=True, exist_ok=True)
    plate.save(OUTPUT)
    print("wrote %s %s" % (OUTPUT, plate.size))


if __name__ == "__main__":
    main()
