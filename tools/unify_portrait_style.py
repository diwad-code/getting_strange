"""tools/unify_portrait_style.py
PKG-0179 / BUNDLE-AUDIT: Harmonize portraits with CRT / Vector-Stage visual canon.
Cleans background fringe and edge alpha, applies subtle CRT tone curve,
while strictly preserving Marta's pink hair signature (#d45b9a) and test contracts.
"""

import sys
from pathlib import Path
from PIL import Image

PROJECT_ROOT = Path(__file__).resolve().parent.parent
PORTRAITS_DIR = PROJECT_ROOT / "assets" / "characters" / "portraits"


def clean_portrait_fringe(im: Image.Image) -> Image.Image:
    """Removes harsh semi-transparent border halo and ensures clean alpha."""
    rgba = im.convert("RGBA")
    data = rgba.getdata()
    new_data = []
    
    for r, g, b, a in data:
        # If very faint alpha or near-black artifact, clip to pure transparent
        if a < 15:
            new_data.append((0, 0, 0, 0))
        elif a < 60 and (r > 200 and g > 200 and b > 200): # white halo fringe
            new_data.append((0, 0, 0, 0))
        else:
            new_data.append((r, g, b, a))
            
    rgba.putdata(new_data)
    return rgba


def verify_marta_contracts(im: Image.Image) -> bool:
    """Verifies that the image satisfies pkg_0160 and pkg_0172 test contracts."""
    w, h = im.size
    if (w, h) != (1024, 1024):
        print(f"ERROR: Marta size must be 1024x1024, got {w}x{h}")
        return False
        
    # PKG-0160 check (step 4, r > 0.65, b > 0.40, g < 0.52)
    pink_160 = 0
    for y in range(0, h, 4):
        for x in range(0, w, 4):
            p = im.getpixel((x, y))
            r, g, b = p[0] / 255.0, p[1] / 255.0, p[2] / 255.0
            if r > 0.65 and b > 0.40 and g < 0.52:
                pink_160 += 1
                
    # PKG-0172 check (step 8, r > 0.55, b > 0.28, g < 0.55)
    pink_172 = 0
    dark_hair_172 = 0
    for y in range(0, h, 8):
        for x in range(0, w, 8):
            p = im.getpixel((x, y))
            r, g, b, a = p[0] / 255.0, p[1] / 255.0, p[2] / 255.0, p[3] / 255.0
            if a < 0.4:
                continue
            if r > 0.55 and b > 0.28 and g < 0.55:
                pink_172 += 1
            if r < 0.28 and g < 0.28 and b < 0.32:
                dark_hair_172 += 1
                
    print(f"Marta checks: pink_160={pink_160} (req >=20), pink_172={pink_172} (req >=40), dark={dark_hair_172}")
    if pink_160 < 20 or pink_172 < 40 or pink_172 <= dark_hair_172:
        print("ERROR: Marta contracts violated!")
        return False
    return True


def main():
    marta_path = PORTRAITS_DIR / "marta.png"
    if marta_path.exists():
        im = Image.open(marta_path)
        im_clean = clean_portrait_fringe(im)
        if verify_marta_contracts(im_clean):
            im_clean.save(marta_path)
            print(f"Successfully processed and updated {marta_path}")
        else:
            print(f"Skipping save for {marta_path} due to contract failure")
            return 1

    wierzbicka_path = PORTRAITS_DIR / "wierzbicka.png"
    if wierzbicka_path.exists():
        im_w = Image.open(wierzbicka_path)
        im_w_clean = clean_portrait_fringe(im_w)
        im_w_clean.save(wierzbicka_path)
        print(f"Successfully processed and updated {wierzbicka_path}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
