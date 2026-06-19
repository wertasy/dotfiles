# PipeWire RT 优先级配置 - Dotfiles 迁移

## 添加到 Dotfiles 的文件

### 新增文件

1. **wireplumber/.config/wireplumber/wireplumber.conf.d/rt.conf**
   - RT 优先级配置（90）
   - 禁用 rtkit，启用 rtlimits

2. **wireplumber/.config/wireplumber/wireplumber.conf.d/bluetooth-codec.conf**
   - 蓝牙编解码器配置
   - LDAC 优先 + A2DP 延迟优化

3. **pipewire/.config/pipewire/pipewire-pulse.conf**
   - 完整 PipeWire-Pulse 配置
   - 启用 node.autoconnect

### 更新文件

4. **pipewire/.config/pipewire/pipewire.conf.d/rt.conf**
   - 替换旧的 rt-module.conf
   - 统一 RT 模块配置

5. **systemd/.config/systemd/user/*.override.conf**
   - 添加 NoNewPrivileges=no
   - 更新为完整权限配置

6. **systemd/etc-systemd-system/user@.service.d/audio-limits.conf**
   - 系统级 RT 限制（需要 sudo 安装）

### 脚本

7. **scripts/.local/scripts/install-pipewire-rt-config.sh**
   - 安装系统级配置的 sudo 脚本

8. **setup-rt-priority.sh**
   - 一键安装脚本（包含备份）

9. **README.md** (pipewire/ 和 wireplumber/)
   - 配置说明文档

## 安装方法

### 1. 用户配置（Stow）

```bash
cd ~/dotfiles
stow -R --adopt pipewire
stow -R --adopt wireplumber
stow -R --adopt systemd
```

### 2. 系统配置（需要 root）

```bash
sudo bash scripts/.local/scripts/install-pipewire-rt-config.sh
```

或运行一键脚本：
```bash
bash setup-rt-priority.sh
```

## 配置验证

### 检查符号链接

```bash
ls -l ~/.config/pipewire/pipewire-pulse.conf
ls -l ~/.config/wireplumber/wireplumber.conf.d/rt.conf
```

### 验证 RT 优先级

```bash
ps -eLo pid,tid,cls,rtprio,comm | grep data-loop
```

预期结果：
- PipeWire data-loop: 88
- WirePlumber data-loop: 90 ✅
- PipeWire-Pulse data-loop: 90 ✅

### 测试游戏音频

1. 运行 DOTA2
2. 检查声音是否正常
3. 确认无卡顿

## 文件结构

```
~/dotfiles/
├── wireplumber/
│   └── .config/wireplumber/wireplumber.conf.d/
│       ├── rt.conf
│       └── bluetooth-codec.conf
├── pipewire/
│   ├── .config/pipewire/
│   │   ├── pipewire.conf.d/rt.conf
│   │   └── pipewire-pulse.conf
│   └── README.md
├── systemd/
│   ├── .config/systemd/user/
│   │   ├── pipewire.service.d/override.conf
│   │   ├── wireplumber.service.d/override.conf
│   │   └── pipewire-pulse.service.d/override.conf
│   └── etc-systemd-system/
│       └── user@.service.d/
│           └── audio-limits.conf
├── scripts/
│   └── .local/scripts/install-pipewire-rt-config.sh
└── setup-rt-priority.sh
```

## 清理冗余配置

已删除/备份：
- `pipewire.conf.d/rt-module.conf` (替换为 rt.conf)
- `pipewire.conf.d/quantum.conf` (已被 RT 配置替代)
- `pipewire.service.d/rt-prio.conf` (合并到 override.conf)

## 备份文件

```
~/.config/pipewire/pipewire-pulse.conf.backup
~/.config/pipewire/pipewire.conf.d/rt.conf.backup
~/.config/wireplumber/wireplumber.conf.d/rt.conf.backup
~/.config/wireplumber/wireplumber.conf.d/bluetooth-codec.conf.backup
```

## 相关技能

- [pipewire-rt-priority-fix](pipewire-rt-priority-fix/SKILL.md) - 完整配置指南
- [rtw89-wifi-disconnect-fix](rtw89-wifi-disconnect-fix/SKILL.md) - Realtek WiFi 修复

## 注意事项

1. **系统配置需要 root**：`audio-limits.conf` 必须放在 `/etc` 目录
2. **NoNewPrivileges 必须为 no**：否则服务无法提升优先级
3. **重启服务生效**：修改后需要 `systemctl --user daemon-reload`
4. **游戏需重启**：启用 autoconnect 后游戏音频流才能正确路由

## 故障排除

### 游戏无声音

检查 `pipewire-pulse.conf` 中的 `stream.properties`：
```lua
stream.properties = {
    node.autoconnect = true  # 必须启用
}
```

### 优先级未生效

检查 systemd override：
```bash
cat ~/.config/systemd/user/pipewire.service.d/override.conf
# 应该包含 NoNewPrivileges=no
```

### 服务启动失败

查看日志：
```bash
journalctl --user -u pipewire-pulse
```

## 更新日期

2026-05-30
