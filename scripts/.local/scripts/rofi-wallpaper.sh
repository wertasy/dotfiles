#!/bin/bash
# Rofi Wallpaper Selector - 匹配主题配色

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK="$WALLPAPER_DIR/current.jpg"

if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "错误" "壁纸目录不存在: $WALLPAPER_DIR"
    exit 1
fi

# 使用自定义主题（匹配配色方案）
SELECTED=$(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.JPG" -o -name "*.PNG" \) | while read -r wallpaper; do
    name=$(basename "$wallpaper")
    printf '%s\0icon\x1f%s\n' "$name" "$wallpaper"
done | rofi -dmenu -i -p "壁纸" \
    -theme /home/wert/.config/rofi/wallpaper-preview.rasi \
)

if [ -z "$SELECTED" ]; then
    exit 0
fi

WALLPAPER_PATH="$WALLPAPER_DIR/$SELECTED"

ln -sf "$WALLPAPER_PATH" "$SYMLINK"

if command -v awww &> /dev/null; then
    awww img -t random --transition-duration 2 "$SYMLINK"
elif command -v swww &> /dev/null; then
    swww img "$SYMLINK"
fi

notify-send -i image-x-generic "壁纸已更新" "$SELECTED"
