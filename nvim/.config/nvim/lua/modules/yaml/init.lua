--- YAML layer
local layer = {}

--- Configures vim and plugins for this layer
function layer.config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.yamlls)
end

return layer
