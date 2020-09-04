--- Go layer
local autocmd = require("cfg.autocmd")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local kbc = keybind.bind_command
local kbf = keybind.bind_function
local layer = {}

local function build_go_files()
  local file = vim.api.nvim_eval("expand('%')")
  local is_test_file = file:sub(-#"_test.go") == "_test.go"
  if is_test_file then
    vim.api.nvim_exec("call go#test#Test(0, 1)", false)
  else
    vim.api.nvim_exec("call go#cmd#Build(0)", false)
  end
end

local function on_filetype_go()
  kbc(edit_mode.NORMAL, "<leader>c", "<Plug>(go-coverage-toggle)")
  kbc(edit_mode.NORMAL, "<leader>r", "<Plug>(go-run)")
  kbc(edit_mode.NORMAL, "<leader>i", "<Plug>(go-info)")
  kbc(edit_mode.NORMAL, "<leader>l", "<Plug>(go-metalinter)")
  kbf(edit_mode.NORMAL, "<leader>b", build_go_files)

  -- vim-go vars
  vim.g.go_fmt_command = "goimports"
  vim.g.go_list_type = "quickfix"
  vim.g.go_addtags_transform = "camelcase"
  vim.g.go_metalinter_command = "golangci-lint run --fix --out-format tab"
  vim.g.go_metalinter_enabled = {}
  vim.g.go_metalinter_autosave_enabled = {}

  -- vim-test
  vim.g["test#go#executable"] = "go test -v"

  vim.bo.shiftwidth = 4
  vim.bo.tabstop = 4
end

--- Configures vim and plugins for this layer
function layer.config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  lsp.register_server(nvim_lsp.gopls)
  autocmd.bind_filetype("go", on_filetype_go)
end

return layer
