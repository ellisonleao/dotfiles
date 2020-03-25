-- User-specific editor tweaks

local plug = require("cfg.plug")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local autocmd = require("cfg.autocmd")

local layer = {}

-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_buf_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function()
    vim.bo[name] = value
  end)
end

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("tpope/vim-surround") -- Awesome for dealing with surrounding things, like parens
  plug.add_plugin("tpope/vim-commentary") -- Commenting
  plug.add_plugin("liuchengxu/vim-clap", {["do"] = ":Clap install-binary"}) -- fuzzy search
  plug.add_plugin("janko-m/vim-test") --test plugin
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- \ for leader, comma for local leader
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ","

  -- Save undo history
  set_default_buf_opt("undofile", true)

  --- set python host paths
  vim.g.python3_host_prog = "~/.pyenv/versions/3.8.0/bin/python";
  vim.g.python_host_prog = "~/.pyenv/versions/2.7.16/bin/python";

  -- Allow a .vimrc file in a project directory with safe commands
  vim.o.exrc = true
  vim.o.secure = true

  -- Edit config, reload config, and update plugins
  keybind.set_group_name("<leader>re", "Editor")
  keybind.bind_command(edit_mode.NORMAL, "<leader>red", ":edit $HOME/.config/nvim<CR>", { noremap = true }, "Edit config")
  keybind.bind_command(edit_mode.NORMAL, "<leader>reR", ":source $MYVIMRC<CR>", { noremap = true }, "Reload config")
  keybind.bind_command(edit_mode.NORMAL, "<leader>reU", ":source $MYVIMRC|PlugUpgrade|PlugClean|PlugUpdate|source $MYVIMRC<CR>",
    {noremap = true}, "Install and update plugins")

  -- Grep search
  keybind.bind_command(edit_mode.NORMAL, "<leader>f", ":Clap grep<CR>", { noremap = true}, "Grep search")
  keybind.bind_command(edit_mode.NORMAL, "<leader>\\", ":noh<CR>", { noremap = true }, "Clear search")

  -- Terminal navigation
  keybind.bind_command(edit_mode.NORMAL, ",z", ":bp<CR>", { noremap = true}, "Previous buffer")
  keybind.bind_command(edit_mode.NORMAL, ",q", ":bp<CR>", { noremap = true}, "Previous buffer")
  keybind.bind_command(edit_mode.NORMAL, ",x", ":bn<CR>", { noremap = true}, "Next buffer")
  keybind.bind_command(edit_mode.NORMAL, ",w", ":bn<CR>", { noremap = true}, "Next buffer")

  -- split navigation
  keybind.bind_command(edit_mode.NORMAL, ",j", "<C-W><C-J>", { noremap = true}, "Move Split down")
  keybind.bind_command(edit_mode.NORMAL, ",k", "<C-W><C-K>", { noremap = true}, "Move Split up")
  keybind.bind_command(edit_mode.NORMAL, ",l", "<C-W><C-L>", { noremap = true}, "Move Split right")
  keybind.bind_command(edit_mode.NORMAL, ",h", "<C-W><C-H>", { noremap = true}, "Move Split left")
  -- close buffer
  keybind.bind_command(edit_mode.NORMAL, ",d", ":bd!<CR>", { noremap = true}, "Close buffer")

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

  vim.g["test#strategy"] = "neovim"
  vim.g["test#java#runner"] = "gradletest"
  vim.g["test#java#executable"] = "gradle test -i"

  -- Default global rules
  set_default_buf_opt("tabstop", 4)
  set_default_buf_opt("softtabstop", 4)
  set_default_buf_opt("shiftwidth", 4)
  set_default_buf_opt("expandtab", true)
  set_default_buf_opt("autoindent", true)
  set_default_buf_opt("autoread", true)
  set_default_buf_opt("smartindent", true)
  set_default_buf_opt("swapfile", false)

  -- Remeber last cursor position
  autocmd.bind("BufReadPost *", function()
    vim.api.nvim_exec("normal! g`\"", false)
  end)
end

return layer
