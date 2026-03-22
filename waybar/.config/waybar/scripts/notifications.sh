#!/bin/sh

count=$(makoctl list | jq '.data | length' 2>/dev/null || echo 0)

if [ "$count" -gt 0 ]; then
    printf '{"text": "%s", "alt": "notification", "class": "notification"}' "$count"
else
    printf '{"text": "", "alt": "none", "class": "none"}'
fi
