function Linemode:size_and_mtime()
	local time = math.floor(self._file.cha.mtime or 0)
	if time == 0 then
		time = ""
	elseif os.date("%Y", time) == os.date("%Y") then
		time = os.date("%b %d %H:%M", time)
	else
		time = os.date("%b %d  %Y", time)
	end

	local size = self._file:size()
	return string.format("%s %s", size and ya.readable_size(size) or "-", time)
end

require("bookmarks"):setup({
	last_directory = { enable = true, persist = true },
	persist = "all",
	desc_format = "full",
	file_pick_mode = "hover",
	notify = {
		enable = true,
		timeout = 2,
		message = {
			new = "New bookmark 'm' -> '<folder>'",
			delete = "Deleted bookmark in '<key>'",
			delete_all = "Deleted all bookmarks",
		},
	},
})

require("projects"):setup({
	save = {
		method = "yazi", -- yazi | lua
		lua_save_path = "~/.config/yazi/state/projects.json", -- windows: "%APPDATA%/yazi/state/projects.json", unix: "~/.config/yazi/state/projects.json"
	},
	last = {
		update_after_save = true,
		update_after_load = true,
	},
	merge = {
		quit_after_merge = false,
	},
	notify = {
		enable = true,
		title = "Tabs Save",
		timeout = 3,
		level = "info",
	},
})

require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

--require("relative-motions"):setup({ show_numbers = "relative_absolute", show_motion = true })
--require("eza-preview"):setup()
--
require("allmytoes"):setup({
	-- By default, all sizes are generated. Remove the ones you don't need.
	sizes = { "n", "l", "x", "xx" },
})
