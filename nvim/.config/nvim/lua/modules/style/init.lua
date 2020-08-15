local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local vcmd = vim.cmd
local layer = {}

function layer.register_plugins()
  plug.add_plugin("chriskempson/base16-vim")
  plug.add_plugin("itchyny/lightline.vim")
  plug.add_plugin("mengelbrecht/lightline-bufferline")
  plug.add_plugin("ryanoasis/vim-devicons")
end

local function set_globals()
  vim.g.airline_theme = "base16"

  -- lightline config
  vim.g.lightline = {
    active = {
      left = {
        {"mode"; "paste"};
        {"gitbranch"; "readonly"; "filename"; "modified"; "lineinfo"};
      };
      right = {{"lsp"}};
    };
    tabline = {left = {{"buffers"}}; right = {{"close"}}};
    component_function = {gitbranch = "FugitiveHead"; lsp = "LspStatus"};
    component_expand = {buffers = "lightline#bufferline#buffers"};
    component_type = {buffers = "tabsel"};
  }
end

local function set_options()
  vim.wo.signcolumn = "yes"
  vim.o.timeoutlen = 200
  vim.o.termguicolors = true
  vim.o.showtabline = 3
  vim.o.lazyredraw = true
  vim.o.splitright = true
  vim.o.updatetime = 1000
  vim.o.hidden = true
  vim.o.scrolloff = 12
  vim.o.mouse = vim.o.mouse .. "a"
  vim.o.pumblend = 10
  vim.o.winblend = 10
  vim.wo.cursorline = true
  vim.wo.listchars = "tab:│ ,eol: ,trail:·"
  vim.wo.list = true
  vim.wo.relativenumber = true
  vim.wo.colorcolumn = "88"
end

function layer.init_config()
  set_globals()
  set_options()

  autocmd.bind_colorscheme(function()
    vcmd("highlight DiffAdd ctermfg=193 ctermbg=none guifg=#66CC6C guibg=none")
    vcmd("highlight DiffChange ctermfg=189 ctermbg=none guifg=#B166CC guibg=none")
    vcmd("highlight DiffDelete ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none")
    vcmd(
      "highlight LspDiagnosticsError ctermfg=167 ctermbg=none guifg=#EB4917 guibg=none")
    vcmd(
      "highlight LspDiagnosticsWarning ctermfg=167 ctermbg=none guifg=#EBA217 guibg=none")
    vcmd(
      "highlight LspDiagnosticsInformation ctermfg=167 ctermbg=none guifg=#17D6EB guibg=none")
    vcmd(
      "highlight LspDiagnosticsHint ctermfg=167 ctermbg=none guifg=#17EB7A guibg=none")

  end)
  vcmd("colorscheme base16-gruvbox-dark-hard")

end

return layer
