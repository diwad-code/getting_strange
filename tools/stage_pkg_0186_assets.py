#!/usr/bin/env python3
"""Stage PKG-0186 identity plates into raw/, backup PKG-0172 sprites, bake portraits."""
from __future__ import annotations

import shutil
from pathlib import Path

from PIL import Image

from process_cast_sprites import flood_clear, process_one, CHARS, ROOT

IMG = Path(r"C:\Users\admin\.grok\sessions\C%3A%5Cgetting_strange\01a06be4-02f8-7440-aa45-ae987d9a053f\images")
BACKUP_NAME = "pkg_0172_backup"

SPRITE_MAP = {
    "marta": {
        "idle": "32.jpg",
        "talk_0": "48.jpg",
        "talk_1": "50.jpg",
        "listen": "43.jpg",
        "gesture": "49.jpg",
        "turn_away": "44.jpg",
        "seated": "45.jpg",
    },
    "jakub": {
        "idle": "31.jpg",
        "talk_0": "41.jpg",
        "talk_1": "37.jpg",
        "listen": "35.jpg",
        "gesture": "40.jpg",
        "turn_away": "42.jpg",
        "work": "39.jpg",
    },
    "wierzbicka": {
        "idle": "6.jpg",
        "talk_0": "53.jpg",
        "talk_1": "60.jpg",
        "listen": "55.jpg",
        "gesture": "54.jpg",
        "turn_away": "56.jpg",
        "seated": "51.jpg",
    },
    "vendor": {
        "idle": "38.jpg",
        "talk_0": "57.jpg",
        "talk_1": "57.jpg",
        "listen": "58.jpg",
    },
    "neighbour": {
        "idle": "36.jpg",
        "talk_0": "62.jpg",
        "talk_1": "62.jpg",
        "listen": "61.jpg",
        "gesture": "59.jpg",
    },
}

PORTRAIT_MAP = {
    "marta": "47.jpg",
    "jakub": "52.jpg",
    "wierzbicka": "18.jpg",
    "szymon": "14.jpg",
}


def jpg_to_png(src: Path, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    Image.open(src).convert("RGBA").save(dest)


def backup_existing(char_id: str) -> None:
    src_dir = ROOT / char_id
    dst = src_dir / "raw" / BACKUP_NAME
    dst.mkdir(parents=True, exist_ok=True)
    for png in src_dir.glob("*.png"):
        shutil.copy2(png, dst / png.name)
        print(f"backup {png.name} -> {dst}")


def bake_portrait(src: Path, dest: Path) -> None:
    img = flood_clear(Image.open(src))
    bbox = img.getbbox()
    if bbox is None:
        raise RuntimeError(f"empty portrait {src}")
    cropped = img.crop(bbox)
    side = 1024
    canvas = Image.new("RGBA", (side, side), (0, 0, 0, 0))
    cw, ch = cropped.size
    scale = min(side / cw, side / ch) * 0.92
    tw = max(1, int(cw * scale))
    th = max(1, int(ch * scale))
    scaled = cropped.resize((tw, th), Image.Resampling.NEAREST)
    canvas.paste(scaled, ((side - tw) // 2, (side - th) // 2), scaled)
    dest.parent.mkdir(parents=True, exist_ok=True)
    canvas.save(dest)
    print(f"portrait {src.name} -> {dest} {canvas.size}")


def main() -> None:
    for char_id, files in SPRITE_MAP.items():
        if char_id in ("marta", "jakub", "wierzbicka"):
            backup_existing(char_id)
        raw = ROOT / char_id / "raw" / "pkg_0186"
        raw.mkdir(parents=True, exist_ok=True)
        ignore = ROOT / char_id / "raw" / ".gdignore"
        if not ignore.exists():
            ignore.write_text("\n", encoding="utf-8")
        identity_copied = False
        for stem, name in files.items():
            src = IMG / name
            if not src.exists():
                raise FileNotFoundError(src)
            dest = raw / f"{stem}.png"
            jpg_to_png(src, dest)
            if stem == "idle":
                jpg_to_png(src, raw / "identity.png")
                identity_copied = True
            print(f"stage {char_id}/{stem} from {name}")
        if not identity_copied:
            print("no idle for", char_id)

    por_raw = ROOT / "portraits" / "raw" / "pkg_0186"
    por_raw.mkdir(parents=True, exist_ok=True)
    por_backup = ROOT / "portraits" / "raw" / BACKUP_NAME
    por_backup.mkdir(parents=True, exist_ok=True)
    for name in PORTRAIT_MAP:
        old = ROOT / "portraits" / f"{name}.png"
        if old.exists():
            shutil.copy2(old, por_backup / f"{name}.png")
        src = IMG / PORTRAIT_MAP[name]
        staged = por_raw / f"{name}.png"
        jpg_to_png(src, staged)
        bake_portrait(staged, ROOT / "portraits" / f"{name}.png")


if __name__ == "__main__":
    main()
