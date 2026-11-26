#!/usr/bin/env python3
"""Track Builder — Phase 4 sprites.

Procedural PNG sprites banata hai (PIL se) — koi external asset nahi.
Output: assets/images/{cars,pieces,backgrounds,ui,effects}/

Chalane ke liye: python3 tools/generate_sprites.py (repo root se)
Phir: flutter pub get (assets pubspec mein registered hain)
"""
import math
import os
from PIL import Image, ImageDraw, ImageFilter

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "assets", "images")


def save(img, path):
    full = os.path.join(OUT, path)
    os.makedirs(os.path.dirname(full), exist_ok=True)
    img.save(full, "PNG")
    print("wrote", path, img.size)


def hexcol(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4)) + (255,)


# ---------------------------------------------------------------- cars
def draw_car(body, cabin, stripe, name, style="bug"):
    W, H = 520, 200
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    body_c = hexcol(body)
    dark = tuple(max(0, c - 40) for c in body_c[:3]) + (255,)
    stripe_c = hexcol(stripe)
    window_c = (176, 224, 245, 255)

    if style == "van":
        # Boxy van — tall body, cabin poori chaudai.
        d.rounded_rectangle([20, 50, 500, 165], radius=28, fill=body_c)
        d.rounded_rectangle([30, 60, 490, 155], radius=22, fill=dark)
        d.rounded_rectangle([40, 70, 480, 145], radius=18, fill=body_c)
        d.rounded_rectangle([70, 82, 220, 135], radius=10, fill=window_c)
        d.rounded_rectangle([250, 82, 450, 135], radius=10, fill=window_c)
    elif style == "pickup":
        # Pickup — cabin aage, khula bed peeche.
        d.rounded_rectangle([20, 95, 500, 165], radius=18, fill=body_c)
        d.rounded_rectangle([250, 45, 430, 100], radius=20, fill=body_c)
        d.rounded_rectangle([265, 58, 415, 95], radius=12, fill=window_c)
        d.rounded_rectangle([30, 100, 230, 130], radius=8, fill=dark)
    elif style == "racer":
        # Sleek racer — neechi, lambi cabin.
        d.rounded_rectangle([15, 110, 505, 165], radius=20, fill=body_c)
        d.polygon([(150, 112), (230, 55), (380, 55), (440, 112)], fill=body_c)
        d.polygon([(175, 105), (240, 68), (360, 68), (410, 105)],
                  fill=window_c)
    else:
        # Classic bug — gol body + gol cabin.
        d.rounded_rectangle([20, 95, 500, 165], radius=30, fill=body_c)
        d.rounded_rectangle([150, 45, 370, 105], radius=28, fill=body_c)
        d.rounded_rectangle([170, 60, 350, 100], radius=20, fill=window_c)
        # Cabin divider.
        d.line([(260, 60), (260, 100)], fill=dark, width=6)

    # Stripe — body ke beech se.
    d.rectangle([20, 128, 500, 142], fill=stripe_c)
    # Headlight (aage, daayein) + taillight (peeche, baayein).
    d.ellipse([478, 118, 500, 138], fill=(255, 235, 59, 255))
    d.ellipse([20, 118, 42, 138], fill=(198, 40, 40, 255))
    # Bumper line.
    d.line([(20, 165), (500, 165)], fill=dark, width=4)
    save(img, f"cars/car_{name}.png")


def draw_wheel():
    S = 200
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([4, 4, 196, 196], fill=(33, 33, 33, 255))
    # Tread marks.
    for a in range(0, 360, 30):
        r = math.radians(a)
        x1 = 100 + 88 * math.cos(r)
        y1 = 100 + 88 * math.sin(r)
        x2 = 100 + 96 * math.cos(r)
        y2 = 100 + 96 * math.sin(r)
        d.line([(x1, y1), (x2, y2)], fill=(66, 66, 66, 255), width=6)
    d.ellipse([55, 55, 145, 145], fill=(120, 120, 120, 255))
    d.ellipse([75, 75, 125, 125], fill=(220, 220, 220, 255))
    d.ellipse([92, 92, 108, 108], fill=(66, 66, 66, 255))
    # Spoke — spin dikhane ke liye.
    d.line([(100, 100), (145, 100)], fill=(255, 255, 255, 255), width=8)
    save(img, "cars/wheel.png")


