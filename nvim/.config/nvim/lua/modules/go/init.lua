--- Go layer
local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local layer = {}

local function on_filetype_go()
  -- " :GoCoverageToggle
  keybind.bind_command(edit_mode.NORMAL, "<leader>c", "<Plug>(go-coverage-toggle)")

    -- :GoRun
  keybind.bind_command(edit_mode.NORMAL, "<leader>r", "<Plug>(go-run)")

  -- :GoInfo
  keybind.bind_command(edit_mode.NORMAL, "<leader>i", "<Plug>(go-info)")

  -- build go files
  local command = ":lua require('modules.go')._build_go_files()<CR>"
  keybind.bind_command(edit_mode.NORMAL, "<leader>b", command)
end

layer._build_go_files = function()
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

  -- vim-go vars
  vim.api.nvim_set_var("go_fmt_command", "goimports")
  vim.api.nvim_set_var("go_autodetect_gopath", 1)
  vim.api.nvim_set_var("go_list_type", "quickfix")
  vim.api.nvim_set_var("go_addtags_transform", "camelcase")
  vim.api.nvim_set_var("go_highlight_types", 1)
  vim.api.nvim_set_var("go_highlight_fields", 1)
  vim.api.nvim_set_var("go_highlight_buf_opttions", 1)
  vim.api.nvim_set_var("go_highlight_buf_opttion_calls", 1)
  vim.api.nvim_set_var("go_highlight_extra_types", 1)
  vim.api.nvim_set_var("go_highlight_generate_tags", 1)

  -- configure gotest
  vim.g["test#go#executable"] = "gotest -v"

  lsp.register_server(nvim_lsp.gopls)
  autocmd.bind_filetype("go", on_filetype_go)
end

return layer
