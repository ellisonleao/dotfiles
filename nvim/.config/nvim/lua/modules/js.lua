--- Javascript layer
local js = {}
require("nvim_utils")

local function on_filetype_js()
  nvim.bo.shiftwidth = 2
  nvim.bo.tabstop = 2
  nvim.bo.softtabstop = 2
  nvim.o.formatprg = "prettier"
end

--- Configures vim and plugins for this layer
function js.config()
  print("js")
end

return js
