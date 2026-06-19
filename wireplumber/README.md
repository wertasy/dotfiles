# WirePlumber 配置

## 文件说明

- `rt.conf` - RT 优先级配置
- `bluetooth-codec.conf` - 蓝牙音频配置

## 安装

使用 Stow 安装：
```bash
cd ~/dotfiles
stow wireplumber
```

## 配置说明

### RT 优先级
- 与 PipeWire 保持一致（优先级 90）
- 使用 rtlimits 模块

### 蓝牙音频
- 优先使用 LDAC 编解码器
- 启用 SBC-XQ 和 mSBC
- 增加 A2DP 延迟余量（缓解 Realtek 丢包）
- 自动激活 A2DP/HFP/HSP 配置文件

## 相关技能

- [rtw89-wifi-disconnect-fix](../rtw89-wifi-disconnect-fix/SKILL.md) - Realtek WiFi 问题
