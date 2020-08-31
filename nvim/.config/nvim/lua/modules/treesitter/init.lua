-- module treesiter
local plug = require("cfg.plug")
local layer = {}

function layer.register_plugins()
  plug.add_plugin("nvim-treesitter/nvim-treesitter")
end

function layer.init_config()
  local treesiter = require('nvim-treesitter.configs')
  treesiter.setup({
    ensure_installed = {"lua"; "python"; "html"; "yaml"; "javascript"; "css"};
    highlight = {enable = true};
  })
end

return layer
