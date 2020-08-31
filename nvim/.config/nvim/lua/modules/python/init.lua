--- Python layer
local autocmd = require("cfg.autocmd")
local plug = require("cfg.plug")
local kb = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local layer = {}

local function on_filetype_python()
  vim.g["test#python#runner"] = "pytest"
  autocmd.bind_bufwrite_pre(function()
    vim.cmd("silent Black")
  end)

  kb.bind_command(edit_mode.NORMAL, "<leader>r", ":!python %<CR>", {noremap = true})
end

function layer.set_globals()
  vim.g.black_fast = true
  vim.g.black_virtualenv = ""
end

function layer.register_plugins()
  plug.add_plugin("psf/black", {["branch"] = "stable"})
end

function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  local lsp_status = require("lsp-status")
  local config = {callbacks = lsp_status.extensions.pyls_ms.setup()}

  lsp.register_server(nvim_lsp.pyls_ms, config)
  autocmd.bind_filetype("python", on_filetype_python)
end

return layer
