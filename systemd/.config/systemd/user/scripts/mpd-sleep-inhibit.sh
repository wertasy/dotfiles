#!/bin/bash
MPD_HOST="${MPD_HOST:-localhost}"
MPD_PORT="${MPD_PORT:-6600}"

inhibit_pid=""

mpd_is_playing() {
    echo -e "status\nclose" | nc -q 1 "$MPD_HOST" "$MPD_PORT" 2>/dev/null | grep -q "^state: play"
}

mpd_wait_change() {
    echo -e "idle player\nclose" | nc -q 1 "$MPD_HOST" "$MPD_PORT" >/dev/null 2>&1
}

cleanup() {
    [ -n "$inhibit_pid" ] && kill "$inhibit_pid" 2>/dev/null
}
trap cleanup EXIT

while true; do
    if mpd_is_playing; then
        [ -z "$inhibit_pid" ] || ! kill -0 "$inhibit_pid" 2>/dev/null && {
            systemd-inhibit --what=sleep --who="mpd" --why="Music playing" --mode=block sleep infinity &
            inhibit_pid=$!
        }
    else
        [ -z "$inhibit_pid" ] || kill "$inhibit_pid" 2>/dev/null
        inhibit_pid=""
    fi
    mpd_wait_change
done
