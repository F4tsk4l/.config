local mp = require("mp")
local msg = require("mp.msg")
local opt = require("mp.options")

-- mpv Lua script that adds keybindings to zoom in and out and pan with a mouse
--
-- Keybindings:
--   Alt+MBTN_LEFT: hold and drag to pan
--   Alt+WHEEL_UP: zoom in
--   Alt+WHEEL_DOWN: zoom out
--   Shift+Alt+WHEEL_UP: zoom in (fine)
--   Shift+Alt+WHEEL_DOWN: zoom out (fine)

local options = {
	zoom_step = 0.075,
	zoom_step_fine = 0.025,
	update_fps = 60,
}

opt.read_options(options)

local drag_active = false
local timer = nil
local initial_mouse = { x = 0, y = 0 }
local initial_pan = { x = 0, y = 0 }

local function drag_pan_update()
	if not drag_active then
		return
	end

	local mouse = mp.get_property_native("mouse-pos")
	local osd_width = mp.get_property_number("osd-width", 1280)
	local osd_height = mp.get_property_number("osd-height", 720)
	local current_zoom = mp.get_property_number("video-zoom", 0)
	local video_aspect = mp.get_property_number("video-params/aspect", 1)

	local osd_aspect = osd_width / osd_height
	local dx = (mouse.x - initial_mouse.x) / osd_width
	local dy = (mouse.y - initial_mouse.y) / osd_height
	local x_multiplier = math.max(osd_aspect / video_aspect, 1) / 2 ^ current_zoom
	local y_multiplier = math.max(video_aspect / osd_aspect, 1) / 2 ^ current_zoom
	local new_pan_x = initial_pan.x + dx * x_multiplier
	local new_pan_y = initial_pan.y + dy * y_multiplier

	mp.set_property_number("video-pan-x", new_pan_x)
	mp.set_property_number("video-pan-y", new_pan_y)
end

local function drag_pan_end()
	drag_active = false
	if timer then
		timer:kill()
		timer = nil
	end
end

local function drag_pan_init()
	if drag_active then
		drag_pan_end()
		return
	end

	drag_active = true
	initial_mouse = mp.get_property_native("mouse-pos") or { x = 0, y = 0 }
	initial_pan.x = mp.get_property_number("video-pan-x", 0)
	initial_pan.y = mp.get_property_number("video-pan-y", 0)
	if timer then
		timer:kill()
	end
	timer = mp.add_periodic_timer(1 / options.update_fps, drag_pan_update)
end

local function zoom(inward, zoom_delta)
	local mouse = mp.get_property_native("mouse-pos")
	local osd_width = mp.get_property_number("osd-width", 1280)
	local osd_height = mp.get_property_number("osd-height", 720)
	local cur_zoom = mp.get_property_number("video-zoom", 0)
	local cur_pan_x = mp.get_property_number("video-pan-x", 0)
	local cur_pan_y = mp.get_property_number("video-pan-y", 0)
	local video_aspect = mp.get_property_number("video-params/aspect", 1)

	local osd_aspect = osd_width / osd_height
	local x_multiplier = math.max(osd_aspect / video_aspect, 1)
	local y_multiplier = math.max(video_aspect / osd_aspect, 1)
	local new_zoom = cur_zoom + zoom_delta * (inward and 1 or -1)
	local dx = (mouse.x / osd_width - 0.5) * (2 ^ -cur_zoom - 2 ^ -new_zoom) * x_multiplier
	local dy = (mouse.y / osd_height - 0.5) * (2 ^ -cur_zoom - 2 ^ -new_zoom) * y_multiplier

	mp.set_property_number("video-zoom", new_zoom)
	mp.set_property_number("video-pan-x", cur_pan_x - dx)
	mp.set_property_number("video-pan-y", cur_pan_y - dy)
end

local function zoom_in()
	zoom(true, options.zoom_step)
end

local function zoom_out()
	zoom(false, options.zoom_step)
end

local function zoom_in_slow()
	zoom(true, options.zoom_step_fine)
end

local function zoom_out_slow()
	zoom(false, options.zoom_step_fine)
end

mp.add_forced_key_binding("Alt+WHEEL_UP", "zoom-in", zoom_in)
mp.add_forced_key_binding("Alt+WHEEL_DOWN", "zoom-out", zoom_out)
mp.add_forced_key_binding("Shift+Alt+WHEEL_UP", "zoom-in-slow", zoom_in_slow)
mp.add_forced_key_binding("Shift+Alt+WHEEL_DOWN", "zoom-out-slow", zoom_out_slow)
mp.add_forced_key_binding("Alt+MBTN_LEFT", function(kevent)
	if kevent["event"] == "down" then
		drag_pan_init()
	elseif kevent["event"] == "up" then
		drag_pan_end()
	end
end, {
	repeatable = false,
	complex = true,
})
