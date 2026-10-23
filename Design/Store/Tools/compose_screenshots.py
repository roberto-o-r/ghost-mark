"""Frames raw 1080x1920 app screenshots into Play Store screenshots.

Usage: python compose_screenshots.py RAW_DIR OUT_DIR MONTSERRAT_TTF

RAW_DIR holds the raw captures named below. Capture them on an Android
emulator set to 1080x1920 (`adb shell wm size 1080x1920`) with System UI demo
mode on (clock 11:30), with sample-document.md opened in the app.
MONTSERRAT_TTF is the variable Montserrat font from Google Fonts.
Requires Pillow.
"""

import sys

from PIL import Image, ImageDraw, ImageFont

SHOTS = [
    ("editor.png", "1-editor.png", ["Clean and simple", "Markdown editor."]),
    ("toolbar.png", "2-toolbar.png", ["Format with", "one tap."]),
    ("preview.png", "3-preview.png", ["Instant preview."]),
    ("open-save.png", "4-open-save.png", ["Open and save", ".md files."]),
]


def main(raw_dir, out_dir, font_path):
    font = ImageFont.truetype(font_path, 100)
    font.set_variation_by_name("Bold")
    for raw, out, lines in SHOTS:
        canvas = Image.new("RGB", (1080, 1920), "black")
        draw = ImageDraw.Draw(canvas)
        top = 95 if len(lines) == 2 else 150
        for i, line in enumerate(lines):
            draw.text((62, top + i * 115), line, font=font, fill="white")
        shot = Image.open(f"{raw_dir}/{raw}").convert("RGB")
        width = 842
        shot = shot.resize(
            (width, round(shot.height * width / shot.width)), Image.LANCZOS
        )
        x = (1080 - width) // 2
        canvas.paste(shot, (x, 420))
        draw.rectangle((x - 3, 417, x + width + 2, 1925), outline="#555555", width=3)
        canvas.save(f"{out_dir}/{out}")


if __name__ == "__main__":
    main(*sys.argv[1:4])
