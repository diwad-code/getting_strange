from pathlib import Path

try:
    from PIL import Image
except ImportError:
    raise SystemExit("no PIL")

src = {
    "lena": Path(r"C:\Users\admin\AppData\Local\Temp\omp-image-1566fa9af11f7a1e.jpg"),
    "marta": Path(r"C:\Users\admin\AppData\Local\Temp\omp-image-1566faa43e1f7a1f.jpg"),
    "jakub": Path(r"C:\Users\admin\AppData\Local\Temp\omp-image-1566faae1bdf7a20.jpg"),
    "wierzbicka": Path(r"C:\Users\admin\AppData\Local\Temp\omp-image-1566fab8155f7a21.jpg"),
    "szymon": Path(r"C:\Users\admin\AppData\Local\Temp\omp-image-1566fac0c39f7a22.jpg"),
}
out = Path(r"C:\getting_strange\assets\characters\portraits")
out.mkdir(parents=True, exist_ok=True)
for name, p in src.items():
    path = p if p.exists() else p.with_suffix(".webp")
    if not path.exists():
        print("MISSING", name, p)
        continue
    im = Image.open(path).convert("RGBA")
    px = im.load()
    w, h = im.size
    for y in range(h):
        for x in range(w):
            r, g, b, _a = px[x, y]
            if r < 18 and g < 18 and b < 18:
                px[x, y] = (0, 0, 0, 0)
    dest = out / f"{name}.png"
    im.save(dest)
    print(dest, im.size)
