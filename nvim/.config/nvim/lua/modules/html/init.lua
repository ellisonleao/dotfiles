local autocmd = require("cfg.autocmd")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")

--- HTML layer
local layer = {}

local function on_filetype_web()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
  keybind.bind_command(edit_mode.INSERT, "<tab>",
                       "emmet#expandAbbrIntelligent('<tab>')", {expr = true})
  vim.cmd("EmmetInstall")
end

--- Configures vim and plugins for this layer
function layer.config()
  autocmd.bind_filetype("html,css,scss", on_filetype_web)
  vim.g.user_emmet_install_global = 0
end

return layer