# ---------------------------------------------------------------- pieces
def draw_road():
    W, H = 800, 120
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, W, H], fill=hexcol("#8D6E63"))
    # Upar ki halki patti (grass edge jaisi nahi — lakri ki top).
    d.rectangle([0, 0, W, 18], fill=hexcol("#A1887F"))
    # Plank seams + nails.
    for x in range(0, W, 100):
        d.line([(x, 0), (x, H)], fill=hexcol("#6D4C41"), width=4)
        d.ellipse([x + 46, 52, x + 54, 60], fill=(60, 40, 30, 255))
    d.rectangle([0, H - 8, W, H], fill=hexcol("#5D4037"))
    save(img, "pieces/road.png")


def draw_ramp():
    W, H = 1000, 120
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, W, H], fill=hexcol("#FF9800"))
    d.rectangle([0, 0, W, 18], fill=hexcol("#FFB74D"))
    # Chevrons — aage ki taraf.
    for x in range(60, W, 160):
        d.polygon([(x, 30), (x + 45, 60), (x, 90), (x + 18, 60)],
                  fill=(255, 255, 255, 220))
    d.rectangle([0, H - 8, W, H], fill=hexcol("#E65100"))
    save(img, "pieces/ramp.png")


def draw_bridge():
    W, H = 1600, 120
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rectangle([0, 0, W, H], fill=hexcol("#795548"))
    d.rectangle([0, 0, W, 16], fill=hexcol("#A1887F"))
    # Planks — har 100px ek takhta.
    for x in range(0, W, 100):
        d.line([(x, 0), (x, H)], fill=hexcol("#4E342E"), width=5)
        d.ellipse([x + 46, 52, x + 54, 60], fill=(40, 25, 18, 255))
    # Rope rails — upar aur neeche halki line.
    d.line([(0, 26), (W, 26)], fill=hexcol("#D7CCC8"), width=3)
    d.line([(0, 94), (W, 94)], fill=hexcol("#D7CCC8"), width=3)
    d.rectangle([0, H - 8, W, H], fill=hexcol("#3E2723"))
    save(img, "pieces/bridge.png")


def draw_booster():
    W, H = 400, 60
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.rounded_rectangle([0, 0, W, H], radius=10, fill=hexcol("#00E5FF"))
    d.rounded_rectangle([4, 4, W - 4, H - 4], radius=8,
                        fill=hexcol("#00B8D4"))
    for x in (70, 190, 300):
        d.polygon([(x, 12), (x + 40, 30), (x, 48), (x + 14, 30)],
                  fill=(255, 255, 255, 240))
    save(img, "pieces/booster.png")


# ---------------------------------------------------------------- ui
def draw_coin():
    S = 200
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.ellipse([6, 6, 194, 194], fill=hexcol("#FF8F00"))
    d.ellipse([14, 14, 186, 186], fill=hexcol("#FFD600"))
    d.ellipse([45, 45, 155, 155], fill=hexcol("#FFF176"))
    # Star beech mein.
    cx, cy, r = 100, 100, 42
    pts = []
    for i in range(10):
        ang = -math.pi / 2 + i * math.pi / 5
        rr = r if i % 2 == 0 else r * 0.45
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    d.polygon(pts, fill=hexcol("#FF8F00"))
    save(img, "ui/coin.png")


def draw_flag():
    W, H = 400, 200
    img = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    sq = 50
    for row in range(4):
        for col in range(8):
            c = (0, 0, 0, 255) if (row + col) % 2 == 0 else (255, 255, 255, 255)
            d.rectangle([col * sq, row * sq, (col + 1) * sq, (row + 1) * sq],
                        fill=c)
    save(img, "ui/flag.png")


# ---------------------------------------------------------------- backgrounds
def vgrad(w, h, top, bottom):
    img = Image.new("RGBA", (w, h))
    d = ImageDraw.Draw(img)
    for y in range(h):
        t = y / max(h - 1, 1)
        c = tuple(int(top[i] + (bottom[i] - top[i]) * t) for i in range(3))
        d.line([(0, y), (w, y)], fill=c + (255,))
    return img


