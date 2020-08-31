--- Lua layer
local autocmd = require("cfg.autocmd")
local plug = require("cfg.plug")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local kbc = keybind.bind_command

local layer = {}

local function on_filetype_lua()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2

  kbc(edit_mode.NORMAL, "<leader>r", ":!lua %<CR>", {noremap = true})
end

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("andrejlevkovitch/vim-lua-format")
  plug.add_plugin("tjdevries/nlua.nvim")
  plug.add_plugin("euclidianAce/BetterLua.vim")
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.sumneko_lua,
                      {settings = {Lua = {diagnostics = {globals = {"vim"}}}}})

  autocmd.bind_filetype("lua", on_filetype_lua)
  autocmd.bind("BufWrite *.lua", function()
    vim.api.nvim_exec("call LuaFormat()", false)
  end)
end

return layer
