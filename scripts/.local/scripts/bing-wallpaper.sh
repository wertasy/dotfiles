#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK="$WALLPAPER_DIR/current.jpg"
PLAYLIST="$HOME/.local/state/wallpaper-playlist"

mkdir -p "$WALLPAPER_DIR" "$(dirname "$PLAYLIST")"

download_bing() {
    local api_url="$1"
    local market="$2"

    response=$(curl -s "$api_url")
    urlbase=$(echo "$response" | jq -r '.images[0].urlbase')

    if [ -z "$urlbase" ] || [ "$urlbase" = "null" ]; then
        echo "[$market] Failed to fetch Bing wallpaper metadata"
        return 1
    fi

    filename=$(basename "$urlbase" | sed 's/^th?id=//')_UHD.jpg
    filepath="$WALLPAPER_DIR/$filename"
    full_url="https://www.bing.com${urlbase}_UHD.jpg&rfc=1"

    if [ -f "$filepath" ]; then
        echo "[$market] Wallpaper already exists: $filename"
    else
        if curl -s -L -o "$filepath" "$full_url" && [ -f "$filepath" ] && [ -s "$filepath" ]; then
            resolution=$(file "$filepath" | sed -n 's/.*\([0-9]\{4,\}x[0-9]\{4,\}\).*/\1/p')
            echo "[$market] Bing wallpaper downloaded: $filename (UHD: $resolution)"
        else
            rm -f "$filepath"
            echo "[$market] Failed to download wallpaper"
            return 1
        fi
    fi
}

# Download from both markets
download_bing "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=zh-CN" "CN"
download_bing "https://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US" "EN"

# --- Shuffle logic ---
candidates=($(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) ! -name "current.*"))
if [ ${#candidates[@]} -eq 0 ]; then
    echo "No local wallpapers available"
    exit 1
fi

current_fp=$(printf '%s\n' "${candidates[@]}" | sort | md5sum | cut -d' ' -f1)

shuffle_and_save() {
    local arr=("$@")
    for ((i = ${#arr[@]} - 1; i > 0; i--)); do
        j=$((RANDOM % (i + 1)))
        tmp="${arr[i]}"; arr[i]="${arr[j]}"; arr[j]="$tmp"
    done
    {
        echo "$current_fp"
        echo "0"
        printf '%s\n' "${arr[@]}"
    } > "$PLAYLIST"
}

if [ -f "$PLAYLIST" ]; then
    saved_fp=$(sed -n '1p' "$PLAYLIST")
    pos=$(sed -n '2p' "$PLAYLIST")
    mapfile -t saved_list < <(tail -n +3 "$PLAYLIST")

    if [ "$saved_fp" = "$current_fp" ] && [ "$pos" -lt "${#saved_list[@]}" ] 2>/dev/null; then
        chosen="${saved_list[$pos]}"
        sed -i "2s/.*/$((pos + 1))/" "$PLAYLIST"
    else
        shuffle_and_save "${candidates[@]}"
        chosen="${candidates[0]}"
        sed -i "2s/.*/1/" "$PLAYLIST"
    fi
else
    shuffle_and_save "${candidates[@]}"
    chosen="${candidates[0]}"
    sed -i "2s/.*/1/" "$PLAYLIST"
fi

ln -sf "$chosen" "$SYMLINK"
WALLPAPER_NAME=$(basename "$chosen")
echo "Wallpaper set to: $WALLPAPER_NAME"

if command -v awww &> /dev/null; then
    awww img -t random --transition-duration 2 "$SYMLINK"
elif command -v swww &> /dev/null; then
    swww img "$SYMLINK"
fi

# 发送通知
notify-send -i image-x-generic "壁纸已更新" "当前壁纸: $WALLPAPER_NAME"
