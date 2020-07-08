local autocmd = require("cfg.autocmd")

--- Javascript layer
local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
end

local function on_filetype_js()
  vim.api.nvim_buf_set_option(0, "shiftwidth", 2)
  vim.api.nvim_buf_set_option(0, "tabstop", 2)
  vim.api.nvim_buf_set_option(0, "softtabstop", 2)
  vim.api.nvim_buf_set_option(0, "formatprg", "prettier --parser typescript") -- use prettier with gg=G
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.tsserver)

  autocmd.bind_filetype("javascript", on_filetype_js)
end

return layer
