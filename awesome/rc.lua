-- ~/.config/awesome/rc.lua
-- Entry point for Awesome WM config, ported from user's XMonad setup

pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- Add all custom Lua module paths
package.path = os.getenv("HOME")
	.. "/.config/awesome/?.lua;"
	.. os.getenv("HOME")
	.. "/.config/awesome/ui/?.lua;"
	.. os.getenv("HOME")
	.. "/.config/awesome/bling/?.lua;"
	.. package.path

local bling = require("bling")

-- Load theme
beautiful.init(require("theme"))

-- Import main modules
require("autostart")
local keys = require("keybindings")
require("layouts")
require("rules")
require("scratchpads")
require("ui.bar")

-- Set default terminal and editor
awful.util.terminal = "kitty"
awful.util.editor = os.getenv("EDITOR") or "nvim"

-- Tags (Workspaces)
awful.screen.connect_for_each_screen(function(s)
	awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 " }, s, awful.layout.layouts[1])
end)

-- Set keys globally
root.keys(keys.globalkeys)
