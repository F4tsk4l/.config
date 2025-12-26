local mp = require("mp")
local assdraw = require("mp.assdraw")

local start_x, start_y = nil, nil
local drawing = false
local osd = mp.create_osd_overlay("ass-events")

-- Get current OSD dimensions
local function get_osd_size()
	local w = mp.get_property_number("osd-width", 1)
	local h = mp.get_property_number("osd-height", 1)
	return w, h
end
-- Draw a single translucent red rectangle with a red 1px border
local function draw_rectangle(x1, y1, x2, y2)
	local ass = assdraw.ass_new()
	ass:draw_start()

	-- Translucent fill (red, 60% transparent)
	ass:append("{\\an7\\1c&H0000FF&\\alpha&H90&\\bord0}")
	ass:move_to(x1, y1)
	ass:line_to(x2, y1)
	ass:line_to(x2, y2)
	ass:line_to(x1, y2)
	ass:line_to(x1, y1)

	-- Red border (opaque red, 1px thick)
	ass:append("{\\an7\\1c&H0000FF&\\alpha&H00&\\bord1\\shad0}")
	ass:move_to(x1, y1)
	ass:line_to(x2, y1)
	ass:line_to(x2, y2)
	ass:line_to(x1, y2)
	ass:line_to(x1, y1)

	ass:draw_stop()
	osd.data = ass.text
	osd:update()
end

-- Start selection on right-click
mp.add_forced_key_binding("MBTN_RIGHT", "zoom_start", function()
	start_x, start_y = mp.get_mouse_pos()
	drawing = true
end, { complex = true })

-- Draw selection on mouse move
mp.add_forced_key_binding("MOUSE_MOVE", "zoom_update", function()
	if drawing then
		local x, y = mp.get_mouse_pos()
		draw_rectangle(start_x, start_y, x, y)
	end
end, { repeatable = true })

-- Apply crop zoom on mouse release
mp.add_forced_key_binding("MBTN_RIGHT_UP", "zoom_crop", function()
	if not drawing then
		return
	end
	local end_x, end_y = mp.get_mouse_pos()
	clear_osd()
	drawing = false

	-- Get OSD size for coordinate normalization
	local osd_w, osd_h = get_osd_size()

	local x1 = math.min(start_x, end_x)
	local y1 = math.min(start_y, end_y)
	local x2 = math.max(start_x, end_x)
	local y2 = math.max(start_y, end_y)

	local crop_w = x2 - x1
	local crop_h = y2 - y1

	if crop_w < 20 or crop_h < 20 then
		return
	end -- avoid tiny crops

	-- Scale selection to video resolution
	local vid_w = mp.get_property_number("width", 0)
	local vid_h = mp.get_property_number("height", 0)

	local scale_x = vid_w / osd_w
	local scale_y = vid_h / osd_h

	local crop_x = math.floor(x1 * scale_x)
	local crop_y = math.floor(y1 * scale_y)
	local crop_w_scaled = math.floor(crop_w * scale_x)
	local crop_h_scaled = math.floor(crop_h * scale_y)

	-- Apply crop filter
	local crop_filter =
		string.format("lavfi-crop=out_w=%d:out_h=%d:x=%d:y=%d", crop_w_scaled, crop_h_scaled, crop_x, crop_y)
	mp.commandv("vf", "add", crop_filter)
end)

-- Reset zoom by removing crop
mp.add_key_binding("z", "zoom_reset", function()
	clear_osd()
	mp.commandv("vf", "remove", "lavfi-crop")
end)
