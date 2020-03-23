--- The styling layer
-- @module l.style

local layer = {}

local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")

-- The startup buffer doesn't seem to pick up on vim.o changes >.<
local function set_default_win_opt(name, value)
  vim.o[name] = value
  autocmd.bind_vim_enter(function()
    vim.wo[name] = value
  end)
end

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("chriskempson/base16-vim") -- Base16 colors 
  plug.add_plugin("vim-airline/vim-airline") -- Sweet looking status line
  plug.add_plugin("vim-airline/vim-airline-themes") -- Sweet looking status line
  -- plug.add_plugin("itchyny/lightline.vim") -- Sweet looking status line
  -- plug.add_plugin("critiqjo/vim-bufferline") -- complement for lightline 
  -- plug.add_plugin("mengelbrecht/lightline-bufferline") -- complement for lightline 
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- Colors
  vim.o.termguicolors = true
  autocmd.bind_colorscheme(function()
    vim.cmd("highlight DiffAdd ctermfg=193 ctermbg=none guifg=#66CC6C guibg=none")
    vim.cmd("highlight DiffChange ctermfg=189 ctermbg=none guifg=#B166CC guibg=none")
    vim.cmd("highlight DiffDelete ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none")
  end)
  vim.api.nvim_command("colorscheme base16-seti")
  vim.g.airline_theme = "base16"

  -- Shorten updatetime from the default 4000 for quicker CursorHold updates
  -- Used for stuff like the VCS gutter updates
  vim.o.updatetime = 100

  -- Allow hidden buffers
  vim.o.hidden = true

  -- Line numbers and relative line numbers
  set_default_win_opt("number", true)
  set_default_win_opt("relativenumber", true)

  -- Highlight the cursor line
  set_default_win_opt("cursorline", true)

  -- Incremental search and incremental find/replace
  vim.o.incsearch = true
  vim.o.inccommand = "split"

  -- Use case-insensitive search if the entire search query is lowercase
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Highlight while searching
  vim.o.hlsearch = true

  -- Faster redrawing
  vim.o.lazyredraw = true

  -- Open splits on the right
  vim.o.splitright = true

  -- Show tabs and trailing whitespace
  set_default_win_opt("list", true)
  set_default_win_opt("listchars", "tab:│ ,eol: ,trail:·")

  -- Scroll 12 lines/columns before the edges of a window
  vim.o.scrolloff = 12
  vim.o.sidescrolloff = 12

  -- Show partial commands in the bottom right
  vim.o.showcmd = true

  -- Show line at column 100
  set_default_win_opt("colorcolumn", "100")

  -- Enable mouse support
  vim.o.mouse = "a"

  -- Use vim-airline's tabline, and enable powerline symbols
  vim.g.airline_powerline_fonts = 1
  vim.g["airline#extensions#tabline#enabled"] = 1

  -- 200ms timeout before which-key kicks in
  vim.g.timeoutlen = 200

  -- Reposition the which-key float slightly
  vim.g.which_key_floating_opts = { row = 1, col = -3, width = 3 }

  -- Always show the sign column
  set_default_win_opt("signcolumn", "yes")

  -- Configure lightline
  --[[
  vim.g.lightline = {
    'active' = {
      'left' = { { 'mode', 'paste' }, {'gitbranch', 'readonly', 'modified' } },
      'right' = { {'lineinfo'}, },
    }
    'tabline' = {'left' = { {'buffers'} } },
    'component_expand' = { 
      'buffers' = 'lightline#bufferline#buffers'
    },
    'component_function' = { 'gitbranch' = 'FugitiveHead' }
  }
  --]]


end

return layer
