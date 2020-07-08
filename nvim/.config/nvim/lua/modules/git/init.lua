local plug = require("cfg.plug")

local layer = {}

function layer.register_plugins()
  plug.add_plugin("tpope/vim-fugitive")
  plug.add_plugin("tpope/vim-rhubarb")
  plug.add_plugin("airblade/vim-gitgutter")
end

function layer.init_config()
end

return layer
