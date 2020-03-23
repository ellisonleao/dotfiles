--- Python layer
local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("lang.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.pyls)
end

return layer
