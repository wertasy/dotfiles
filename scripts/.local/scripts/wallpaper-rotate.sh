#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
SYMLINK="$WALLPAPER_DIR/current.jpg"
PLAYLIST="$HOME/.local/state/wallpaper-playlist"

mkdir -p "$WALLPAPER_DIR" "$(dirname "$PLAYLIST")"

# Collect current wallpapers
candidates=($(find "$WALLPAPER_DIR" -maxdepth 1 -type f \( -name "*.jpg" -o -name "*.png" \) ! -name "current.*"))
if [ ${#candidates[@]} -eq 0 ]; then
    echo "No local wallpapers available"
    exit 1
fi

# Fingerprint: sorted file list hash, detects added/removed wallpapers
current_fp=$(printf '%s\n' "${candidates[@]}" | sort | md5sum | cut -d' ' -f1)

shuffle_and_save() {
    local arr=("$@")
    # Fisher-Yates shuffle
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

choose_next() {
    local pos=$1
    shift
    local arr=("$@")
    echo "${arr[$pos]}"
}

# Load or rebuild playlist
if [ -f "$PLAYLIST" ]; then
    saved_fp=$(sed -n '1p' "$PLAYLIST")
    pos=$(sed -n '2p' "$PLAYLIST")
    mapfile -t saved_list < <(tail -n +3 "$PLAYLIST")

    if [ "$saved_fp" = "$current_fp" ] && [ "$pos" -lt "${#saved_list[@]}" ] 2>/dev/null; then
        chosen=$(choose_next "$pos" "${saved_list[@]}")
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
echo "Wallpaper rotated to: $(basename "$chosen")"

if command -v awww &> /dev/null; then
    awww img -t random --transition-duration 2 "$SYMLINK"
elif command -v swww &> /dev/null; then
    swww img "$SYMLINK"
fi
