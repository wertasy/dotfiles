#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK="$WALLPAPER_DIR/current.jpg"

mkdir -p "$WALLPAPER_DIR"

API_URL="https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN"

response=$(curl -s "$API_URL")
urlbase=$(echo "$response" | jq -r '.images[0].urlbase')

if [ -z "$urlbase" ] || [ "$urlbase" = "null" ]; then
    echo "Failed to fetch Bing wallpaper metadata"
    exit 1
fi

filename=$(basename "$urlbase" | sed 's/^th?id=//')_UHD.jpg
filepath="$WALLPAPER_DIR/$filename"
full_url="https://cn.bing.com${urlbase}_UHD.jpg&rfc=1"

if [ -f "$filepath" ]; then
    echo "Wallpaper already exists: $filename"
else
    if curl -s -L -o "$filepath" "$full_url" && [ -f "$filepath" ] && [ -s "$filepath" ]; then
        resolution=$(file "$filepath" | sed -n 's/.*\([0-9]\{4,\}x[0-9]\{4,\}\).*/\1/p')
        echo "Bing wallpaper downloaded: $filename (UHD: $resolution)"
    else
        rm -f "$filepath"
        echo "Failed to download wallpaper"
        exit 1
    fi
fi

candidates=($(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) ! -name "current.*"))
if [ ${#candidates[@]} -eq 0 ]; then
    echo "No local wallpapers available"
    exit 1
fi

chosen="${candidates[$RANDOM % ${#candidates[@]}]}"
ln -sf "$chosen" "$SYMLINK"
echo "Wallpaper set to: $(basename "$chosen")"

if command -v awww &> /dev/null; then
    awww img "$SYMLINK"
elif command -v swww &> /dev/null; then
    swww img "$SYMLINK"
fi
