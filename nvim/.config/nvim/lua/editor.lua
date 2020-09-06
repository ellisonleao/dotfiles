local editor = {}
require("nvim_utils")

function editor.set_globals()
  nvim.g.mapleader = "\\"
  nvim.g.maplocalleader = ","
  nvim.g.python3_host_prog = nvim.fn.expand("~/.pyenv/versions/3.8.2/bin/python")
  nvim.g.python_host_prog = nvim.fn.expand("~/.pyenv/versions/2.7.17/bin/python")
  nvim.fn["test#strategy"] = "neovim"
  nvim.g.fzf_preview_window = "right:60%"
end

function editor.set_options()
  local options = {
    path = nvim.o.path .. ',' .. nvim.env.PWD;
    autoread = true;
    background = "dark";
    cmdheight = 2;
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
    shortmess = nvim.o.shortmess .. "c";
    scrolloff = 12;
    mouse = nvim.o.mouse .. "a";
    completeopt = "menuone,noinsert,noselect";
    relativenumber = true;
    number = true;
  }

  for k, v in pairs(options) do
    nvim.o[k] = v
  end

end

function editor.set_style()
  require("colorizer").setup()
  local base16 = require("base16")
  base16(base16.themes["gruvbox-dark-hard"], true)
end

editor.FILETYPE_HOOKS = {
    sql = function()
      nvim.bo.commentstring = "-- %s"
    end;
    json = function()
      -- setl formatprg=json_reformat shiftwidth=4 tabstop=4
      nvim.bo.formatprg = "prettier"
      nvim.bo.shiftwidth = 4
      nvim.bo.tabstop = 4
    end;
    go = function()
      local build = function ()
	local file = nvim.fn.expand('%')
	local is_test_file = file:sub(-#"_test.go") == "_test.go"
	if is_test_file then
	  nvim.call("go#test#Test", {0, 1})
	else
	  nvim.call("go#cmd#Build", 0)
	end
      end

      local mappings = {
	["n<leader>c"] = {"<Plug>(go-coverage-toggle)", {buffer=true; silent=true;}};
	["n<leader>r"] = {"<Plug>(go-run)", {buffer=true; silent=true;}};
	["n<leader>l"] = {"<Plug>(go-metalinter)", {buffer=true; silent=true;}};
	["n<leader>b"] = {build, {buffer=true; silent=true;}};
      }

      nvim.bo.shiftwidth = 4
      nvim.bo.tabstop = 4

      -- vim-test
      nvim.g["test#go#executable"] = "go test -v"

      -- vim-go vars
      nvim.g.go_fmt_command = "goimports"
      nvim.g.go_list_type = "quickfix"
      nvim.g.go_addtags_transform = "camelcase"
      nvim.g.go_metalinter_command = "golangci-lint run --fix --out-format tab"
      nvim.g.go_metalinter_enabled = {}
      nvim.g.go_metalinter_autosave_enabled = {}

      nvim_apply_mappings(mappings, { buffer = true; silent = true; })
    end;
    python = function()
      nvim.g["test#python#runner"] = "pytest"
    end;
  }

--- Configures nvim.o for this layer
function editor.config()
  editor.set_globals()
  editor.set_options()
  editor.set_style()

  local rg_cmd =
  "rg --column --line-number --no-heading --color=always --smart-case -- "
  vim.cmd("command! -bang -nargs=* Find call fzf#vim#grep('" .. rg_cmd ..
  "'.shellescape(<q-args>), 1, fzf#vim#with_preview(), <bang>0)")

  local mappings = {
    -- Edit config, reload config, and update plugins
    ["n<leader>red"] = {[[:edit $HOME/.config/nvim/lua/init.lua]] , noremap=true};
    ["n<leader>reR"] = {[[:luafile $HOME/.config/nvim/lua/init.lua<CR>]] , noremap=true};
    ["n<leader>reU"] = {[[:PackerSync<CR>]] , noremap=true};

    -- search
    ["n<leader>f"] = {[[:Find<CR>]] , noremap=true};
    ["n<leader>\\"] = {[[:noh<CR>]] , noremap=true};

    -- Terminal navigation
    ["n,z"] = {[[:bp<CR>]] , noremap=true};
    ["n,q"] = {[[:bp<CR>]] , noremap=true};
    ["n,x"] = {[[:bn<CR>]] , noremap=true};
    ["n,w"] = {[[:bn<CR>]] , noremap=true};

    -- buffer navigation
    ["n,j"] = {[[<C-W><C-J>]] , noremap=true};
    ["n,k"] = {[[<C-W><C-K>]] , noremap=true};
    ["n,l"] = {[[<C-W><C-L>]] , noremap=true};
    ["n,h"] = {[[<C-W><C-H>]] , noremap=true};

    -- close buffer and quickfix
    ["n,d"] = {[[:bd!<CR>]] , noremap=true};
    ["n,c"] = {[[:cclose<CR>]] , noremap=true};

    -- " Vmap for maintain Visual Mode after shifting > and <
    ["v<"] = {[[<gv]]};
    ["v>"] = {[[>gv]]};

    -- vim-test bindings
    ["n<leader>tt"] = {[[:TestNearest<CR>]]};
    ["n<leader>tT"] = {[[:TestFile<CR>]]};

    -- quickfix list navigation
    ["n<leader>n"] = {[[:cn<CR>]]};
    ["n<leader>p"] = {[[:cp<CR>]]};

    -- md floating preview
    ["n<leader>m"] = {[[:Glow<CR>]]};
  }

  nvim_apply_mappings(mappings)

  vim.cmd [[
  function! DeleteTrailingWS()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
  endfunction
  ]]

  vim.cmd [["command! -nargs=+ Li :lua print(vim.inspect(<args>)) ]]

  local autocmds = {
    general = {
      {"BufWritePre", "*", [[silent call DeleteTrailingWS()]]};
      {"BufWritePost init.vim nested source $MYVIMRC"};
    }
  }

  for filetype, _ in pairs(editor.FILETYPE_HOOKS) do
    -- Escape the name to be compliant with augroup names.
    autocmds["LuaFileTypeHook_"..filetype] = {
      {"FileType", filetype, ("lua require('editor').FILETYPE_HOOKS[%q]()"):format(filetype)};
    };
  end

  nvim_create_augroups(autocmds)

end

return editor
