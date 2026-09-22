#!/usr/bin/env python3
"""Apply Marta's approved identity markers to the maintained CRT raster portrait.

The source image remains intentionally low-detail Pixel-Stage art. This tool only
adds the signed-off long pink hair and steel septum; it does not regenerate a face.
"""

from pathlib import Path

from PIL import Image, ImageDraw


PORTRAIT = Path(r"C:\getting_strange\assets\characters\portraits\marta.png")
PINK = (212, 91, 154, 255)
PINK_SHADE = (109, 41, 79, 255)
STEEL = (199, 211, 214, 255)


def is_old_hair(pixel: tuple[int, int, int, int], y: int) -> bool:
    r, g, b, a = pixel
    # The maintained raster uses an opaque black CRT field. Never classify that
    # field as hair: it would turn the entire portrait background pink.
    return (
        a > 0
        and y < 520
        and max(r, g, b) > 24
        and r < 78
        and g < 84
        and b < 82
        and max(r, g, b) - min(r, g, b) < 36
    )


def main() -> None:
    image = Image.open(PORTRAIT).convert("RGBA")
    hair_layer = Image.new("RGBA", image.size)
    draw = ImageDraw.Draw(hair_layer)

    # Two broad locks begin outside the face silhouette and end over the jacket.
    # They are composited above the retained portrait so the long-hair read is
    # reliable even when the source raster had a tied-back hairstyle.
    draw.polygon([(244, 286), (298, 248), (338, 298), (318, 456), (306, 612), (270, 702), (226, 664), (238, 500), (208, 388)], fill=PINK_SHADE)
    draw.polygon([(720, 270), (778, 298), (818, 386), (806, 526), (792, 690), (746, 718), (702, 674), (720, 512), (692, 382)], fill=PINK_SHADE)
    draw.line([(258, 300), (286, 350), (282, 572), (264, 656)], fill=PINK, width=18)
    draw.line([(746, 298), (778, 370), (774, 582), (756, 676)], fill=PINK, width=18)
    pixels = image.load()
    for y in range(image.height):
        for x in range(image.width):
            if is_old_hair(pixels[x, y], y):
                shade = PINK_SHADE if (x + y) % 11 < 6 else PINK
                pixels[x, y] = shade

    image = Image.alpha_composite(image, hair_layer)

    draw = ImageDraw.Draw(image)
    # A compact lower-nostril horseshoe, stepped to read at the portrait's raster scale.
    draw.line([(602, 402), (602, 414), (608, 422), (618, 426), (628, 422), (634, 414), (634, 402)], fill=STEEL, width=5)
    draw.point((602, 402), fill=(235, 242, 242, 255))
    draw.point((634, 402), fill=(235, 242, 242, 255))
    image.save(PORTRAIT)
    print(f"updated {PORTRAIT}")


if __name__ == "__main__":
    main()