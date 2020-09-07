local editor = {}
local utils = require("utils")

function editor.set_globals()
  vim.g.mapleader = "\\"
  vim.g.maplocalleader = ","
  vim.g.python3_host_prog = vim.fn.expand("~/.pyenv/versions/3.8.2/bin/python")
  vim.g.python_host_prog = vim.fn.expand("~/.pyenv/versions/2.7.17/bin/python")
  vim.fn["test#strategy"] = "neovim"
  vim.g.fzf_preview_window = "right:60%"
  vim.g.neoformat_basic_format_trim = true
  vim.g.neoformat_try_formatprg = true
end

function editor.set_options()
  local options = {
    -- path = vim.o.path .. ',' .. nvim.env.PWD;
    autoread = true;
    background = "dark";
    swapfile = false;
    hidden = true;
    ignorecase = true;
    inccommand = "nosplit";
    incsearch = true;
    laststatus = 2;
    listchars = [[eol:$,tab:>-,trail:~,extends:>,precedes:<]];
    modeline = true;
    shada = [[!,'500,<50,s10,h]];
    showcmd = true;
    showmode = false;
    smartcase = true;
    splitbelow = true;
    splitright = true;
    startofline = false;
    termguicolors = true;
    textwidth = 88;
    title = true;
    titlestring = "%{join(split(getcwd(), '/')[-2:], '/')}";
    viminfo = [[!,'300,<50,s10,h]];
    wildignorecase = true;
    wildmenu = true;
    wildmode = "list:longest";
    -- wildmode = "longest:full,full";
    tabstop = 4;
    shiftwidth = 4;
    softtabstop = 4;
    expandtab = true;
    autoindent = true;
    smartindent = true;
    shortmess = vim.o.shortmess .. "c";
    scrolloff = 12;
    mouse = vim.o.mouse .. "a";
    completeopt = "menuone,noinsert,noselect";
    relativenumber = true;
    number = true;
  }

  for k, v in pairs(options) do
    vim.o[k] = v
  end

end

editor.FILETYPE_HOOKS = {
  javascriptreact = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4
  end;
  go = function()
    local opts = {silent = true; noremap = true}
    local mappings = {
      {"n"; "<leader>c"; "<Plug>(go-coverage-toggle)"; opts};
      {"n"; "<leader>r"; "<Plug>(go-run)"; opts};
      {"n"; "<leader>l"; "<Plug>(go-metalinter)"; opts};
    }

    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.softtabstop = 4

    -- vim-test
    vim.g["test#go#executable"] = "go test -v"

    -- vim-go vars
    vim.g.go_fmt_command = "goimports"
    vim.g.go_list_type = "quickfix"
    vim.g.go_addtags_transform = "camelcase"
    vim.g.go_metalinter_command = "golangci-lint run --fix --out-format tab"
    vim.g.go_metalinter_enabled = {}
    vim.g.go_metalinter_autosave_enabled = {}

    for _, map in pairs(mappings) do
      vim.api.nvim_buf_set_keymap(0, unpack(map))
    end
  end;
  python = function()
    vim.g["test#python#runner"] = "pytest"
    vim.g.neoformat_enabled_python = {"black"}
  end;
  lua = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2

    vim.g.neoformat_lua_luaformat = {
      exe = "lua-format";
      args = {"-c " .. vim.fn.expand("~/.config/nvim/lua/.lua-format")};
    }
    vim.g.neoformat_enabled_lua = {"luaformat"}

    vim.api.nvim_buf_set_keymap(0, "n", "<leader>r", ":luafile %<cr>",
                                {noremap = true; silent = true})
  end;
}

function editor.config()
  editor.set_globals()
  editor.set_options()
  require("modules.statusline")

  local rg_cmd =
    "rg --column --line-number --no-heading --color=always --smart-case -- "
  vim.cmd("command! -bang -nargs=* Find call fzf#vim#grep('" .. rg_cmd ..
            "'.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)")

  local opts = {noremap = true; silent = true}
  local mappings = {
    -- Edit config, reload config, and update plugins
    {"n"; "<leader>red"; [[:edit $HOME/.config/nvim/lua/init.lua]]; opts};
    {"n"; "<leader>reR"; [[:luafile $HOME/.config/nvim/lua/init.lua<CR>]]; opts};
    {"n"; "<leader>reU"; [[:PackerSync<CR>]]; opts}; -- search
    {"n"; "<leader>f"; [[:Find<CR>]]; opts};
    {"n"; "<leader>\\"; [[:noh<CR>]]; opts}; -- Terminal navigation
    {"n"; ",z"; [[:bp<CR>]]; opts}; {"n"; ",q"; [[:bp<CR>]]; opts};
    {"n"; ",x"; [[:bn<CR>]]; opts}; {"n"; ",w"; [[:bn<CR>]]; opts}; -- buffer navigation
    {"n"; ",j"; [[<C-W><C-J>]]; opts}; {"n"; ",k"; [[<C-W><C-K>]]; opts};
    {"n"; ",l"; [[<C-W><C-L>]]; opts}; {"n"; ",m"; [[<C-W><C-H>]]; opts}; -- close buffer and quickfix
    {"n"; ",d"; [[:bd!<CR>]]; opts}; {"n"; ",c"; [[:cclose<CR>]]; opts};

    -- " Vmap for maintain Visual Mode after shifting > and <
    {"v"; "<"; [[<gv]]; opts}; {"v"; ">"; [[>gv]]; opts}; -- vim-test bindings
    {"n"; "<leader>tt"; [[:TestNearest<CR>]]; opts}; -- quickfix list navigation
    {"n"; "<leader>tT"; [[:TestFile<CR>]]; opts};
    {"n"; "<leader>n"; [[:cn<CR>]]; opts};
    {"n"; "<leader>p"; [[:cp<CR>]]; opts}; -- md floating preview
    {"n"; "<leader>m"; [[:Glow<CR>]]; opts};
  }

  for _, map in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(0, unpack(map))
  end

  local autocmds = {
    general = {
      {"BufWritePre"; "*"; [[undojoin | Neoformat]]};
      {"BufWritePost init.vim nested source $MYVIMRC"};
    };
  }

  for filetype, _ in pairs(editor.FILETYPE_HOOKS) do
    autocmds["LuaFileTypeHook_" .. utils.escape_keymap(filetype)] =
      {
        {
          "FileType"; filetype;
          ("lua require('editor').FILETYPE_HOOKS[%q]()"):format(filetype);
        };
      };
  end

  utils.nvim_create_augroups(autocmds)

end

return editor
