#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
WALLPAPER_FILE="$WALLPAPER_DIR/bing-wallpaper.jpg"

mkdir -p "$WALLPAPER_DIR"

API_URL="https://cn.bing.com/HPImageArchive.aspx?format=js&idx=0&n=8&mkt=zh-CN"

response=$(curl -s "$API_URL")
count=$(echo "$response" | jq -r '.images | length')

if [ -n "$count" ] && [ "$count" -gt 0 ]; then
    random_index=$((RANDOM % count))
    urlbase=$(echo "$response" | jq -r ".images[$random_index].urlbase")
    
    if [ -n "$urlbase" ] && [ "$urlbase" != "null" ]; then
        full_url="https://cn.bing.com${urlbase}_UHD.jpg&rfc=1"
        
        if curl -s -L -o "$WALLPAPER_FILE" "$full_url" && [ -f "$WALLPAPER_FILE" ] && [ -s "$WALLPAPER_FILE" ]; then
            if command -v swww &> /dev/null; then
                swww img "$WALLPAPER_FILE"
            elif command -v feh &> /dev/null; then
                feh --bg-fill "$WALLPAPER_FILE"
            elif command -v nitrogen &> /dev/null; then
                nitrogen --set-zoom-fill "$WALLPAPER_FILE"
            elif command -v gsettings &> /dev/null; then
                gsettings set org.gnome.desktop.background picture-uri "file://$WALLPAPER_FILE"
            fi
            
            resolution=$(file "$WALLPAPER_FILE" | sed -n 's/.*\([0-9]\{4,\}x[0-9]\{4,\}\).*/\1/p')
            echo "Bing wallpaper downloaded (UHD: $resolution) and set successfully"
        else
            echo "Failed to download Bing wallpaper"
            exit 1
        fi
    else
        echo "Failed to fetch Bing wallpaper metadata"
        exit 1
    fi
else
    echo "Failed to fetch Bing wallpaper list"
    exit 1
fi
