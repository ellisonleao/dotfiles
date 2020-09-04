--- Python layer
local autocmd = require("cfg.autocmd")
local kb = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local layer = {}

local function on_filetype_python()
  vim.g["test#python#runner"] = "pytest"
  kb.bind_command(edit_mode.NORMAL, "<leader>r", ":!python %<CR>",
                  {noremap = true})
end

function layer.config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  local lsp_status = require("lsp-status")
  local config = {callbacks = lsp_status.extensions.pyls_ms.setup()}

  vim.g.black_fast = true
  vim.g.black_virtualenv = ""

  lsp.register_server(nvim_lsp.pyls_ms, config)
  autocmd.bind_filetype("python", on_filetype_python)
  autocmd.bind("BufWritePre *.py", function()
    vim.cmd("silent Black")
  end)

end

return layer
