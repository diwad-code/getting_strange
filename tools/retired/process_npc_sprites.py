#!/usr/bin/env python3
"""Process and normalize NPC sprites to the 64x104 canvas with pivot (32, 96).

Matches the LenaVisualRig contract:
- Canvas: 64x104 px
- Pivot: (32, 96) -> foot at y=96, center at x=32
- Target heights: Marta: 86px, Jakub: 89px, Wierzbicka: 88px (all within 84-92px canon)
- Generates 7 presentation states (9 files):
  idle.png, talk_0.png, talk_1.png, listen.png, gesture.png, turn_away.png, seated.png, work.png
"""
from __future__ import annotations

from collections import deque
from pathlib import Path
from PIL import Image

CHARS = {
    "marta": {
        "raw": Path(r"C:\getting_strange\assets\characters\marta\raw\cdf1c0d4-96ee-42bf-a4a6-659eb29dc70f.jpeg"),
        "out_dir": Path(r"C:\getting_strange\assets\characters\marta"),
        "target_h": 86,
    },
    "jakub": {
        "raw": Path(r"C:\getting_strange\assets\characters\jakub\raw\40365fc3-dcfa-4186-b3c8-69990741a739.jpeg"),
        "out_dir": Path(r"C:\getting_strange\assets\characters\jakub"),
        "target_h": 89,
    },
    "wierzbicka": {
        "raw": Path(r"C:\getting_strange\assets\characters\wierzbicka\raw\7d5423b5-5331-4a42-a462-be69f8776b48.jpeg"),
        "out_dir": Path(r"C:\getting_strange\assets\characters\wierzbicka"),
        "target_h": 88,
    },
}

CANVAS_W = 64
CANVAS_H = 104
PIVOT_X = 32
PIVOT_Y = 96


