#!/bin/bash
status=$(playerctl status 2>/dev/null)
if [ "$status" = "Playing" ]; then
    echo '{"text": "⏸", "class": "playing", "tooltip": "暂停"}'
elif [ "$status" = "Paused" ]; then
    echo '{"text": " ", "class": "paused", "tooltip": "播放"}'
else
    echo '{"text": " ", "class": "stopped", "tooltip": "无媒体"}'
fi
