#!/usr/bin/env python3
"""PKG-0185 contact sheets: portraits, idle sprites, NPC state collapse."""
from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

ROOT = Path(r"C:\getting_strange")
OUT = ROOT / "reports" / "pkg_0185" / "visual"
OUT.mkdir(parents=True, exist_ok=True)

INK = (18, 24, 28, 255)
PAPER = (214, 224, 227, 255)
AMBER = (211, 154, 98, 255)
MUTED = (120, 138, 146, 255)


def font(size: int) -> ImageFont.ImageFont:
    for candidate in (
        r"C:\Windows\Fonts\consola.ttf",
        r"C:\Windows\Fonts\arial.ttf",
    ):
        path = Path(candidate)
        if path.exists():
            return ImageFont.truetype(str(path), size)
    return ImageFont.load_default()


def load_rgba(path: Path) -> Image.Image:
    return Image.open(path).convert("RGBA")


def nearest(img: Image.Image, scale: int) -> Image.Image:
    w, h = img.size
    return img.resize((w * scale, h * scale), Image.Resampling.NEAREST)


def paste_centered(canvas: Image.Image, src: Image.Image, box: tuple[int, int, int, int]) -> None:
    x0, y0, x1, y1 = box
    bw, bh = x1 - x0, y1 - y0
    fitted = src.copy()
    fw, fh = fitted.size
    scale = min(bw / fw, bh / fh)
    nw, nh = max(1, int(fw * scale)), max(1, int(fh * scale))
    fitted = fitted.resize((nw, nh), Image.Resampling.NEAREST)
    px = x0 + (bw - nw) // 2
    py = y0 + (bh - nh) // 2
    canvas.alpha_composite(fitted, (px, py))


def label(draw: ImageDraw.ImageDraw, text: str, xy: tuple[int, int], fill=PAPER, size: int = 14) -> None:
    draw.text(xy, text, font=font(size), fill=fill)


def portraits_sheet() -> None:
    names = ["lena", "marta", "jakub", "wierzbicka", "szymon"]
    cell = 220
    margin = 24
    header = 48
    w = margin * 2 + cell * 5 + 16 * 4
    h = header + cell + 36 + margin
    canvas = Image.new("RGBA", (w, h), INK)
    draw = ImageDraw.Draw(canvas)
    label(draw, "PKG-0185  PORTRETY CRT  1024x1024  (kanon: styl Leny)", (margin, 14), AMBER, 18)
    for i, name in enumerate(names):
        path = ROOT / "assets" / "characters" / "portraits" / f"{name}.png"
        x = margin + i * (cell + 16)
        y = header
        draw.rectangle([x - 2, y - 2, x + cell + 1, y + cell + 1], outline=MUTED, width=1)
        if path.exists():
            paste_centered(canvas, load_rgba(path), (x, y, x + cell, y + cell))
        label(draw, name.upper(), (x, y + cell + 8), PAPER, 13)
    canvas.save(OUT / "contact_portraits.png")
    print("wrote", OUT / "contact_portraits.png")


def idle_sheet() -> None:
    entries = [
        ("lena", ROOT / "assets" / "characters" / "lena" / "idle.png"),
        ("marta", ROOT / "assets" / "characters" / "marta" / "idle.png"),
        ("jakub", ROOT / "assets" / "characters" / "jakub" / "idle.png"),
        ("wierzbicka", ROOT / "assets" / "characters" / "wierzbicka" / "idle.png"),
    ]
    scale = 4
    cell_w, cell_h = 64 * scale, 104 * scale
    margin = 24
    header = 48
    w = margin * 2 + (cell_w + 24) * 4 - 24
    h = header + cell_h + 40 + margin
    canvas = Image.new("RGBA", (w, h), INK)
    draw = ImageDraw.Draw(canvas)
    label(draw, "PKG-0185  SPRITE IDLE  64x104 x4 NEAREST  (kanon: Lena 4.1)", (margin, 14), AMBER, 18)
    for i, (name, path) in enumerate(entries):
        x = margin + i * (cell_w + 24)
        y = header
        draw.rectangle([x - 2, y - 2, x + cell_w + 1, y + cell_h + 1], outline=MUTED, width=1)
        if path.exists():
            canvas.alpha_composite(nearest(load_rgba(path), scale), (x, y))
        label(draw, name.upper(), (x, y + cell_h + 8), PAPER, 13)
    canvas.save(OUT / "contact_sprites_idle.png")
    print("wrote", OUT / "contact_sprites_idle.png")


