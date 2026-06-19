#!/bin/bash
# 安装系统级 PipeWire RT 优先级配置
# 需要 root 权限

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${SCRIPT_DIR}/../../../systemd"

if [ "$EUID" -ne 0 ]; then
    echo "错误：此脚本需要 root 权限"
    echo "请使用 sudo 运行: sudo $0"
    exit 1
fi

echo "安装系统级 PipeWire RT 优先级配置..."

# 创建配置目录
mkdir -p /etc/systemd/system/user@.service.d

# 复制配置文件
if [ -f "${CONFIG_DIR}/etc-systemd-system-user@.service.d/audio-limits.conf" ]; then
    cp "${CONFIG_DIR}/etc-systemd-system-user@.service.d/audio-limits.conf" \
       /etc/systemd/system/user@.service.d/audio-limits.conf
    echo "✓ 已安装 audio-limits.conf"
else
    echo "错误：配置文件不存在"
    exit 1
fi

# 重新加载 systemd
systemctl daemon-reload

echo "✓ 安装完成！"
echo ""
echo "注意：此配置影响所有用户会话。"
echo "需要重启用户会话或重新登录才能生效。"
