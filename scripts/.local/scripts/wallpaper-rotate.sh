#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK="$WALLPAPER_DIR/current.jpg"

candidates=($(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) ! -name "current.*"))
if [ ${#candidates[@]} -eq 0 ]; then
    echo "No local wallpapers available"
    exit 1
fi

chosen="${candidates[$RANDOM % ${#candidates[@]}]}"
ln -sf "$chosen" "$SYMLINK"
echo "Wallpaper rotated to: $(basename "$chosen")"

if command -v awww &> /dev/null; then
    awww img "$SYMLINK"
elif command -v swww &> /dev/null; then
    swww img "$SYMLINK"
fi
