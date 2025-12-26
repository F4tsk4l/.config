-- ~/.config/awesome/theme.lua

local gears = require("gears")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local theme = {}

-- Font
theme.font = "FiraCode Nerd Font 10"

-- Colors
theme.bg_normal = "#1e1e2e"
theme.bg_focus = "#313244"
theme.bg_urgent = "#f38ba8"
theme.bg_minimize = "#44475a"
theme.fg_normal = "#cdd6f4"
theme.fg_focus = "#f5e0dc"
theme.fg_urgent = "#1e1e2e"
theme.fg_minimize = "#bbbbbb"

-- Gaps/borders
theme.useless_gap = dpi(8)
theme.border_width = dpi(2)
theme.border_normal = "#1e1e2e"
theme.border_focus = "#f38ba8"
theme.border_marked = "#ff0000"

-- Rounded corners
theme.corner_radius = dpi(8)

-- Optional wallpaper
-- theme.wallpaper = "~/.config/awesome/wallpapers/catppuccin.png"

return theme

