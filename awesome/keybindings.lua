
-- ~/.config/awesome/keybindings.lua

local awful = require("awful")
local gears = require("gears")
local modkey = "Mod4"

local function spawnHere(cmd)
  awful.spawn(cmd, { tag = awful.screen.focused().selected_tag })
end

local globalkeys = gears.table.join(
  -- Launch terminal
  awful.key({ modkey, "Shift" }, "Return", function() spawnHere("kitty") end,
            { description = "launch terminal", group = "launcher" }),

  -- dmenu
  awful.key({ modkey }, "d", function() awful.spawn("dmenu_run") end,
            { description = "launch dmenu", group = "launcher" }),

  -- lockscreen
  awful.key({ modkey, "Control" }, "l", function()
    awful.spawn.with_shell("i3lock --radius 100 -eki ~/Saver/shaded_landscape.png -F --ring-width 3 --time-str='%H:%M' && echo mem > /sys/power/state")
  end, { description = "lock and suspend", group = "system" }),

  -- close focused window
  awful.key({ modkey, "Shift" }, "q", function() client.focus:kill() end,
            { description = "close window", group = "client" }),
  awful.key({ "Control" }, "w", function() client.focus:kill() end,
            { description = "close window", group = "client" }),

  -- switch layout
  awful.key({ modkey }, "space", function() awful.layout.inc(1) end,
            { description = "next layout", group = "layout" }),
  awful.key({ modkey, "Shift" }, "space", function() awful.layout.set(awful.layout.layouts[1]) end,
            { description = "reset layout", group = "layout" }),

  -- restart/refresh
  awful.key({ modkey }, "r", awesome.restart,
            { description = "reload awesome", group = "awesome" }),

  -- focus
  awful.key({ modkey }, "Tab", function() awful.client.focus.byidx(1) end,
            { description = "focus down", group = "client" }),
  awful.key({ modkey }, "j", function() awful.client.focus.byidx(1) end,
            { description = "focus down", group = "client" }),
  awful.key({ modkey }, "k", function() awful.client.focus.byidx(-1) end,
            { description = "focus up", group = "client" }),
  awful.key({ modkey }, "m", function() client.focus:raise() end,
            { description = "focus master", group = "client" }),

  -- master swap
  awful.key({ modkey }, "Return", function() awful.client.swap.byidx(0) end,
            { description = "swap with master", group = "client" }),
  awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
            { description = "swap down", group = "client" }),
  awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
            { description = "swap up", group = "client" }),

  -- resize
  awful.key({ modkey }, "h", function() awful.tag.incmwfact(-0.05) end,
            { description = "shrink master", group = "layout" }),
  awful.key({ modkey }, "l", function() awful.tag.incmwfact(0.05) end,
            { description = "expand master", group = "layout" }),

  -- restore tiling
  awful.key({ modkey }, "t", function(c) awful.client.floating.set(c, false) end,
            { description = "sink window", group = "client" }),

  -- change number of master clients
  awful.key({ modkey }, "comma", function() awful.tag.incnmaster(1, nil, true) end,
            { description = "increase master count", group = "layout" }),
  awful.key({ modkey }, "period", function() awful.tag.incnmaster(-1, nil, true) end,
            { description = "decrease master count", group = "layout" }),

  -- Opacity scripts
  awful.key({ modkey, "Shift" }, "Down", function()
    awful.spawn("opacity_down.sh")
  end, { description = "decrease opacity", group = "client" }),

  awful.key({ modkey, "Shift" }, "Up", function()
    awful.spawn("opacity_up.sh")
  end, { description = "increase opacity", group = "client" }),

  -- Power menu
  awful.key({ modkey, "Shift" }, "c", function() awful.spawn("~/.local/bin/powermenu") end,
            { description = "power menu", group = "system" }),

  -- Apps
  awful.key({ modkey, "Shift" }, "v", function() awful.spawn("jamesdsp -t") end,
            { description = "toggle JamesDSP", group = "apps" }),
  awful.key({ modkey }, "n", function() spawnHere("nemo") end,
            { description = "file manager", group = "apps" }),
  awful.key({ modkey }, "p", function() awful.spawn("deadd") end,
            { description = "deadd-notification-center", group = "apps" }),

  -- Browsers
  awful.key({ modkey, "Shift" }, "f", function() spawnHere("firefox") end, {}),
  awful.key({ modkey, "Shift" }, "b", function() spawnHere("brave") end, {}),
  awful.key({ modkey, "Control" }, "b", function() awful.spawn("brave --incognito") end, {}),
  awful.key({ modkey, "Shift" }, "l", function() spawnHere("librewolf") end, {}),

  -- Screenshots
  awful.key({ "Mod1" }, "Print", function() awful.spawn("flameshot gui") end, {}),
  awful.key({}, "Print", function() awful.spawn.with_shell("maim $HOME/Pictures/Maimshts/Full/$(date +%s).png") end, {}),
  awful.key({ "Shift" }, "Print", function() awful.spawn.with_shell("maim --select $HOME/Pictures/Maimshts/Selection/$(date +%s).png") end, {}),
  awful.key({ "Control" }, "Print", function() awful.spawn.with_shell("maim -i $(xdotool getactivewindow) -B $HOME/Pictures/Maimshts/ActiveW/$(date +%s).png") end, {}),

  -- Morc menu & pavucontrol
  awful.key({ modkey }, "z", function() awful.spawn("morc_menu") end, {}),
  awful.key({ modkey, "Control" }, "m", function() awful.spawn("pavucontrol") end, {})
)

-- Workspace bindings
for i = 1, 9 do
  globalkeys = gears.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9, function()
      local tag = awful.screen.focused().tags[i]
      if tag then tag:view_only() end
    end, { description = "view tag #" .. i, group = "tag" }),

    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
      if client.focus then
        local tag = client.focus.screen.tags[i]
        if tag then client.focus:move_to_tag(tag) end
      end
    end, { description = "move focused to tag #" .. i, group = "tag" })
  )
end

return {
  globalkeys = globalkeys
}
