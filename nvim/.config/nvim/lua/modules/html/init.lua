local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")

--- HTML layer
local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("mattn/emmet-vim")
end

local function activate_emmet()
  vim.cmd("EmmetInstall")
end

local function on_filetype_web()
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "softtabstop", 2)
  keybind.bind_command(edit_mode.INSERT, "<tab>",
                       "emmet#expandAbbrIntelligent('<tab>')", {expr = true})
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.html)

  autocmd.bind_filetype("html", on_filetype_web)
  autocmd.bind_filetype("css", on_filetype_web)
  autocmd.bind_filetype("scss", on_filetype_web)

  -- Emmet config
  vim.g.user_emmet_install_global = 0
  autocmd.bind_filetype("html", activate_emmet)
  autocmd.bind_filetype("css", activate_emmet)
  autocmd.bind_filetype("scss", activate_emmet)
end

return layer
