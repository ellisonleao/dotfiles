local utils = require("modules.utils")

local function set_globals()
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ","
  vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/3.8.2/bin/python")
  vim.g.python_host_prog = vim.fn.expand("~/.pyenv/versions/2.7.17/bin/python")
  vim.g["test#strategy"] = "floaterm"
  vim.g.neoformat_basic_format_trim = true
  vim.g.diagnostic_enable_virtual_text = 1
end

local function set_options()
  local options = {
    -- path = vim.o.path .. "," .. vim.env.PWD,
    autoread = true,
    background = "dark",
    hidden = true,
    ignorecase = true,
    inccommand = "nosplit",
    incsearch = true,
    laststatus = 2,
    listchars = [[eol:$,tab:>-,trail:~,extends:>,precedes:<]],
    modeline = true,
    shada = [[!,'500,<50,s10,h]],
    showcmd = true,
    showmode = false,
    smartcase = true,
    splitbelow = true,
    splitright = true,
    startofline = false,
    termguicolors = true,
    textwidth = 88,
    title = true,
    titlestring = "%{join(split(getcwd(), '/')[-2:], '/')}",
    viminfo = [[!,'300,<50,s10,h]],
    wildignorecase = true,
    wildmenu = true,
    wildmode = "list:longest",
    updatetime = 500,
    expandtab = true,
    autoindent = true,
    smartindent = true,
    shortmess = vim.o.shortmess .. "c",
    scrolloff = 12,
    mouse = vim.o.mouse .. "a",
    completeopt = "menuone,noinsert,noselect",
    swapfile = false,
  }

  vim.wo.relativenumber = true
  vim.wo.number = true
  vim.wo.colorcolumn = "88"
  vim.bo.shiftwidth = 4
  vim.bo.softtabstop = 4

  for k, v in pairs(options) do
    vim.o[k] = v
  end
end

FILETYPE_HOOKS = {
  lua = require("modules.lua").config(),
  python = require("modules.python").config(),
  viml = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
  html = function()
    vim.g.neoformat_enabled_html = {}
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
  end,
  proto = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
  yaml = function()
    vim.g.neoformat_enabled_yaml = {}
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
  sh = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
  end,
}

set_globals()
set_options()

local rg_cmd = "rg --column --line-number --no-heading --color=always --smart-case -- "
vim.cmd("command! -bang -nargs=* Find call fzf#vim#grep('" .. rg_cmd ..
          "'.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)")

local opts = {noremap = true}
local mappings = {
  {"n", "<leader>red", [[<Cmd>edit $HOME/.config/nvim/lua/init.lua<CR>]], opts},
  {"n", "<leader>reR", [[<Cmd>luafile $HOME/.config/nvim/lua/plugins.lua<CR>]], opts},
  {"n", "<leader>reU", [[<Cmd>PackerSync<CR>]], opts},
  {"n", "<leader>f", [[<Cmd>Find<CR>]], opts},
  {"n", "<leader>\\", [[<Cmd>noh<CR>]], opts},
  {"n", ",z", [[<Cmd>bp<CR>]], opts},
  {"n", ",q", [[<Cmd>bp<CR>]], opts},
  {"n", ",x", [[<Cmd>bn<CR>]], opts},
  {"n", ",w", [[<Cmd>bn<CR>]], opts},
  {"n", ",j", [[<C-W><C-J>]], opts},
  {"n", ",k", [[<C-W><C-K>]], opts},
  {"n", ",l", [[<C-W><C-L>]], opts},
  {"n", ",m", [[<C-W><C-H>]], opts},
  {"n", ",d", [[<Cmd>bd!<CR>]], opts},
  {"n", ",c", [[<Cmd>cclose<CR>]], opts},
  {"v", "<", [[<gv]], opts},
  {"v", ">", [[>gv]], opts},
  {"n", "<leader>tt", [[<Cmd>TestNearest<CR>]], opts},
  {"n", "<leader>tT", [[<Cmd>TestFile<CR>]], opts},
  {"n", "<leader>n", [[<Cmd>cn<CR>]], opts},
  {"n", "<leader>p", [[<Cmd>cp<CR>]], opts},
  {"n", "<leader>G", [[<Cmd>FloatermNew --width=0.8 --height=0.6 lazygit<CR>]], opts},
}

for _, map in pairs(mappings) do
  vim.api.nvim_set_keymap(unpack(map))
end

local autocmds = {
  general = {
    {"BufWritePre", "*", [[Neoformat]]},
    {"BufWritePost init.vim nested source $MYVIMRC"},
  },
}

for filetype, _ in pairs(FILETYPE_HOOKS) do
  autocmds["LuaFileTypeHook_" .. utils.escape_keymap(filetype)] =
    {{"FileType", filetype, ("lua FILETYPE_HOOKS[%q]()"):format(filetype)}};
end

utils.nvim_create_augroups(autocmds)