--- Go layer
local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local layer = {}

local function on_filetype_go()
  -- " :GoRun
  -- autocmd FileType go nmap <leader>r  <Plug>(go-run)

  -- " :GoCoverageToggle
  -- autocmd FileType go nmap <Leader>c <Plug>(go-coverage-toggle)

  -- " :GoInfo
  -- autocmd FileType go nmap <Leader>i <Plug>(go-info)

  -- " :GoMetaLinter
  -- autocmd FileType go nmap <Leader>l <Plug>(go-metalinter)
  keybind.bind_command(edit_mode.NORMAL, "<leader>r", ":GoRun<CR>", {noremap = true}, "Run Go code")
end

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("fatih/vim-go", {["do"] = ":GoUpdateBinaries"})
end

--- Configures vim and plugins for this layer
function layer.init_config()
  local lsp = require("lang.lsp")
  local nvim_lsp = require("nvim_lsp")

  -- vars
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
