--- Lua layer
local autocmd = require("cfg.autocmd")

local layer = {}

local function on_filetype_lua()
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "softtabstop", 4)
end

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("lang.lsp")
  local nvim_lsp = require("nvim_lsp")
  local lang_server_path = "/home/ellison/.local/lua-language-server"

  -- TODO: Make this configurable per-project
  lsp.register_server(
    nvim_lsp.sumneko_lua,
    {
      cmd = {lang_server_path.."/bin/Linux/lua-language-server", "-E", lang_server_path.."/main.lua"},
      settings = {
        Lua = {
          diagnostics = {
            globals = {
              "vim",
            },
          },
        },
      },
    })

  autocmd.bind_filetype("lua", on_filetype_lua)
end

return layer

