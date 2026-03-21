#!/bin/bash

options=$'󰍃 注销 logout\n󰤄 待机 suspend\n⏻ 关机 poweroff\n󰜉 重启 reboot\n󰤂 休眠 hibernate'
choice=$(echo -e "$options" | fuzzel --dmenu --prompt='电源: ' --lines=5)

case "$choice" in
    *注销*|*logout*) hyprctl dispatch exit ;;
    *待机*|*suspend*) systemctl suspend ;;
    *关机*|*poweroff*) systemctl poweroff ;;
    *重启*|*reboot*) systemctl reboot ;;
    *休眠*|*hibernate*) systemctl hibernate ;;
esac
