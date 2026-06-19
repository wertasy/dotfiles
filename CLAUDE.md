# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 仓库性质

个人 Linux 桌面 dotfiles，目标环境为 **Hyprland (Wayland) + Arch Linux**，locale 为 `zh_CN.UTF-8`。涵盖窗口管理器、音频管线、壁纸系统、shell、编辑器及一批 systemd 用户服务。**根目录 `README.md` 已过时**（提到的 cargo/emacs/fish/htop/yay 等包并不存在），以本文件和各子目录的 `README.md` 为准。

## 核心模型：GNU Stow 符号链接农场

所有配置通过 **GNU Stow** 管理。仓库根目录的每个子目录就是一个 "package"，其**内部路径结构完整镜像 `$HOME`**：

```
nvim/.config/nvim/...        → ~/.config/nvim/...
zsh/.zshrc                   → ~/.zshrc
scripts/.local/scripts/...   → ~/.local/scripts/...
systemd/.config/systemd/user → ~/.config/systemd/user
```

改动规则：
- 新增/修改某 package 内的文件后，需要 `stow -R <package>`（或 `./setup.sh` 全量 restow）让符号链接生效。
- 文件**必须**放在正确镜像路径下，否则 stow 会链接到错误位置。
- 新增 package 时直接在根目录建同名子目录，`setup.sh` 会自动遍历 stow。

## 常用命令

```bash
# 安装/重新部署单个 package
cd ~/dotfiles && stow -R <package>

# 全量 restow 所有 package（setup.sh 内部即遍历执行 stow -R）
./setup.sh
# 注意：setup.sh 还会额外 enable 并 start 两个 systemd timer：
#   bing-wallpaper.timer、wallpaper-rotate.timer

# 移除某 package 的符号链接
stow -D <package>

# 采用已有文件（把 $HOME 中已存在的真实文件纳入仓库管理）
stow -R --adopt <package>

# 安装 PipeWire RT 优先级的「系统级」配置（需要 sudo，见下文）
sudo bash scripts/.local/scripts/install-pipewire-rt-config.sh
# 或一键脚本（含备份）：bash setup-rt-priority.sh

# 重新加载用户级 systemd 后让服务/override 生效
systemctl --user daemon-reload
```

没有构建/测试/CI 流程——这是纯配置仓库。

## 架构：自定义多房间音频管线（Snapcast）

这是仓库中最复杂的自定义部分，跨 `systemd/`、`pipewire/`、`wireplumber/`、`mpd/` 多个 package，依赖一组**不在本仓库内**的外部脚本。服务依赖链：

```
pipewire* → snapcast-virtual-sink.service → parecord-snapcast.service
                  (创建虚拟 sink)              (录制到 Snapcast FIFO，Restart=always)
mpd.service → mpd-crossfade.service (oneshot，启动后设置淡入淡出)
```

- `snapcast-virtual-sink.service`、`parecord-snapcast.service`、`mpd-crossfade.service` 等 ExecStart 指向 `~/.local/bin/` 下的脚本（`snapcast-virtual-sink`、`parecord-snapcast.sh`、`set-crossfade.sh`），其中部分**不归本仓库管理**——改动音频管线前先确认这些外部脚本的存在与内容。
- Hyprland autostart 还引用了 `~/.local/bin/wait-for-wayland.sh`、`~/.local/bin/bt-autoconnect`，同样不在仓库内。

## 架构：PipeWire / WirePlumber RT 优先级子系统

为降低音频延迟（游戏无卡顿），分为**用户级**和**系统级**两层，配置分散在多处，详见 `PIPEWIRE-RT-SETUP.md`：

- **用户级（Stow 管理）**：`pipewire/.config/pipewire/pipewire.conf.d/rt.conf`、`pipewire-pulse.conf`（启用 `node.autoconnect`）；`wireplumber/.../*.conf`（RT 优先级 90、蓝牙 LDAC/SBC-XQ/mSBC 优先）。
- **systemd override**：`systemd/.config/systemd/user/{pipewire,pipewire-pulse,wireplumber}.service.d/override.conf` —— **`NoNewPrivileges=no` 是必需的**，否则服务无法提升 RT 优先级。
- **系统级（需 root，手动安装）**：`systemd/etc-systemd-system/user@.service.d/audio-limits.conf` → 由 `install-pipewire-rt-config.sh` 复制到 `/etc/systemd/system/...`。

