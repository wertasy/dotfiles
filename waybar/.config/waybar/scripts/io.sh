#!/bin/bash
CACHE_FILE="/tmp/waybar-io-prev"

get_io_stats() {
    awk '$3 ~ /^nvme[0-9]+n[0-9]+$/ || $3 ~ /^sd[a-z]+$/ || $3 ~ /^vd[a-z]+$/ {
        read_sectors += $6
        write_sectors += $10
    } END {
        print read_sectors+0, write_sectors+0
    }' /proc/diskstats
}

format_bytes() {
    local bytes=$1
    if (( bytes >= 1073741824 )); then
        local val=$(( bytes * 10 / 1073741824 ))
        printf "%d.%dG" "$(( val / 10 ))" "$(( val % 10 ))"
    elif (( bytes >= 1048576 )); then
        local val=$(( bytes * 10 / 1048576 ))
        printf "%d.%dM" "$(( val / 10 ))" "$(( val % 10 ))"
    elif (( bytes >= 1024 )); then
        printf "%dK" "$(( bytes / 1024 ))"
    else
        printf "%dB" "$bytes"
    fi
}

read current_read current_write <<< $(get_io_stats)
now=$(date +%s)

if [ -f "$CACHE_FILE" ]; then
    read prev_read prev_write prev_time < "$CACHE_FILE"
    elapsed=$(( now - prev_time ))

    if (( elapsed > 0 )); then
        read_rate=$(( (current_read - prev_read) * 512 / elapsed ))
        write_rate=$(( (current_write - prev_write) * 512 / elapsed ))
        (( read_rate < 0 )) && read_rate=0
        (( write_rate < 0 )) && write_rate=0
        read_fmt=$(format_bytes $read_rate)
        write_fmt=$(format_bytes $write_rate)
        printf '{"text": "R %s / W %s", "tooltip": "Read: %s/s | Write: %s/s", "class": "io"}\n' "$read_fmt" "$write_fmt" "$read_fmt" "$write_fmt"
    else
        printf '{"text": "R 0B / W 0B", "class": "io"}\n'
    fi
else
    printf '{"text": "R 0B / W 0B", "class": "io"}\n'
fi

echo "$current_read $current_write $now" > "$CACHE_FILE"
