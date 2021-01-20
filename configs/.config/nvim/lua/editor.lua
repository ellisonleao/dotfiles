local utils = require("modules.utils")

local function set_globals()
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ","
  vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/3.8.2/bin/python")
  vim.g.python_host_prog = vim.fn.expand("~/.pyenv/versions/2.7.17/bin/python")
  vim.g["test#strategy"] = "floaterm"
  vim.g["test#python#runner"] = "pytest"
  vim.g.floaterm_height = 0.8
  vim.g.floaterm_width = 0.8
  vim.g.diagnostic_enable_virtual_text = true
  vim.g.startify_custom_header = vim.fn.split(
                                   [[
     .:::.           `oyyo:`  `.--.`                        
    `ys/+sy+.-:///:` :y/.:syoysoo+oss:  ``          ```     
    .yo```-yso/::/oy//y:```:-.``````/ysysys-    -/oyssys`   
    .yo````.```````/yyy:`````-:/.````++.``oy/ /ys/-``.ys`   
    `yo`````.//.````oyy/````/yoys.```.:````+ysy/````-ys.    
    `ys````.ysys````-yy/````/y/+y:````s:````oy:````-ys`     
     yy````-y+sy````.yy+````:y/sy.```.yy:````-````:yo`      
     oy.```:y+yy````-yy+````:y+ys````/yyy:```````/y+        
     +y-```:yoys````/yyo````:ysy+````sy`oy/`````oy/         
     /y:```:ysyo````syys````:yyy-```/y/`oy:````.yy`         
     -y+```:ysy+```.yoyy````.sys```.ys`oy:``````-ys`        
     .yo```:yyy/```/y:sy``````..```oy:oy/```:+```:yo        
      yy```/yyy:```sy`oy.```-////+sy/+y/```+yyo.``/y/       
      oy.``+yyy:``:y+ +y-```/y+::-. -yo``.sy:-ys-``oy-      
      /y/-oy+:ys//sy. /y/```/y-     `sy:/ys.  `+yo:-ys      
      `+oo/.  `-:::`  -y+```+y-      `:++:      `:+ss/      
                      .yo```+y.                             
                       ys```oy.                             
                       sy.``sy`                             
                       /y:.oy/                              
                       `oys+.]], "\n")
end

local function set_options()
  local options = {
    autoread = true,
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
    clipboard = "unnamedplus",
  }
  for k, v in pairs(options) do
    vim.o[k] = v
  end

  vim.wo.relativenumber = true
  vim.wo.number = true

  vim.bo.shiftwidth = 2
  vim.bo.softtabstop = 2
  vim.bo.tabstop = 2
  vim.bo.swapfile = false
end

local function set_colors()
  vim.g.gruvbox_italic_strings = true
  vim.g.gruvbox_invert_selection = false
  require("colorbuddy").colorscheme("gruvbox")
  -- vim.o.background = "dark"
  -- vim.cmd("colorscheme PaperColor")
end

FILETYPE_HOOKS = {
  lua = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
    vim.bo.tabstop = 2
  end,
  go = function()
    local opts = {noremap = true}
    local mappings = {
      {"n", "<leader>lk", [[<Cmd>call go#lsp#Restart()<CR>]], opts},
      {"n", "<leader>l", [[<Cmd>GoMetaLinter<CR>]], opts},
      {"n", "<leader>ga", [[<Cmd>GoAlternate<CR>]], opts},
      {"n", "<leader>gc", [[<Cmd>GoCoverageToggle<CR>]], opts},
    }
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.bo.tabstop = 4
    vim.wo.colorcolumn = "80,120"

    -- disable vim-go snippet engine
    vim.g.go_snippet_engine = ""

    -- vim-go vars
    vim.g.go_list_type = "quickfix"
    vim.g.go_addtags_transform = "camelcase"
    vim.g.go_metalinter_enabled = {}
    vim.g.go_metalinter_autosave_enabled = {}
    vim.g.go_doc_popup_window = true

    for _, map in pairs(mappings) do
      vim.api.nvim_buf_set_keymap(0, unpack(map))
    end
  end,
  python = function()
    vim.g["test#python#runner"] = "pytest"
  end,
  viml = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
  html = function()
    vim.bo.shiftwidth = 4
    vim.bo.softtabstop = 4
    vim.api.nvim_set_keymap("i", "<tab>", "emmet#expandAbbrIntelligent('<tab>')",
                            {expr = true})
    vim.cmd("EmmetInstall")
    vim.g.user_emmet_install_global = 0
  end,
  proto = function()
    vim.bo.shiftwidth = 2
    vim.bo.softtabstop = 2
  end,
  yaml = function()
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
set_colors()

local opts = {noremap = true, silent = true}
local mappings = {
  {"n", "<leader>red", [[<Cmd>edit $HOME/.config/nvim/lua/editor.lua<CR>]], opts},
  {"n", "<leader>reR", [[<Cmd>lua R("editor")<CR>]], opts},
  {"n", "<leader>reU", [[<Cmd>PackerSync<CR>]], opts},
  {"n", "<leader>\\", [[<Cmd>noh<CR>]], opts},
  {"n", ",z", [[<Cmd>bp<CR>]], opts},
  {"n", ",q", [[<Cmd>bp<CR>]], opts},
  {"n", ",x", [[<Cmd>bn<CR>]], opts},
  {"n", ",w", [[<Cmd>bn<CR>]], opts},
  {"n", ",h", [[<C-W><C-H>]], opts},
  {"n", ",j", [[<C-W><C-J>]], opts},
  {"n", ",k", [[<C-W><C-K>]], opts},
  {"n", ",l", [[<C-W><C-L>]], opts},
  {"n", ",d", [[<Cmd>bd!<CR>]], opts},
  {"n", ",c", [[<Cmd>cclose<CR>]], opts},
  {"n", "<leader>c", [[<Cmd>cclose<CR>]], opts},
  {"v", "<", [[<gv]], opts},
  {"v", ">", [[>gv]], opts},
  {"n", "<leader>t", [[<Cmd>TestNearest<CR>]], opts},
  {"n", "<leader>tT", [[<Cmd>TestFile<CR>]], opts},
  {"n", "<leader>n", [[<Cmd>cn<CR>]], opts},
  {"n", "<leader>p", [[<Cmd>cp<CR>]], opts},
  {"n", "<leader>G", [[<Cmd>FloatermNew --width=0.8 --height=0.8 lazygit<CR>]], opts},
  {"n", "<leader>W", [[<Cmd>Weather<CR>]], opts},
}

for _, map in pairs(mappings) do
  vim.api.nvim_set_keymap(unpack(map))
end

local autocmds = {
  general = {
    {"BufWritePost init.vim nested source $MYVIMRC"},
    {
      "BufReadPost",
      "*",
      [[if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif]],
    },
  },
}

for filetype, _ in pairs(FILETYPE_HOOKS) do
  autocmds["LuaFileTypeHook_" .. utils.escape_keymap(filetype)] =
    {{"FileType", filetype, ("lua FILETYPE_HOOKS[%q]()"):format(filetype)}};
end

utils.nvim_create_augroups(autocmds)
