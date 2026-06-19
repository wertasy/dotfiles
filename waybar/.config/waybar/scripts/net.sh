#!/bin/bash
CACHE_FILE="/tmp/waybar-net-prev"

get_net_stats() {
    awk '$1 !~ /^lo:/ && $1 !~ /^face:/ {
        rx += $2
        tx += $10
    } END {
        print rx+0, tx+0
    }' /proc/net/dev
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

read current_rx current_tx <<< $(get_net_stats)
now=$(date +%s)

if [ -f "$CACHE_FILE" ]; then
    read prev_rx prev_tx prev_time < "$CACHE_FILE"
    elapsed=$(( now - prev_time ))

    if (( elapsed > 0 )); then
        rx_rate=$(( (current_rx - prev_rx) / elapsed ))
        tx_rate=$(( (current_tx - prev_tx) / elapsed ))
        (( rx_rate < 0 )) && rx_rate=0
        (( tx_rate < 0 )) && tx_rate=0
        rx_fmt=$(format_bytes $rx_rate)
        tx_fmt=$(format_bytes $tx_rate)
        printf '{"text": "U %s / D %s", "tooltip": "Upload: %s/s | Download: %s/s", "class": "net"}\n' "$tx_fmt" "$rx_fmt" "$tx_fmt" "$rx_fmt"
    else
        printf '{"text": "U 0B / D 0B", "class": "net"}\n'
    fi
else
    printf '{"text": "U 0B / D 0B", "class": "net"}\n'
fi

echo "$current_rx $current_tx $now" > "$CACHE_FILE"
