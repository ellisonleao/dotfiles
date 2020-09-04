local autocmd = require("cfg.autocmd")

--- Javascript layer
local layer = {}

local function on_filetype_js()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
  vim.o.formatprg = "prettier"
end

--- Configures vim and plugins for this layer
function layer.config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")

  lsp.register_server(nvim_lsp.tsserver)
  autocmd.bind_filetype("javascript,javascriptreact,typescript,typescriptreact",
                        on_filetype_js)
end

return layer
