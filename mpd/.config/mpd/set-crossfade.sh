#!/bin/bash
# MPD Crossfade 自动设置脚本

# 等待 MPD 启动
for i in {1..10}; do
    if timeout 1 bash -c 'echo "ping" | nc localhost 6600 2>/dev/null' | grep -q OK; then
        break
    fi
    sleep 0.5
done

# 设置 crossfade 参数
mpc crossfade 2
mpc mixrampdb -12
mpc mixrampdelay nan

echo "MPD crossfade configured: 2s, mixrampdb -12dB"