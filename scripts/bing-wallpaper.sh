#!/bin/bash

WALLPAPER_DIR="$HOME/.local/share/bing-wallpaper"
CURRENT_WALLPAPER="$WALLPAPER_DIR/current.jpg"

mkdir -p "$WALLPAPER_DIR"

API_URL="https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN"
IMAGE_URL="https://www.bing.com$(curl -s "$API_URL" | jq -r '.images[0].url')"

DATE=$(date +%Y%m%d)
OUTPUT="$WALLPAPER_DIR/$DATE.jpg"

if [[ ! -f "$OUTPUT" ]]; then
    curl -sL "$IMAGE_URL" -o "$OUTPUT"
    echo "Downloaded: $OUTPUT"
fi

ln -sf "$OUTPUT" "$CURRENT_WALLPAPER"

if pgrep -x swww-daemon > /dev/null; then
    swww img "$OUTPUT" --transition-type=random
fi