验证优先级：`ps -eLo pid,tid,cls,rtprio,comm | grep data-loop`（期望 WirePlumber/PipeWire-Pulse 为 90，PipeWire 为 88）。

## 架构：壁纸系统

由三个脚本 + 两个 systemd timer + 一个状态文件组成，统一操作 `~/Pictures/Wallpapers/current.jpg` 这个符号链接：

- `bing-wallpaper.sh`：从 Bing 拉取每日壁纸（多个市场，UHD 分辨率）。
- `wallpaper-rotate.sh`：对本地图库做 Fisher-Yates 洗牌，用 `~/.local/state/wallpaper-playlist` 持久化播放列表（首行是文件清单指纹，用于检测增删后重建）。设置壁纸用 `awww`（swww 的 fork，优先）或 `swww`。
- `rofi-wallpaper.sh`：rofi 选择器，使用自定义主题 `~/.config/rofi/wallpaper-preview.rasi`。
- `bing-wallpaper.timer` / `wallpaper-rotate.timer` 由 `setup.sh` 自动 enable+start。

## 架构：Hyprland 配置（Lua）

`hypr/.config/hypr/hyprland.lua` —— Hyprland 0.55+ 若存在 `.lua` 则**优先于 `.conf`** 加载。本仓库已从 `hyprland.conf` 迁移到 Lua（使用 `hl.monitor`/`hl.on`/`hl.exec_cmd` 等 Lua API），旧配置备份在 `hyprland.conf.backup`。autostart 全部写在 `hl.on("hyprland.start", ...)` 回调里（等价于旧 `exec-once`），并在启动时 `import-environment WAYLAND_DISPLAY` 供后续 waybar 等服务使用。

## 架构：Shell 与编辑器

- **zsh**：Powerlevel10k + fzf-tab + 一组从 `/usr/share/zsh/plugins/` 加载的系统级插件（zsh-autosuggestions / syntax-highlighting / history-substring-search，**不在仓库管理**）。`zsh/.p10k.zsh` 为主题配置。
- **nvim**：基于 **AstroNvim**（`lazy-lock.json` 锁定版本，`lua/plugins/` 为用户插件覆盖层，`lua/community.lua` 启用语言/工具社区包）。

## 重要约定与陷阱

- **`.gitignore` 全局忽略 `*.json` 与 `*.toml`**，仅对 `.config/sunshine/apps.json` 做白名单放行（`!.config/sunshine/apps.json`）。新增任何 JSON/TOML 配置文件必须显式加白名单例外，否则 `git add` 会静默跳过。
- **敏感数据 / 凭证**：访问令牌等凭证存放在 `~/.config/zsh/secrets.zsh`（**不纳入仓库、不受 stow 管理**），由 `.zshrc` 以 `[ -f ~/.config/zsh/secrets.zsh ] && source ~/.config/zsh/secrets.zsh` 加载。新增任何凭证一律放这里，**不要写进 `.zshrc` 或仓库内任何文件**。注：早期版本曾把 `GITHUB_TOKEN`/`HF_TOKEN` 明文提交进 git 历史（commit `a17daee`），旧值仍需在各平台轮换/吊销。
- **`~/.zshrc` 已脱离 stow**：`~/.zshrc` 是真实文件（非符号链接），内容比仓库 `zsh/.zshrc` 更新（PATH、镜像源等），二者并不一致；而 `~/.zprofile`、`~/.p10k.zsh` 仍是正常符号链接。改动 `.zshrc` 时注意这一差异。
- SSH 私钥、known_hosts、各 `.log`/缓存已在 `.gitignore` 中排除。
- locale 为中文环境，仓库内文档均为中文；新增文档请保持一致。
- 部署到新机器后，Firefox `user.js` 需手动建立指向具体 profile 的符号链接（见 `setup.sh` 末尾提示）。
