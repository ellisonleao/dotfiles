local wezterm = require("wezterm")

return {
  leader = { key = "b", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    { key = "h", mods = "LEADER", action = wezterm.action({ SplitVertical = { domain = "CurrentPaneDomain" } }) },
    {
      key = "v",
      mods = "LEADER",
      action = wezterm.action({ SplitHorizontal = { domain = "CurrentPaneDomain" } }),
    },
    { key = "c", mods = "LEADER", action = wezterm.action({ SpawnTab = "CurrentPaneDomain" }) },
    { key = "x", mods = "LEADER", action = wezterm.action({ CloseCurrentTab = { confirm = false } }) },
    { key = "LeftArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Left" }) },
    { key = "RightArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Right" }) },
    { key = "UpArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Up" }) },
    { key = "DownArrow", mods = "LEADER", action = wezterm.action({ ActivatePaneDirection = "Down" }) },
    { key = "p", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = -1 }) },
    { key = "n", mods = "LEADER", action = wezterm.action({ ActivateTabRelative = 1 }) },
  },
  color_scheme = "Github",
  font = wezterm.font("JetBrainsMono Nerd Font Mono"),
  custom_block_glyphs = false,
  font_size = 13,
  exit_behavior = "Close",
  audible_bell = "Disabled",
}
