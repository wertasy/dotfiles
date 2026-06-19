# PipeWire 配置

## 文件说明

- `pipewire.conf.d/rt.conf` - RT 优先级配置（rtlimits 模块）
- `pipewire-pulse.conf` - PipeWire-Pulse 完整配置（包含 autoconnect）

## 安装

使用 Stow 安装：
```bash
cd ~/dotfiles
stow pipewire
```

## 配置说明

### RT 优先级
- 禁用 rtkit（Arch 硬编码限制）
- 启用 rtlimits 模块
- 请求优先级：90

### PipeWire-Pulse
- 完整配置覆盖系统默认
- 启用 `node.autoconnect` 确保音频流自动路由
- RT 模块配置与主服务一致

## 相关文件

systemd 服务 override 在 `systemd/.config/systemd/user/` 目录。

## 参见

- [pipewire-rt-priority-fix](../pipewire-rt-priority-fix/SKILL.md)
