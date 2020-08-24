--- Lua layer
local autocmd = require("cfg.autocmd")
local plug = require("cfg.plug")

local layer = {}

local function on_filetype_lua()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
  autocmd.bind_bufwrite_pre(function()
    vim.api.nvim_exec("call LuaFormat()", false)
  end)
end

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("andrejlevkovitch/vim-lua-format")
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.sumneko_lua,
                      {settings = {Lua = {diagnostics = {globals = {"vim"}}}}})

  autocmd.bind_filetype("lua", on_filetype_lua)
end

return layer
