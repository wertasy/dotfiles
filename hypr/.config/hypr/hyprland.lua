-- Hyprland Lua 配置
-- 从 hyprland.conf 迁移而来（备份: hyprland.conf.backup）
-- 官方语法参考: https://wiki.hypr.land/Configuring/Start/
-- 注意: 0.55+ 若存在 hyprland.lua 则优先使用，不再加载 .conf。
--       回退方式: 删除本文件（或其符号链接）即可恢复使用 hyprland.conf。

------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
hl.monitor({
	output = "DP-2",
	mode = "3440x1440@144",
	position = "0x0",
	scale = 1,
})
-- hl.monitor({ output = "HEADLESS-1", mode = "1920x1080@60", position = "auto", scale = 1 })

---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal = "foot"
local fileManager = "dolphin"

-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/
-- Execute your favorite apps at launch.
-- 注: 这些命令在 hyprland 启动时执行一次，等价于旧语法的 exec-once。
hl.on("hyprland.start", function()
	hl.exec_cmd(
		"systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP && ~/.local/bin/wait-for-wayland.sh waybar.service"
	)
	hl.exec_cmd("hypridle")
	hl.exec_cmd("mako")
	hl.exec_cmd("sunshine")
	hl.exec_cmd("openrgb")
	hl.exec_cmd("localsend")
	-- hl.exec_cmd("hyprpaper")
	hl.exec_cmd("awww-daemon")
	-- hl.exec_cmd("awww img ~/.local/share/bing-wallpaper/current.jpg")
	hl.exec_cmd("foot")
	hl.exec_cmd("onedrive --monitor")
	hl.exec_cmd('hyprctl dispatch exec "[workspace 2] firefox"')
	hl.exec_cmd("fcitx5")
	hl.exec_cmd("keepassxc")
	hl.exec_cmd("blueman-applet")
	hl.exec_cmd("sleep 5 && ~/.local/bin/bt-autoconnect")
	hl.exec_cmd("wl-paste --watch cliphist store")
	hl.exec_cmd('hyprctl dispatch exec "[workspace 3] steam"')
	hl.exec_cmd('hyprctl dispatch exec "[workspace 4] thunderbird"')
	hl.exec_cmd('hyprctl dispatch exec "[workspace 5] Telegram"')
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/
hl.env("XCURSOR_SIZE", "36")
hl.env("QT_CURSOR_SIZE", "36")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1")
hl.env("QT_SCALE_FACTOR", "1")
hl.env("QT_FONT_DPI", "120")
hl.env("GTK_THEME", "Adwaita:dark")
-- env = GTK_IM_MODULE,fcitx  -- Wayland 下不设，GTK 自动用 text-input-v3
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("SDL_IM_MODULE", "fcitx")
hl.env("GLFW_IM_MODULE", "fcitx")
hl.env("LANGUAGE", "zh_CN:zh")
hl.env("LC_ALL", "zh_CN.UTF-8")
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("NVD_BACKEND", "direct")
hl.env("MOZ_DISABLE_RDD_SANDBOX", "1")
hl.env("MOZ_ENABLE_WAYLAND", "1")

-----------------------
---- LOOK AND FEEL ----
-----------------------

-- See https://wiki.hypr.land/Configuring/Basics/Variables/

-- INPUT
-- See https://wiki.hypr.land/Configuring/Basics/Variables/ for more
hl.config({
	input = {
		kb_layout = "us",
		kb_variant = "",
		kb_model = "",
		kb_options = "",
		kb_rules = "",

		-- 灵敏度：0 表示不修改原始输入。
		sensitivity = 0,
		follow_mouse = 1,
		-- 禁用加速曲线，实现 1:1 指针移动。
		accel_profile = "flat",

		touchpad = {
			natural_scroll = true,
		},
	},
})

-- GENERAL
hl.config({
	general = {
		gaps_in = 6,
		gaps_out = 12,
		border_size = 2,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},

		layout = "dwindle",

		-- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
		allow_tearing = true,
	},
})

-- DECORATION
hl.config({
	decoration = {
		rounding = 14,

		blur = {
			enabled = true,
			size = 4,
			passes = 4,
			ignore_opacity = false,
		},
	},
})

-- ANIMATIONS (enabled) + curves/animation 定义
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.config({
	animations = {
		enabled = true,
	},
})

hl.curve("myBezier", { type = "bezier", points = { { 0.05, 0.9 }, { 0.1, 1.05 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 7, bezier = "myBezier" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 7, bezier = "default", style = "popin 80%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 8, bezier = "default" })
hl.animation({ leaf = "fade", enabled = true, speed = 7, bezier = "default" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "default" })

-- DWINDLE
-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
	dwindle = {
		preserve_split = true, -- you probably want this
	},
})

-- MASTER
-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
-- hl.config({
--     master = {
--         new_status = "master",
--     },
-- })

-- SCROLLING
-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
	scrolling = {
		fullscreen_on_one_column = true,
		column_width = 0.5,
		focus_fit_method = 1,
		follow_focus = true,
		-- direction = "down",
	},
})

