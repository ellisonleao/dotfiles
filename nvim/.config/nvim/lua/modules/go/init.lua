--- Go layer
local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local layer = {}

local function on_filetype_go()
  keybind.bind_command(edit_mode.NORMAL, "<leader>c", "<Plug>(go-coverage-toggle)")
  keybind.bind_command(edit_mode.NORMAL, "<leader>r", "<Plug>(go-run)")
  keybind.bind_command(edit_mode.NORMAL, "<leader>i", "<Plug>(go-info)")

  keybind.bind_command(edit_mode.NORMAL, "<leader>b",
                       ":lua require('modules.go').build_go_files()<CR>")
end

local function build_go_files()
  local file = vim.api.nvim_eval("expand('%')")
  local is_test_file = file:sub(-#"_test.go") == "_test.go"
  if is_test_file then
    vim.api.nvim_exec("call go#test#Test(0, 1)", false)
  else
    vim.api.nvim_exec("call go#cmd#Build(0)", false)
  end
end

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("fatih/vim-go", {["do"] = ":GoUpdateBinaries"})
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  lsp.register_server(nvim_lsp.gopls)

  -- vim-go vars
  vim.g.go_fmt_command = "goimports"
  vim.g.go_autodetect_gopath = true
  vim.g.go_list_type = "quickfix"
  vim.g.go_addtags_transform = "camelcase"
  vim.g.go_highlight_types = true
  vim.g.go_highlight_fields = true
  vim.g.go_highlight_buf_opttions = true
  vim.g.go_highlight_buf_opttion_calls = true
  vim.g.go_highlight_build_constraints = true
  vim.g.go_highlight_generate_tags = true
  vim.g.go_highlight_extra_types = true
  vim.g.go_highlight_generate_tags = true
  vim.g.go_metalinter_autosave = true
  vim.g.go_metalinter_autosave_enabled = {"govet"; "golint"; "gosimple"}

  -- configure gotest
  vim.g["test#go#executable"] = "go test -v"

  autocmd.bind_filetype("go", on_filetype_go)
end

return layer
