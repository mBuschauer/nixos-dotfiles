hl.config({
	cursor = { no_hardware_cursors = true },
	input = { sensitivity = -0.2, follow_mouse = 2 },
	general = {
		gaps_in = 1,
		gaps_out = 0,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
			inactive_border = "rgba(595959aa)",
		},
		resize_on_border = false,
		layout = "dwindle",
		allow_tearing = true,
	},
	decoration = {
		rounding = 2,
		shadow = { enabled = true, range = 4, render_power = 3, color = "rgba(1a1a1aee)" },
		blur = { enabled = true, size = 3, passes = 1 },
	},
	misc = { focus_on_activate = true, force_default_wallpaper = 0 },
	animations = { enabled = true },
	dwindle = { preserve_split = true },
	debug = { disable_logs = false },
})
