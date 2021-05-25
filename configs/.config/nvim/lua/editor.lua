local utils = require("modules.utils")

local function set_globals()
  vim.g.mapleader = ","
  vim.g.maplocalleader = ","
  vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/3.8.2/bin/python")
  vim.g.python_host_prog = vim.fn.expand("~/.pyenv/versions/2.7.17/bin/python")
  vim.g["test#strategy"] = "floaterm"
  vim.g["test#python#runner"] = "pytest"
  vim.g.floaterm_height = 0.8
  vim.g.floaterm_width = 0.8
  vim.g.diagnostic_enable_virtual_text = false
end

-- helper function until https://github.com/neovim/neovim/pull/13479 arrives
local opts_info = vim.api.nvim_get_all_options_info()
local opt = setmetatable({}, {
  __index = vim.o,
  __newindex = function(_, key, value)
    vim.o[key] = value
    local scope = opts_info[key].scope
    if scope == "win" then
      vim.wo[key] = value
    elseif scope == "buf" then
      vim.bo[key] = value
    end
  end,
})

local function set_ui_options()
  opt.termguicolors = true
  opt.mouse = "a"
  opt.title = true
  opt.titlestring = "%{join(split(getcwd(), '/')[-2:], '/')}"
  opt.number = true
  opt.relativenumber = true
  opt.colorcolumn = "120"

  -- colorscheme configs
  vim.g.gruvbox_italicize_comments = true
  vim.g.gruvbox_invert_selection = false
  vim.g.gruvbox_contrast_dark = "hard"
  vim.g.gruvbox_sign_column = "bg0"
  vim.cmd([[colorscheme gruvbox]])
end

local function set_editor_options()
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
    textwidth = 120,
    viminfo = [[!,'300,<50,s10,h]],
    wildignorecase = true,
    wildmenu = true,
    wildmode = "list:longest",
    updatetime = 500,
    autoindent = true,
    smartindent = true,
    shortmess = vim.o.shortmess .. "c",
    scrolloff = 12,
    completeopt = "menu,menuone,noselect",
    clipboard = "unnamedplus",
    shiftwidth = 2,
    softtabstop = 2,
    tabstop = 2,
    swapfile = false,
    expandtab = true,
    foldmethod = "indent",
    foldlevelstart = 99,
  }
  for k, v in pairs(options) do
    opt[k] = v
  end

end

local function set_options()
  set_editor_options()
  set_ui_options()
end

FILETYPE_HOOKS = {
  lua = function()
    opt.shiftwidth = 2
    opt.softtabstop = 2
    opt.tabstop = 2
    vim.api.nvim_set_keymap("n", "<leader>S", [[<Cmd>luafile %<CR>]], {noremap = true}) -- execute current lua file
  end,
  go = function()
    local opts = {noremap = true}
    local mappings = {
      {"n", "<leader>lk", [[<Cmd>call go#lsp#Restart()<CR>]], opts},
      {"n", "<leader>l", [[<Cmd>GoMetaLinter<CR>]], opts},
      {"n", "<leader>ga", [[<Cmd>GoAlternate<CR>]], opts},
      {"n", "<leader>gc", [[<Cmd>GoCoverageToggle<CR>]], opts},
      {"n", "<leader>gg", [[<Cmd>GoGenerate<CR>]], opts},
    }
    opt.shiftwidth = 4
    opt.softtabstop = 4
    opt.tabstop = 4
    opt.colorcolumn = "80,120"

    -- disable vim-go snippet engine and gopls
    vim.g.go_snippet_engine = ""
    vim.g.go_gopls_enabled = false

    -- vim-go vars
    vim.g.go_list_type = "quickfix"
    vim.g.go_metalinter_enabled = {}
    vim.g.go_metalinter_autosave_enabled = {}
    vim.g.go_doc_popup_window = true

    for _, map in pairs(mappings) do
      vim.api.nvim_set_keymap(unpack(map))
    end
  end,
  python = function()
    vim.g["test#python#runner"] = "pytest"
  end,
  viml = function()
    opt.shiftwidth = 2
    opt.softtabstop = 2
    opt.tabstop = 2
  end,
  html = function()
    opt.shiftwidth = 4
    opt.softtabstop = 4
  end,
  proto = function()
    opt.shiftwidth = 2
    opt.softtabstop = 2
  end,
  yaml = function()
    opt.shiftwidth = 2
    opt.softtabstop = 2
  end,
  sh = function()
    opt.shiftwidth = 4
    opt.tabstop = 4
    opt.softtabstop = 4
  end,
}

set_globals()
set_options()

local opts = {noremap = true, silent = true}
local mappings = {
  {"n", "<leader>E", [[<Cmd>edit $HOME/.config/nvim/lua/editor.lua<CR>]], opts}, -- quick edit editor.lua file
  {"n", "<leader>P", [[<Cmd>edit $HOME/.config/nvim/lua/plugins.lua<CR>]], opts}, -- quick edit plugins.lua file
  {"n", "<leader>U", [[<Cmd>PackerSync<CR>]], opts}, -- Update all current plugins
  {"n", "<leader>R", [[<Cmd>lua RR()<CR>]], opts}, -- reload all custom modules
  {"n", "<leader>,", [[<Cmd>noh<CR>]], opts}, -- clear search highlight
  {"n", "<leader>z", [[<Cmd>bp<CR>]], opts}, -- move to the previous buffer
  {"n", "<leader>q", [[<Cmd>bp<CR>]], opts}, -- move to the previous buffer (same option, different key)
  {"n", "<leader>x", [[<Cmd>bn<CR>]], opts}, -- move to the next buffer
  {"n", "<leader>w", [[<Cmd>bn<CR>]], opts}, -- move to the next buffer (same option, different key)
  {"n", "<leader>d", [[<Cmd>bd<CR>]], opts}, -- close current buffer
  {"n", "<leader>c", [[<Cmd>cclose<CR>]], opts}, -- close quickfix list
  {"n", "<leader>h", [[<Cmd>split<CR>]], opts}, -- create horizontal split
  {"n", "<leader>v", [[<Cmd>vsplit<CR>]], opts}, -- create vertical split
  {"n", "<leader>gc", [[<Cmd>Git commit<CR>]], opts}, -- shortcut to git commit command
  {"n", "<leader>gs", [[<Cmd>Gstatus<CR>]], opts}, -- shortcut to git status command
  {"n", "<leader>gp", [[<Cmd>Git push<CR>]], opts}, -- shortcut to git push command
  {"v", "<", [[<gv]], opts}, -- move code forward in visual mode
  {"v", ">", [[>gv]], opts}, -- move code backwards in visual mode
  {"n", "<leader>t", [[<Cmd>TestNearest<CR>]], opts}, -- call test for function in cursor
  {"n", "<leader>tT", [[<Cmd>TestFile<CR>]], opts}, -- call test for current file
  {"n", "<leader>n", [[<Cmd>cn<CR>]], opts}, -- move to next item in quickfix list
  {"n", "<leader>p", [[<Cmd>cp<CR>]], opts}, -- move to prev item in quickfix list
  {"n", "<leader>G", [[<Cmd>FloatermNew --width=0.8 --height=0.8 lazygit<CR>]], opts}, -- open lazygit in a floating term
  {"n", "<leader>W", [[<Cmd>Weather<CR>]], opts}, -- calls weather plugin
}

for _, map in pairs(mappings) do
  vim.api.nvim_set_keymap(unpack(map))
end

local autocmds = {
  general = {
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
