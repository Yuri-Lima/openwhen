#!/usr/bin/env python3
"""
Redimensiona screenshots para todos os tamanhos exigidos pela Apple App Store.
Coloca as imagens originais em app_store_assets/originals/ e executa este script.
"""

from PIL import Image
import os
import sys

SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
ORIGINALS_DIR = os.path.join(SCRIPT_DIR, "originals")

# Tamanhos exigidos pela Apple
SIZES = {
    "iphone_6_7":  (1290, 2796),   # iPhone 14/15 Pro Max (6.7")
    "iphone_6_5":  (1242, 2688),   # iPhone 11 Pro Max (6.5")
    "iphone_5_5":  (1242, 2208),   # iPhone 8 Plus (5.5")
    "ipad_12_9":   (2048, 2732),   # iPad Pro 12.9" (3rd gen+)
}

def resize_with_background(img, target_w, target_h):
    """
    Redimensiona mantendo aspect ratio e preenche com fundo preto
    (ideal para screenshots em fundo escuro como o whenote).
    """
    orig_w, orig_h = img.size
    ratio = min(target_w / orig_w, target_h / orig_h)
    new_w = int(orig_w * ratio)
    new_h = int(orig_h * ratio)

    resized = img.resize((new_w, new_h), Image.LANCZOS)

    # Criar canvas com fundo preto
    canvas = Image.new("RGB", (target_w, target_h), (0, 0, 0))
    # Centralizar
    x = (target_w - new_w) // 2
    y = (target_h - new_h) // 2
    canvas.paste(resized, (x, y))
    return canvas


def main():
    if not os.path.isdir(ORIGINALS_DIR):
        print(f"Pasta não encontrada: {ORIGINALS_DIR}")
        sys.exit(1)

    originals = sorted([
        f for f in os.listdir(ORIGINALS_DIR)
        if f.lower().endswith((".png", ".jpg", ".jpeg"))
    ])

    if not originals:
        print(f"Nenhuma imagem encontrada em {ORIGINALS_DIR}")
        sys.exit(1)

    print(f"Encontradas {len(originals)} imagens originais.\n")

    for size_name, (tw, th) in SIZES.items():
        out_dir = os.path.join(SCRIPT_DIR, size_name)
        os.makedirs(out_dir, exist_ok=True)

        print(f"--- {size_name} ({tw}x{th}) ---")
        for fname in originals:
            img_path = os.path.join(ORIGINALS_DIR, fname)
            img = Image.open(img_path).convert("RGB")
            result = resize_with_background(img, tw, th)

            # Sempre salvar como PNG (exigido pela Apple)
            out_name = os.path.splitext(fname)[0] + ".png"
            out_path = os.path.join(out_dir, out_name)
            result.save(out_path, "PNG", optimize=True)
            print(f"  ✓ {out_name}")

    print("\nConcluído! Screenshots prontos para upload no App Store Connect.")


if __name__ == "__main__":
    main()