-- GESTURES (设置项)
-- See https://wiki.hypr.land/Configuring/Basics/Variables/ for more
hl.config({
	gestures = {
		workspace_swipe_touch = true,
	},
})

-- MISC
hl.config({
	misc = {
		force_default_wallpaper = 0,
		focus_on_activate = true,
		vrr = 0,
		mouse_move_enables_dpms = true,
		key_press_enables_dpms = true,
	},
})

--------------------------
---- GESTURE BINDINGS ----
--------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/
-- 注意: 带 mod / scale / 自定义动作(close/fullscreen)的手势语法以官方 wiki 为准；
--       若 reload 后手势不生效，请按 wiki 校对 action 字段。
hl.gesture({ fingers = 3, direction = "horizontal", action = "workspace" })
hl.gesture({ fingers = 3, direction = "down", mods = "ALT", action = "close" })
hl.gesture({ fingers = 3, direction = "up", action = "fullscreen" }) -- 原含 scale: 1.5
-- hl.gesture({ fingers = 3, direction = "down",  scale = 1.5, action = "fullscreen" })
-- hl.gesture({ fingers = 3, direction = "left",  scale = 1.5, action = "float" })

---------------------
---- KEYBINDINGS ----
---------------------

-- See https://wiki.hypr.land/Configuring/Basics/Binds/ for more
local mainMod = "SUPER" -- Sets "Windows" key as main modifier

hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("pkill -SIGUSR2 waybar"))

--
-- Mouse Toggle Floating
--

-- `Super + <Mouse Middle Click>`
hl.bind(mainMod .. " + mouse:274", hl.dsp.window.float({ action = "toggle" }))
-- `Alt + <Mouse Middle Click>`
hl.bind("ALT + mouse:274", hl.dsp.window.float({ action = "toggle" }))

-- fullscreen: 旧参数 1=maximized, 2=fullscreen, 默认=fullscreen
hl.bind("ALT + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.fullscreen({ mode = "maximized" }))

--
-- Keybind / Window Control
--
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())

-- Example binds
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("systemctl --user restart waybar.service"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("firefox"))
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo()) -- dwindle
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit")) -- dwindle

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9], move window with mainMod + SHIFT + [0-9]
for i = 1, 10 do
	local key = i % 10 -- 10 maps to key 0
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + K", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Mouse move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Swap window
hl.bind(mainMod .. " + CTRL + ALT + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + ALT + down", hl.dsp.window.swap({ direction = "down" }))
hl.bind(mainMod .. " + CTRL + ALT + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + ALT + right", hl.dsp.window.swap({ direction = "right" }))

-- Resize window (binde => repeating)
hl.bind(mainMod .. " + ALT + up", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + down", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + left", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

-- rofi 按键绑定
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("rofi -show drun"))

-- 截屏
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))

-- Switch workspaces with mainMod + CTRL + left/right
hl.bind(mainMod .. " + CTRL + left", hl.dsp.focus({ workspace = "-1" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "+1" }))

hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ workspace = "-1" }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ workspace = "+1" }), { repeating = true })

