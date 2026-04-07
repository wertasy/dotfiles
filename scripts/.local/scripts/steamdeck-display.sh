#!/bin/bash

STEAMDECK_RES="1280x800"
STEAMDECK_REFRESH="60"
HEADLESS_NAME="HEADLESS-1"

case "$1" in
    create)
        if hyprctl monitors -j | python3 -c "import json,sys; data=json.load(sys.stdin); sys.exit(0 if any(m['name'].startswith('HEADLESS') for m in data) else 1)"; then
            echo "Virtual display already exists"
            exit 0
        fi

        hyprctl output create headless
        sleep 0.5

        HEADLESS=$(hyprctl monitors -j | python3 -c "import json,sys; [print(m['name']) for m in json.load(sys.stdin) if m['name'].startswith('HEADLESS')]")
        if [ -z "$HEADLESS" ]; then
            echo "Failed to create headless output"
            exit 1
        fi

        hyprctl keyword monitor "$HEADLESS, ${STEAMDECK_RES}@${STEAMDECK_REFRESH}, auto, 1"
        echo "Virtual display $HEADLESS created at ${STEAMDECK_RES}@${STEAMDECK_REFRESH}Hz"
        ;;
    remove)
        HEADLESS=$(hyprctl monitors -j | python3 -c "import json,sys; [print(m['name']) for m in json.load(sys.stdin) if m['name'].startswith('HEADLESS')]")
        if [ -z "$HEADLESS" ]; then
            echo "No virtual display found"
            exit 0
        fi
        hyprctl output remove "$HEADLESS"
        echo "Virtual display $HEADLESS removed"
        ;;
    status)
        HEADLESS=$(hyprctl monitors -j | python3 -c "import json,sys; [print(m['name']) for m in json.load(sys.stdin) if m['name'].startswith('HEADLESS')]" 2>/dev/null)
        if [ -n "$HEADLESS" ]; then
            echo "Virtual display active: $HEADLESS ($STEAMDECK_RES)"
        else
            echo "No virtual display"
        fi
        ;;
    *)
        echo "Usage: $0 {create|remove|status}"
        exit 1
        ;;
esac
