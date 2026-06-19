#!/bin/bash
# PipeWire RT 优先级配置安装脚本

set -e

echo "检查系统级配置..."
if [ ! -f /etc/systemd/system/user@.service.d/audio-limits.conf ]; then
    echo "系统级配置未安装（需要 root）"
    echo "运行：sudo bash scripts/.local/scripts/install-pipewire-rt-config.sh"
else
    echo "✓ 系统级配置已存在"
fi

# 删除冗余配置
if [ -f ~/.config/pipewire/pipewire.conf.d/quantum.conf ]; then
    mv ~/.config/pipewire/pipewire.conf.d/quantum.conf ~/.config/pipewire/pipewire.conf.d/quantum.conf.bak
    echo "✓ 已备份 quantum.conf"
fi

# 重新加载用户服务
systemctl --user daemon-reload
echo "✓ 服务已重新加载"

echo ""
echo "配置完成！"
