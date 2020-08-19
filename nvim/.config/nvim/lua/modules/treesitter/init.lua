-- module treesiter
local plug = require("cfg.plug")
local layer = {}

function layer.register_plugins()
  plug.add_plugin("nvim-treesitter/nvim-treesitter")
end

function layer.init_config()
  local treesiter = require('nvim-treesitter.configs')
  treesiter.setup({highlight = {enable = true}})
end

return layer
