#!/bin/bash
# Rofi Clipboard History
# 需要 cliphist 或类似工具

if ! command -v cliphist &> /dev/null; then
    rofi -e "需要安装 cliphist\nyay -S cliphist"
    exit 1
fi

# 显示剪贴板历史并选择（使用列表布局）
SELECTED=$(cliphist list | \
    rofi -dmenu -i -p "剪贴板" \
    -theme-str "listview {lines: 15; columns: 1;}" \
    -theme-str "window {width: 700px; height: 600px;}" \
    -theme-str "element {padding: 8px 12px;}" \
    -theme-str "element-text {text-transform: none;}" \
    -theme-str "element-icon {str: \"\";}" \
)

if [ -n "$SELECTED" ]; then
    echo "$SELECTED" | cliphist decode | cliphist copy
fi