def flood_clear_black(img: Image.Image) -> Image.Image:
    img = img.convert("RGBA")
    w, h = img.size
    px = img.load()
    seen = [[False] * w for _ in range(h)]
    q: deque[tuple[int, int]] = deque([
        (0, 0), (w - 1, 0), (0, h - 1), (w - 1, h - 1),
        (w // 2, 0), (w // 2, h - 1), (0, h // 2), (w - 1, h // 2)
    ])
    while q:
        x, y = q.popleft()
        if x < 0 or y < 0 or x >= w or y >= h or seen[y][x]:
            continue
        seen[y][x] = True
        r, g, b, a = px[x, y]
        if a == 0 or (r < 22 and g < 22 and b < 22):
            px[x, y] = (0, 0, 0, 0)
            q.append((x + 1, y))
            q.append((x - 1, y))
            q.append((x, y + 1))
            q.append((x, y - 1))
    return img


def clean_islands(img: Image.Image) -> Image.Image:
    w, h = img.size
    px = img.load()
    for y in range(h):
        for x in range(w):
            r, g, b, a = px[x, y]
            if a > 0 and r < 16 and g < 16 and b < 16:
                px[x, y] = (0, 0, 0, 0)
    return img


def make_canvas(cropped: Image.Image, target_h: int) -> Image.Image:
    cw, ch = cropped.size
    tw = max(1, round(cw * target_h / ch))
    scaled = cropped.resize((tw, target_h), Image.Resampling.LANCZOS)
    canvas = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
    paste_x = PIVOT_X - tw // 2
    paste_y = PIVOT_Y - target_h
    canvas.paste(scaled, (paste_x, paste_y), scaled)
    return canvas


def generate_states(base_cropped: Image.Image, target_h: int) -> dict[str, Image.Image]:
    cw, ch = base_cropped.size
    states: dict[str, Image.Image] = {}

    # 1. idle: base standing pose
    states["idle"] = make_canvas(base_cropped, target_h)

    # 2. talk_0: slight head nod / posture forward
    talk0_crop = base_cropped.copy()
    head_h = int(ch * 0.28)
    head = talk0_crop.crop((0, 0, cw, head_h))
    talk0_crop.paste((0, 0, 0, 0), (0, 0, cw, head_h))
    talk0_crop.paste(head, (1, 1), head)
    states["talk_0"] = make_canvas(talk0_crop, target_h)

    # 3. talk_1: slight mouth open / head up
    talk1_crop = base_cropped.copy()
    head = talk1_crop.crop((0, 0, cw, head_h))
    talk1_crop.paste((0, 0, 0, 0), (0, 0, cw, head_h))
    talk1_crop.paste(head, (0, -1), head)
    states["talk_1"] = make_canvas(talk1_crop, target_h)

    # 4. listen: attentive posture, tilted head
    listen_crop = base_cropped.copy()
    head = listen_crop.crop((0, 0, cw, head_h))
    head_tilted = head.rotate(2, resample=Image.Resampling.BILINEAR, expand=False)
    listen_crop.paste((0, 0, 0, 0), (0, 0, cw, head_h))
    listen_crop.paste(head_tilted, (0, 0), head_tilted)
    states["listen"] = make_canvas(listen_crop, target_h)

    # 5. gesture: one arm raised / emphatic pose
    gesture_crop = base_cropped.copy()
    arm_box = (0, int(ch * 0.28), int(cw * 0.45), int(ch * 0.65))
    arm = gesture_crop.crop(arm_box)
    arm_gest = arm.rotate(-5, resample=Image.Resampling.BILINEAR, expand=False)
    gesture_crop.paste(arm_gest, (arm_box[0] - 2, arm_box[1] - 3), arm_gest)
    states["gesture"] = make_canvas(gesture_crop, target_h)

    # 6. turn_away: rotated posture away from camera / aversive
    turn_crop = base_cropped.transpose(Image.Transpose.FLIP_LEFT_RIGHT)
    states["turn_away"] = make_canvas(turn_crop, target_h)

    # 7. seated: upper body preserved with lowered hip line for desk / chair
    seated_target_h = 58
    seated_crop_h = int(ch * 0.72)
    seated_crop = base_cropped.crop((0, 0, cw, seated_crop_h))
    stw = max(1, round(cw * seated_target_h / seated_crop_h))
    scaled_seated = seated_crop.resize((stw, seated_target_h), Image.Resampling.LANCZOS)
    seated_canvas = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
    paste_x = PIVOT_X - stw // 2
    paste_y = PIVOT_Y - seated_target_h
    seated_canvas.paste(scaled_seated, (paste_x, paste_y), scaled_seated)
    states["seated"] = seated_canvas

    # 8. work: torso slightly forward, hands down working
    work_crop = base_cropped.copy()
    torso_box = (0, 0, cw, int(ch * 0.65))
    torso = work_crop.crop(torso_box)
    work_crop.paste((0, 0, 0, 0), torso_box)
    work_crop.paste(torso, (2, 2), torso)
    states["work"] = make_canvas(work_crop, target_h)

    return states


def process_character(char_id: str, cfg: dict) -> None:
    raw_path: Path = cfg["raw"]
    out_dir: Path = cfg["out_dir"]
    target_h: int = cfg["target_h"]

    if not raw_path.exists():
        print(f"ERROR: Raw image missing for {char_id}: {raw_path}")
        return

    out_dir.mkdir(parents=True, exist_ok=True)
    raw_img = Image.open(raw_path)
    cleared = flood_clear_black(raw_img)
    cleared = clean_islands(cleared)
    bbox = cleared.getbbox()
    if not bbox:
        print(f"ERROR: Empty bbox for {char_id}")
        return

    cropped = cleared.crop(bbox)
    states = generate_states(cropped, target_h)

    for state_name, canvas_img in states.items():
        out_file = out_dir / f"{state_name}.png"
        canvas_img.save(out_file)
        c_bbox = canvas_img.getbbox()
        h = (c_bbox[3] - c_bbox[1]) if c_bbox else 0
        print(f"[{char_id}] Saved {out_file.name}: size={canvas_img.size} bbox={c_bbox} visual_h={h}")


def main() -> None:
    for char_id, cfg in CHARS.items():
        print(f"--- Processing character: {char_id} ---")
        process_character(char_id, cfg)
    print("Done processing all characters.")


if __name__ == "__main__":
    main()