def npc_states_sheet() -> None:
    chars = ["marta", "jakub", "wierzbicka"]
    states = ["idle", "talk_0", "talk_1", "listen", "gesture", "turn_away", "seated", "work"]
    scale = 3
    cell_w, cell_h = 64 * scale, 104 * scale
    margin = 24
    header = 56
    row_label = 28
    w = margin + 90 + (cell_w + 8) * len(states) + margin
    h = header + (cell_h + row_label) * len(chars) + margin
    canvas = Image.new("RGBA", (w, h), INK)
    draw = ImageDraw.Draw(canvas)
    label(
        draw,
        "PKG-0185  STANY NPC  — 7 stanow z 1 JPEG (process_npc_sprites.py)",
        (margin, 12),
        AMBER,
        18,
    )
    label(draw, "talk/listen/gesture/work sa przesunieciem glowy, nie nowa poza", (margin, 32), MUTED, 12)
    for r, char in enumerate(chars):
        y = header + r * (cell_h + row_label)
        label(draw, char.upper(), (margin, y + cell_h // 2 - 8), PAPER, 14)
        for c, state in enumerate(states):
            path = ROOT / "assets" / "characters" / char / f"{state}.png"
            x = margin + 90 + c * (cell_w + 8)
            draw.rectangle([x - 1, y - 1, x + cell_w, y + cell_h], outline=MUTED, width=1)
            if path.exists():
                canvas.alpha_composite(nearest(load_rgba(path), scale), (x, y))
            if r == 0:
                label(draw, state, (x, y + cell_h + 4), MUTED, 10)
    canvas.save(OUT / "contact_npc_states.png")
    print("wrote", OUT / "contact_npc_states.png")


def lena_vs_cast_sheet() -> None:
    pairs = [
        ("LENA sprite", ROOT / "assets" / "characters" / "lena" / "idle.png", 5),
        ("MARTA sprite", ROOT / "assets" / "characters" / "marta" / "idle.png", 5),
        ("LENA portret", ROOT / "assets" / "characters" / "portraits" / "lena.png", 1),
        ("MARTA portret", ROOT / "assets" / "characters" / "portraits" / "marta.png", 1),
        ("JAKUB sprite", ROOT / "assets" / "characters" / "jakub" / "idle.png", 5),
        ("JAKUB portret", ROOT / "assets" / "characters" / "portraits" / "jakub.png", 1),
        ("WIERZBICKA sprite", ROOT / "assets" / "characters" / "wierzbicka" / "idle.png", 5),
        ("WIERZBICKA portret", ROOT / "assets" / "characters" / "portraits" / "wierzbicka.png", 1),
    ]
    cell = 200
    cols = 4
    margin = 24
    header = 56
    rows = 2
    w = margin * 2 + (cell + 16) * cols - 16
    h = header + (cell + 36) * rows + margin
    canvas = Image.new("RGBA", (w, h), INK)
    draw = ImageDraw.Draw(canvas)
    label(draw, "PKG-0185  LENA = KANON  vs  OBSADA  (sprite i portret tej samej osoby)", (margin, 12), AMBER, 18)
    label(draw, "Defekt: Marta/Jakub/Wierzbicka nie naleza do jezyka Pixel-Stage Leny 4.1", (margin, 34), MUTED, 12)
    for i, (title, path, _scale) in enumerate(pairs):
        c = i % cols
        r = i // cols
        x = margin + c * (cell + 16)
        y = header + r * (cell + 36)
        draw.rectangle([x - 2, y - 2, x + cell + 1, y + cell + 1], outline=MUTED, width=1)
        if path.exists():
            paste_centered(canvas, load_rgba(path), (x, y, x + cell, y + cell))
        label(draw, title, (x, y + cell + 8), PAPER, 12)
    canvas.save(OUT / "contact_lena_vs_cast.png")
    print("wrote", OUT / "contact_lena_vs_cast.png")


def crt_scale_sheet() -> None:
    """Show portraits at the actual CRT bust size (56x62) vs source language."""
    names = ["lena", "marta", "jakub", "wierzbicka", "szymon"]
    bust = (56 * 4, 62 * 4)
    margin = 24
    header = 48
    w = margin * 2 + (bust[0] + 20) * 5 - 20
    h = header + bust[1] + 40 + margin
    canvas = Image.new("RGBA", (w, h), INK)
    draw = ImageDraw.Draw(canvas)
    label(draw, "PKG-0185  PORTRET W ROZMIARZE CRT  56x62 x4  (jak w panelu dialogu)", (margin, 14), AMBER, 18)
    for i, name in enumerate(names):
        path = ROOT / "assets" / "characters" / "portraits" / f"{name}.png"
        x = margin + i * (bust[0] + 20)
        y = header
        draw.rectangle([x - 2, y - 2, x + bust[0] + 1, y + bust[1] + 1], outline=AMBER if name == "lena" else MUTED, width=1)
        if path.exists():
            src = load_rgba(path)
            small = src.resize((56, 62), Image.Resampling.NEAREST)
            canvas.alpha_composite(nearest(small, 4), (x, y))
        label(draw, name.upper(), (x, y + bust[1] + 8), PAPER, 13)
    canvas.save(OUT / "contact_portraits_crt_scale.png")
    print("wrote", OUT / "contact_portraits_crt_scale.png")


def main() -> None:
    portraits_sheet()
    idle_sheet()
    npc_states_sheet()
    lena_vs_cast_sheet()
    crt_scale_sheet()


if __name__ == "__main__":
    main()