def draw_clouds(d, spots):
    for (x, y, s) in spots:
        for (dx, dy, r) in ((0, 0, 34), (34, 8, 26), (-32, 10, 24),
                            (16, -10, 28)):
            d.ellipse([x + dx * s // 40 - r * s // 40,
                       y + dy * s // 40 - r * s // 40,
                       x + dx * s // 40 + r * s // 40,
                       y + dy * s // 40 + r * s // 40],
                      fill=(255, 255, 255, 235))


def draw_bg(world, top, bottom, hill1, hill2, sun, clouds):
    W, H = 1600, 880
    img = vgrad(W, H, hexcol(top), hexcol(bottom))
    d = ImageDraw.Draw(img)
    # Sooraj.
    d.ellipse([1380, 60, 1500, 180], fill=hexcol(sun))
    d.ellipse([1395, 75, 1485, 165], fill=(255, 255, 255, 90))
    draw_clouds(d, clouds)
    # Peeche ki pahadiyan.
    d.ellipse([-200, 560, 700, 900], fill=hexcol(hill2))
    d.ellipse([600, 500, 1500, 900], fill=hexcol(hill2))
    d.ellipse([1100, 590, 1800, 900], fill=hexcol(hill1))
    d.ellipse([200, 620, 900, 900], fill=hexcol(hill1))
    if world == 3:
        # Pine trees — barf wale.
        for (x, s) in ((180, 1.0), (1420, 1.2), (900, 0.8)):
            h = int(150 * s)
            w = int(90 * s)
            d.polygon([(x, 700 - h), (x - w, 700), (x + w, 700)],
                      fill=hexcol("#2E7D32"))
            d.polygon([(x, 700 - h), (x - w // 2, 700 - h // 2),
                       (x + w // 2, 700 - h // 2)], fill=(255, 255, 255, 230))
            d.rectangle([x - 8, 700, x + 8, 730], fill=hexcol("#5D4037"))
    save(img, f"backgrounds/bg_world{world}.png")


# ---------------------------------------------------------------- effects
def draw_smoke():
    S = 200
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    for r, a in ((95, 40), (75, 70), (55, 110), (35, 150)):
        d.ellipse([100 - r, 100 - r, 100 + r, 100 + r],
                  fill=(200, 200, 200, a))
    img = img.filter(ImageFilter.GaussianBlur(8))
    save(img, "effects/smoke.png")


def draw_spark():
    S = 200
    img = Image.new("RGBA", (S, S), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    cx, cy = 100, 100
    pts = []
    for i in range(8):
        ang = i * math.pi / 4
        rr = 95 if i % 2 == 0 else 28
        pts.append((cx + rr * math.cos(ang), cy + rr * math.sin(ang)))
    d.polygon(pts, fill=(255, 215, 0, 255))
    d.ellipse([70, 70, 130, 130], fill=(255, 255, 255, 255))
    save(img, "effects/spark.png")


def main():
    draw_car("#E53935", "#FF7043", "#FFFFFF", "starter_bug", "bug")
    draw_car("#FF7043", "#FFE082", "#5D4037", "desert_pickup", "pickup")
    draw_car("#1E88E5", "#FFFFFF", "#0D47A1", "snow_rally", "bug")
    draw_car("#8E24AA", "#E1BEE7", "#4A148C", "city_racer", "racer")
    draw_car("#00897B", "#B2DFDB", "#004D40", "rocket_van", "van")
    draw_wheel()
    draw_road()
    draw_ramp()
    draw_bridge()
    draw_booster()
    draw_coin()
    draw_flag()
    draw_bg(1, "#87CEEB", "#E3F2FD", "#81C784", "#A5D6A7", "#FFF59D",
            [(300, 150, 40), (900, 100, 32), (1300, 250, 36)])
    draw_bg(2, "#FFE0B2", "#FFF3E0", "#F0C078", "#F7D9A8", "#FFD54F",
            [(350, 140, 40), (1000, 220, 30)])
    draw_bg(3, "#D6ECF5", "#FFFFFF", "#FFFFFF", "#E8F4FA", "#FFFDE7",
            [(300, 130, 36), (1100, 180, 30)])
    draw_smoke()
    draw_spark()
    print("done —", len(os.listdir(OUT)), "folders")


if __name__ == "__main__":
    main()
