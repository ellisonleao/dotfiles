local plug = require("cfg.plug")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local autocmd = require("cfg.autocmd")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("tpope/vim-surround") -- Awesome for dealing with surrounding things, like parens
  plug.add_plugin("tpope/vim-commentary") -- Commenting
  plug.add_plugin("tpope/vim-repeat")
  plug.add_plugin("janko-m/vim-test") -- test plugin
  plug.add_plugin("sheerun/vim-polyglot") -- language pack
  plug.add_plugin("liuchengxu/vim-which-key")
  plug.add_plugin("junegunn/fzf", {["do"] = "-> fzf#install()"})
  plug.add_plugin("junegunn/fzf.vim")
end

function layer.set_globals()
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ","
  vim.g.python3_host_prog = "~/.pyenv/versions/3.8.2/bin/python"
  vim.g.python_host_prog = "~/.pyenv/versions/2.7.17/bin/python"
  vim.g.tabstop = 4
  vim.g.softtabstop = 4
  vim.g.shiftwidth = 4
  vim.g.expandtab = true
  vim.g.autoindent = true
  vim.g.autoread = true
  vim.g.smartindent = true
  vim.g.swapfile = false
  vim.g.foldmethod = "marker"
  vim.g.textwidth = 80
  vim.g["test#strategy"] = "neovim"
  vim.g.c_keybind_leader_info = keybind._leader_info
  vim.g.which_key_floating_opts = {col = -2; width = -1}
end

function layer.set_options()
  vim.o.undofile = true
  vim.o.exrc = true
  vim.o.secure = true
  vim.o.wildmode = "list:longest"
  vim.o.inccommand = "split"
  vim.o.ignorecase = true
  vim.o.smartcase = true
end

--- Configures vim and plugins for this layer
function layer.init_config()
  layer.set_globals()
  layer.set_options()

  local leader = vim.api.nvim_get_var("mapleader")
  local local_leader = vim.api.nvim_get_var("maplocalleader")
  local escaped_leader = leader:gsub("'", "\\'")
  local escaped_local_leader = local_leader:gsub("'", "\\'")
  local leader_cmd = ":WhichKey '" .. escaped_leader .. "'<CR>"
  local local_leader_cmd = ":WhichKey '" .. escaped_local_leader .. "'<CR>"

  -- Bind leader/localleader to show which key
  keybind.bind_command(edit_mode.NORMAL, leader, leader_cmd,
                       {noremap = true; silent = true})
  keybind.bind_command(edit_mode.NORMAL, local_leader, local_leader_cmd,
                       {noremap = true; silent = true})

  -- Register the leader key info dict
  vim.fn["which_key#register"](leader, "g:c_keybind_leader_info")

  -- Center which key better
  -- Edit config, reload config, and update plugins
  keybind.set_group_name("<leader>re", "Editor")
  keybind.bind_command(edit_mode.NORMAL, "<leader>red", ":edit $HOME/.config/nvim<CR>",
                       {noremap = true}, "Edit config")
  keybind.bind_command(edit_mode.NORMAL, "<leader>reR", ":source $MYVIMRC<CR>",
                       {noremap = true}, "Reload config")
  keybind.bind_command(edit_mode.NORMAL, "<leader>reU",
                       ":source $MYVIMRC|PlugUpgrade|PlugClean|PlugUpdate|source $MYVIMRC<CR>",
                       {noremap = true}, "Install and update plugins")

  -- search
  vim.cmd(
    "command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --color=always --smart-case -- '.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)")
  keybind.bind_command(edit_mode.NORMAL, "<leader>f", ":Find<CR>", {noremap = true},
                       "Fzf search")
  keybind.bind_command(edit_mode.NORMAL, "<leader>\\", ":noh<CR>", {noremap = true},
                       "Clear search")
  vim.g.fzf_preview_window = "right:60%"

  -- Terminal navigation
  keybind.bind_command(edit_mode.NORMAL, ",z", ":bp<CR>", {noremap = true},
                       "Previous buffer")
  keybind.bind_command(edit_mode.NORMAL, ",q", ":bp<CR>", {noremap = true},
                       "Previous buffer")
  keybind.bind_command(edit_mode.NORMAL, ",x", ":bn<CR>", {noremap = true},
                       "Next buffer")
  keybind.bind_command(edit_mode.NORMAL, ",w", ":bn<CR>", {noremap = true},
                       "Next buffer")

  -- split navigation
  keybind.bind_command(edit_mode.NORMAL, ",j", "<C-W><C-J>", {noremap = true},
                       "Move Split down")
  keybind.bind_command(edit_mode.NORMAL, ",k", "<C-W><C-K>", {noremap = true},
                       "Move Split up")
  keybind.bind_command(edit_mode.NORMAL, ",l", "<C-W><C-L>", {noremap = true},
                       "Move Split right")
  keybind.bind_command(edit_mode.NORMAL, ",h", "<C-W><C-H>", {noremap = true},
                       "Move Split left")

  -- close buffer
  keybind.bind_command(edit_mode.NORMAL, ",d", ":bd!<CR>", {noremap = true},
                       "Close buffer")

  -- " Vmap for maintain Visual Mode after shifting > and <
  keybind.bind_command(edit_mode.VISUAL, "<", "<gv")
  keybind.bind_command(edit_mode.VISUAL, ">", ">gv")

  -- vim-test bindings
  keybind.set_group_name("<leader>t", "Test")
  keybind.bind_command(edit_mode.NORMAL, "<leader>tt", ":TestNearest<CR>")
  keybind.bind_command(edit_mode.NORMAL, "<leader>tT", ":TestFile<CR>")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ta", ":TestSuite<CR>")
  keybind.bind_command(edit_mode.NORMAL, "<leader>tl", ":TestLast<CR>")
  keybind.bind_command(edit_mode.NORMAL, "<leader>tg", ":TestVisit<CR>")

  -- quickfix navigation
  keybind.bind_command(edit_mode.NORMAL, "<leader>n", ":cn<CR>")
  keybind.bind_command(edit_mode.NORMAL, "<leader>p", ":cp<CR>")

  -- Remeber last cursor position
  autocmd.bind("BufReadPost *", function()
    vim.cmd("normal! g`\"")
  end)

  -- remove trailing spaces
  -- cant make that regex work
  -- autocmd.bind_bufwrite_pre(function()
  -- vim.cmd("%s#\\s\\+$//e")
  -- end)

  -- A shortcut command for :lua print(vim.inspect(...)) (:Li for Lua Inspect)
  vim.cmd("command! -nargs=+ Li :lua print(vim.inspect(<args>))")
end

return layer
