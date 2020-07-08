--- Python layer
local autocmd = require("cfg.autocmd")
local layer = {}

local function on_filetype_python()
  vim.g["test#python#runner"] = "pytest"
end

function layer.register_plugins()
end

function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  local config = {configurationSources = {"flake8"}}

  lsp.register_server(nvim_lsp.pyls, config)
  autocmd.bind_filetype("python", on_filetype_python)

end

return layer