--
-- Keybind / Volume Control
--
-- 注: 长命令用 [[ ]] 包裹以原样保留引号/管道/$(...)。
hl.bind(
	"XF86AudioMute",
	hl.dsp.exec_cmd(
		[[pactl set-sink-mute @DEFAULT_SINK@ toggle && toastify send -t 1500 -c Volume Volume "$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d' ' -f 2 | sed -e 's/yes//' -e 's/no/')"  $(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')"  123]]
	)
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd(
		[[pactl set-sink-volume @DEFAULT_SINK@ -5% && toastify send -t 1500 -c Volume Volume "$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d' ' -f 2 | sed -e 's/yes//' -e 's/no/')"  $(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')"  123]]
	),
	{ repeating = true }
)
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd(
		[[pactl set-sink-volume @DEFAULT_SINK@ +5% && toastify send -t 1500 -c Volume Volume "$(pactl get-sink-mute @DEFAULT_SINK@ | cut -d' ' -f 2 | sed -e 's/yes//' -e 's/no/')"  $(pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}')"  123]]
	),
	{ repeating = true }
)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"))

--
-- Keybind / Monitor Brightness Control
--
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl set +5%"))

-- 绑定电源键到 suspend 命令
hl.bind("XF86PowerOff", hl.dsp.exec_cmd("systemctl suspend"))

hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("~/.local/scripts/bing-wallpaper.sh"))
hl.bind(mainMod .. " + CTRL + N", hl.dsp.exec_cmd("~/.local/scripts/rofi-wallpaper.sh"))

hl.bind(mainMod .. " + H", hl.dsp.exec_cmd("~/.local/scripts/clipboard.sh"))

-- 按下 SUPER + G 进入 "clean" 模式（禁用原本快捷键）
hl.bind(mainMod .. " + G", hl.dsp.submap("clean"))

-- 在 clean 模式下重新定义一个按键退出该模式（恢复原本快捷键）
hl.define_submap("clean", function()
	hl.bind(mainMod .. " + G", hl.dsp.submap("reset"))
end)

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({ match = { class = "my-window" }, border_size = 10 })

hl.window_rule({ match = { class = "org.telegram.desktop" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ" }, float = true, center = true })
hl.window_rule({ match = { class = "QQ", title = "图片查看器" }, fullscreen = true })
hl.window_rule({ match = { class = "org.keepassxc.KeePassXC" }, float = true, center = true })
hl.window_rule({ match = { class = "imv" }, float = true, center = true })
hl.window_rule({ match = { class = "nwg-look" }, float = true, center = true })
hl.window_rule({ match = { class = "org.pulseaudio.pavucontrol" }, float = true, center = true, size = { 1100, 700 } })
hl.window_rule({ match = { class = "nm-connection-editor" }, float = true, center = true })
hl.window_rule({ match = { class = "blueman-manager" }, float = true, center = true })
hl.window_rule({ match = { class = "pavucontrol" }, float = true, center = true, size = { 1100, 700 } })
hl.window_rule({ match = { class = "gnome-calculator" }, float = true, center = true })
hl.window_rule({ match = { class = "org.gnome.Calculator" }, float = true, center = true })
hl.window_rule({ match = { class = "qalculate-gtk" }, float = true, center = true })
hl.window_rule({ match = { class = "file-roller" }, float = true, center = true })
hl.window_rule({ match = { class = "engrampa" }, float = true, center = true })
hl.window_rule({ match = { class = "xdg-desktop-portal-gtk" }, float = true, center = true })
hl.window_rule({ match = { class = "gnome-control-center" }, float = true, center = true })
hl.window_rule({ match = { class = "org.gnome.Nautilus", title = "Properties" }, float = true, center = true })
hl.window_rule({ match = { class = "thunar", title = "File Operation Progress" }, float = true, center = true })
hl.window_rule({ match = { class = "dolphin", title = "Properties" }, float = true, center = true })
hl.window_rule({ match = { class = "pamac-manager" }, float = true, center = true })
hl.window_rule({ match = { class = "pamac-installer" }, float = true, center = true })
hl.window_rule({ match = { class = "gnome-system-monitor" }, float = true, center = true })
hl.window_rule({ match = { class = "ksysguard" }, float = true, center = true })
hl.window_rule({ match = { class = "gnome-disk-utility" }, float = true, center = true })
hl.window_rule({ match = { title = "Picture-in-Picture" }, float = true, center = true })
hl.window_rule({ match = { title = "File Transfer" }, float = true, center = true })
hl.window_rule({ match = { title = "Files Transfer" }, float = true, center = true })
hl.window_rule({ match = { title = "Copying" }, float = true, center = true })
hl.window_rule({ match = { title = "Moving" }, float = true, center = true })
hl.window_rule({ match = { title = "Deleting" }, float = true, center = true })
hl.window_rule({ match = { class = "evince", title = "Properties" }, float = true, center = true })
hl.window_rule({ match = { class = "atril", title = "Properties" }, float = true, center = true })
hl.window_rule({ match = { class = "libreoffice", title = "About LibreOffice" }, float = true, center = true })
hl.window_rule({ match = { class = "soffice", title = "About LibreOffice" }, float = true, center = true })
hl.window_rule({ match = { class = "zoom" }, float = true, center = true })
hl.window_rule({ match = { class = "zoom-us" }, float = true, center = true })
hl.window_rule({ match = { class = "Microsoft Teams - Preview" }, float = true, center = true })
hl.window_rule({ match = { class = "teams-for-linux" }, float = true, center = true })
hl.window_rule({ match = { class = "discord", title = "Discord Updater" }, float = true, center = true })
hl.window_rule({ match = { class = "vlc", title = "Preferences" }, float = true, center = true })
hl.window_rule({ match = { class = "mpv", title = "Media Viewer" }, float = true, center = true })
hl.window_rule({ match = { class = "gimp-2.10", title = "Preferences" }, float = true, center = true })
hl.window_rule({ match = { class = "inkscape", title = "Preferences" }, float = true, center = true })
hl.window_rule({ match = { class = "virt-manager" }, float = true, center = true })
hl.window_rule({ match = { class = "Virtual Machine Manager" }, float = true, center = true })
hl.window_rule({ match = { class = "Code" }, float = true, center = true })

hl.window_rule({ match = { class = "fcitx" }, float = true, center = true })
hl.window_rule({ match = { class = "piper" }, float = true, center = true })
hl.window_rule({ match = { class = "localsend" }, float = true, center = true })
hl.window_rule({ match = { class = "org.openrgb.OpenRGB" }, float = true, center = true })
hl.window_rule({ match = { class = "Stardew Valley" }, float = true, center = true })

hl.window_rule({ match = { class = "steam", title = "Friends List" }, float = true, center = true })
hl.window_rule({ match = { class = "steam", title = "好友列表" }, float = true, center = true })
hl.window_rule({ match = { class = "OneDriveGUI" }, float = true, center = true })
hl.window_rule({ match = { class = "firefox", initial_title = "画中画" }, float = true, center = true, pin = true })

-- workspace = 7, monitor:DP-1
hl.workspace_rule({ workspace = "7", monitor = "DP-1" })

-- 启用透明窗口效果
