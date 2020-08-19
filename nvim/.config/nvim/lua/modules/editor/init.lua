local plug = require("cfg.plug")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local autocmd = require("cfg.autocmd")
local kbc = keybind.bind_command
local vcmd = vim.cmd

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("tpope/vim-surround")
  plug.add_plugin("tpope/vim-commentary")
  plug.add_plugin("tpope/vim-repeat")
  plug.add_plugin("vim-test/vim-test")
  plug.add_plugin("sheerun/vim-polyglot")
  plug.add_plugin("junegunn/fzf", {["do"] = ":call fzf#install()"})
  plug.add_plugin("junegunn/fzf.vim")
end

function layer.set_globals()
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ","
  vim.g.python3_host_prog = "~/.pyenv/versions/3.8.2/bin/python"
  vim.g.python_host_prog = "~/.pyenv/versions/2.7.17/bin/python"
  vim.g["test#strategy"] = "neovim"
  vim.g.c_keybind_leader_info = keybind._leader_info
end

function layer.set_options()
  vim.bo.shiftwidth = 4
  vim.bo.softtabstop = 4
  vim.bo.expandtab = true
  vim.bo.autoindent = true
  vim.bo.autoread = true
  vim.bo.smartindent = true
  vim.bo.swapfile = false
  vim.bo.textwidth = 88
  vim.bo.tabstop = 4
  vim.bo.undofile = true
  vim.wo.foldmethod = "marker"
  vim.o.autochdir = true
  vim.o.exrc = true
  vim.o.secure = true
  vim.o.wildmode = "list:longest"
  vim.o.inccommand = "split"
  vim.o.ignorecase = true
  vim.o.smartcase = true
  vim.o.shortmess = vim.o.shortmess .. "c"
end

--- Configures vim and plugins for this layer
function layer.init_config()
  layer.set_globals()
  layer.set_options()

  -- Edit config, reload config, and update plugins
  kbc(edit_mode.NORMAL, "<leader>red", ":edit $HOME/.config/nvim<CR>",
      {noremap = true})
  kbc(edit_mode.NORMAL, "<leader>reR", ":source $MYVIMRC<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, "<leader>reU",
      ":source $MYVIMRC|PlugUpgrade|PlugClean|PlugUpdate|source $MYVIMRC<CR>",
      {noremap = true})

  -- search
  local rg_cmd =
    "rg --column --line-number --no-heading --color=always --smart-case -- "
  vcmd("command! -bang -nargs=* Find call fzf#vim#grep('" .. rg_cmd ..
         "'.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)")
  kbc(edit_mode.NORMAL, "<leader>f", ":Find<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, "<leader>\\", ":noh<CR>", {noremap = true})
  vim.g.fzf_preview_window = "right:60%"

  -- Terminal navigation
  kbc(edit_mode.NORMAL, ",z", ":bp<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, ",q", ":bp<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, ",x", ":bn<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, ",w", ":bn<CR>", {noremap = true})

  -- split navigation
  kbc(edit_mode.NORMAL, ",j", "<C-W><C-J>", {noremap = true})
  kbc(edit_mode.NORMAL, ",k", "<C-W><C-K>", {noremap = true})
  kbc(edit_mode.NORMAL, ",l", "<C-W><C-L>", {noremap = true})
  kbc(edit_mode.NORMAL, ",h", "<C-W><C-H>", {noremap = true})

  -- close buffer and quickfix
  kbc(edit_mode.NORMAL, ",d", ":bd!<CR>", {noremap = true})
  kbc(edit_mode.NORMAL, ",c", ":cclose<CR>", {noremap = true})

  -- " Vmap for maintain Visual Mode after shifting > and <
  kbc(edit_mode.VISUAL, "<", "<gv")
  kbc(edit_mode.VISUAL, ">", ">gv")

  -- vim-test bindings
  kbc(edit_mode.NORMAL, "<leader>tt", ":TestNearest<CR>")
  kbc(edit_mode.NORMAL, "<leader>tT", ":TestFile<CR>")
  kbc(edit_mode.NORMAL, "<leader>ta", ":TestSuite<CR>")
  kbc(edit_mode.NORMAL, "<leader>tl", ":TestLast<CR>")
  kbc(edit_mode.NORMAL, "<leader>tg", ":TestVisit<CR>")

  -- quickfix navigation
  kbc(edit_mode.NORMAL, "<leader>n", ":cn<CR>")
  kbc(edit_mode.NORMAL, "<leader>p", ":cp<CR>")

  -- Remeber last cursor position
  autocmd.bind("BufReadPost *", function()
    local last_line = vim.api.nvim_call_function("line", {"$"})
    local quote_reg_line = vim.api.nvim_call_function("line", {"'\""})
    -- skip check position for the following filetypes
    local skip_filetypes = {
      ['commit'] = true;
      ['gitcommit'] = true;
      ['fugitive'] = true;
    }
    local ft = vim.bo[0].filetype
    local line_exists = last_line <= 1 or quote_reg_line >= last_line

    if skip_filetypes[ft] or line_exists then
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(0, '"')
    vim.api.nvim_win_set_cursor(0, last_pos)
  end)

  -- remove trailing spaces
  autocmd.bind_bufwrite_pre(function()
    vcmd("%s/\\s\\+$//e")
  end)

  -- A shortcut command for :lua print(vim.inspect(...)) (:Li for Lua Inspect)
  vcmd("command! -nargs=+ Li :lua print(vim.inspect(<args>))")
end

return layer
