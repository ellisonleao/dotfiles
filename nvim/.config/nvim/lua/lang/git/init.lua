--- The version control layer
-- @module lang.git

local layer = {}

local plug = require("cfg.plug")

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("tpope/vim-fugitive") -- best git plugin for vim
  plug.add_plugin("tpope/vim-rhubarb") -- integration with hub
  plug.add_plugin("airblade/vim-gitgutter") -- git gutter
end

--- Configures vim and plugins for this layer
function layer.init_config()
end

return layer
