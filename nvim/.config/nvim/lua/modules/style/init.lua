local plug = require("cfg.plug")
local autocmd = require("cfg.autocmd")
local layer = {}

function layer.register_plugins()
  plug.add_plugin("chriskempson/base16-vim")
  plug.add_plugin("vim-airline/vim-airline")
  plug.add_plugin("vim-airline/vim-airline-themes")
end

function layer.set_globals()
  vim.g.airline_theme = "base16"
  vim.g.number = true
  vim.g.relativenumber = true
  vim.g.list = true
  vim.g.listchars = "tab:│ ,eol: ,trail:·"
  vim.g.cursorline = true
  vim.g.airline_powerline_fonts = 1
  vim.g["airline#extensions#tabline#enabled"] = 1
  vim.g.timeoutlen = 200
  vim.g.which_key_floating_opts = {row = 1; col = -3; width = 3}
  vim.g.signcolumn = "yes"
end

function layer.set_options()
  vim.o.termguicolors = true
  vim.o.lazyredraw = true
  vim.o.splitright = true
  vim.o.updatetime = 1000
  vim.o.hidden = true
  vim.o.scrolloff = 12
  vim.o.sidescrolloff = 12
  vim.o.showcmd = true
  vim.o.mouse = ""
  vim.o.pumblend = 10
  vim.o.winblend = 10
  vim.o.colorcolumn = "88"
end

function layer.init_config()
  layer.set_globals()
  layer.set_options()

  autocmd.bind_colorscheme(function()
    vim.cmd("highlight DiffAdd ctermfg=193 ctermbg=none guifg=#66CC6C guibg=none")
    vim.cmd("highlight DiffChange ctermfg=189 ctermbg=none guifg=#B166CC guibg=none")
    vim.cmd("highlight DiffDelete ctermfg=167 ctermbg=none guifg=#CC6666 guibg=none")
    vim.cmd(
      "highlight LspDiagnosticsError ctermfg=167 ctermbg=none guifg=#EB4917 guibg=none")
    vim.cmd(
      "highlight LspDiagnosticsWarning ctermfg=167 ctermbg=none guifg=#EBA217 guibg=none")
    vim.cmd(
      "highlight LspDiagnosticsInformation ctermfg=167 ctermbg=none guifg=#17D6EB guibg=none")
    vim.cmd(
      "highlight LspDiagnosticsHint ctermfg=167 ctermbg=none guifg=#17EB7A guibg=none")

  end)
  vim.cmd("colorscheme base16-seti")

end

return layer
