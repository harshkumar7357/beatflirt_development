import os
import zlib
import struct

def make_png(width, height, color=(0, 240, 255, 255)):
    """Generates a simple solid color RGBA PNG."""
    png = b'\x89PNG\r\n\x1a\n'
    ihdr = struct.pack('>IIBBBBB', width, height, 8, 6, 0, 0, 0)
    png += struct.pack('>I', 13) + b'IHDR' + ihdr + struct.pack('>I', zlib.crc32(b'IHDR' + ihdr))
    
    row = b'\x00' + bytes(color) * width
    data = row * height
    compressed = zlib.compress(data)
    png += struct.pack('>I', len(compressed)) + b'IDAT' + compressed + struct.pack('>I', zlib.crc32(b'IDAT' + compressed))
    
    png += struct.pack('>I', 0) + b'IEND' + struct.pack('>I', zlib.crc32(b'IEND'))
    return png

def main():
    base_res = "android/app/src/main/res"
    
    # Define directories
    dirs = [
        "values",
        "values-night",
        "drawable",
        "drawable-v21",
        "mipmap-mdpi",
        "mipmap-hdpi",
        "mipmap-xhdpi",
        "mipmap-xxhdpi",
        "mipmap-xxxhdpi"
    ]
    
    # Create directories
    for d in dirs:
        path = os.path.join(base_res, d)
        os.makedirs(path, exist_ok=True)
        print(f"Created/verified: {path}")
        
    # 1. Write values/styles.xml
    styles_content = """<?xml version="1.0" encoding="utf-8"?>
<resources>
    <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
    <style name="NormalTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="android:windowBackground">?android:colorBackground</item>
    </style>
</resources>
"""
    for folder in ["values", "values-night"]:
        with open(os.path.join(base_res, folder, "styles.xml"), "w") as f:
            f.write(styles_content)
        print(f"Wrote styles.xml to {folder}")
        
    # 2. Write drawable/launch_background.xml
    launch_bg_content = """<?xml version="1.0" encoding="utf-8"?>
<layer-list xmlns:android="http://schemas.android.com/apk/res/android">
    <item android:drawable="@android:color/black" />
</layer-list>
"""
    for folder in ["drawable", "drawable-v21"]:
        with open(os.path.join(base_res, folder, "launch_background.xml"), "w") as f:
            f.write(launch_bg_content)
        print(f"Wrote launch_background.xml to {folder}")
        
    # 3. Generate launcher icons for each density
    icons = {
        "mipmap-mdpi": 48,
        "mipmap-hdpi": 72,
        "mipmap-xhdpi": 96,
        "mipmap-xxhdpi": 144,
        "mipmap-xxxhdpi": 192
    }
    
    for folder, size in icons.items():
        png_data = make_png(size, size, color=(0, 240, 255, 255)) # Beautiful Cyan launcher icon
        with open(os.path.join(base_res, folder, "ic_launcher.png"), "wb") as f:
            f.write(png_data)
        print(f"Generated {size}x{size} ic_launcher.png in {folder}")

if __name__ == "__main__":
    main()
