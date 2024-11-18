---@type Wezterm
local wezterm = require("wezterm")
local act = wezterm.action

return {
	default_prog = { "/bin/bash" },
	leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 },
	keys = {
		{ key = "h", mods = "LEADER", action = act({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
		{
			key = "v",
			mods = "LEADER",
			action = act({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
		},
		{ key = "c", mods = "LEADER", action = act({ SpawnTab = "CurrentPaneDomain" }) },
		{ key = "x", mods = "LEADER", action = act({ CloseCurrentTab = { confirm = false } }) },
		{ key = "LeftArrow", mods = "LEADER", action = act({ ActivatePaneDirection = "Left" }) },
		{ key = "RightArrow", mods = "LEADER", action = act({ ActivatePaneDirection = "Right" }) },
		{ key = "UpArrow", mods = "LEADER", action = act({ ActivatePaneDirection = "Up" }) },
		{ key = "DownArrow", mods = "LEADER", action = act({ ActivatePaneDirection = "Down" }) },
		{ key = "p", mods = "LEADER", action = act({ ActivateTabRelative = -1 }) },
		{ key = "n", mods = "LEADER", action = act({ ActivateTabRelative = 1 }) },
	},
	color_scheme = "GruvboxDark",
	font = wezterm.font("JetBrainsMono Nerd Font"),
	custom_block_glyphs = false,
	font_size = 13,
	exit_behavior = "Close",
	audible_bell = "Disabled",
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
}
