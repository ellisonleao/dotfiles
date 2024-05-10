local wezterm = require("wezterm")

local colorscheme = function()
  if tonumber(os.date("%H")) >= 18 then
    return "OneDark (base16)"
  end
  return "One Light (Gogh)"
end

return {
  default_prog = { "/bin/bash" },
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
  color_scheme = colorscheme(),
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
