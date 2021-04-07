" Automatically generated packer.nvim plugin loader code

if !has('nvim-0.5')
  echohl WarningMsg
  echom "Invalid Neovim version for packer.nvim!"
  echohl None
  finish
endif

packadd packer.nvim

try

lua << END
local package_path_str = "/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?.lua;/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/share/lua/5.1/?/init.lua;/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?.lua;/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/luarocks/rocks-5.1/?/init.lua"
local install_cpath_pattern = "/home/ellison/.cache/nvim/packer_hererocks/2.1.0-beta3/lib/lua/5.1/?.so"
if not string.find(package.path, package_path_str, 1, true) then
  package.path = package.path .. ';' .. package_path_str
end

if not string.find(package.cpath, install_cpath_pattern, 1, true) then
  package.cpath = package.cpath .. ';' .. install_cpath_pattern
end

local function try_loadstring(s, component, name)
  local success, result = pcall(loadstring(s))
  if not success then
    print('Error running ' .. component .. ' for ' .. name)
    error(result)
  end
  return result
end

_G.packer_plugins = {
  ["babelfish.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/babelfish.nvim"
  },
  ["formatter.nvim"] = {
    config = { "\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22modules.formatter\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/formatter.nvim"
  },
  fzf = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/fzf"
  },
  ["gitsigns.nvim"] = {
    config = { "\27LJ\2\nD\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nnumhl\2\nsetup\rgitsigns\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/gitsigns.nvim"
  },
  ["glow.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/glow.nvim"
  },
  ["gruvbox.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/gruvbox.nvim"
  },
  kommentary = {
    config = { "\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1 prefer_single_line_comments\2\fdefault\23configure_language\22kommentary.config\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/kommentary"
  },
  ["lspsaga.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/lspsaga.nvim"
  },
  ["lualine.nvim"] = {
    config = { "\27LJ\2\n\4\0\0\a\0\27\0+6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0034\4\3\0005\5\t\0>\5\1\0045\5\n\0005\6\v\0=\6\f\5>\5\2\4=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\3=\3\20\0025\3\21\0004\4\0\0=\4\6\0034\4\0\0=\4\b\0035\4\22\0=\4\r\0035\4\23\0=\4\15\0034\4\0\0=\4\17\0034\4\0\0=\4\19\3=\3\24\0025\3\25\0=\3\26\2B\0\2\1K\0\1\0\15extensions\1\2\0\0\rfugitive\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\fsources\1\2\0\0\rnvim_lsp\1\2\0\0\16diagnostics\1\2\1\0\rfilename\14full_path\2\14lualine_b\1\2\0\0\vbranch\14lualine_a\1\0\0\1\2\0\0\tmode\1\0\2\14separator\6|\ntheme\fgruvbox\nsetup\flualine\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/lualine.nvim"
  },
  ["lush.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/lush.nvim"
  },
  ["nvim-bufferline.lua"] = {
    config = { "\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15bufferline\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-bufferline.lua"
  },
  ["nvim-colorizer.lua"] = {
    config = { "\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-colorizer.lua"
  },
  ["nvim-compe"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-compe"
  },
  ["nvim-dap"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-dap"
  },
  ["nvim-lspconfig"] = {
    config = { "\27LJ\2\nH\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\2\0B\0\2\1K\0\1\0\16modules.lsp\21modules.snippets\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-lspconfig"
  },
  ["nvim-lspinstall"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-lspinstall"
  },
  ["nvim-treesitter"] = {
    config = { "\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vconfig\23modules.treesitter\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-treesitter"
  },
  ["nvim-web-devicons"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/nvim-web-devicons"
  },
  ["packer.nvim"] = {
    loaded = false,
    needs_bufread = false,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/opt/packer.nvim"
  },
  ["plenary.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/plenary.nvim"
  },
  ["popup.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/popup.nvim"
  },
  ["presence.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/presence.nvim"
  },
  ["snippets.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/snippets.nvim"
  },
  ["telescope-dap.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/telescope-dap.nvim"
  },
  ["telescope-fzy-native.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/telescope-fzy-native.nvim"
  },
  ["telescope.nvim"] = {
    config = { "\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19modules.search\frequire\0" },
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/telescope.nvim"
  },
  ["vim-dadbod"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-dadbod"
  },
  ["vim-dirvish"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-dirvish"
  },
  ["vim-floaterm"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-floaterm"
  },
  ["vim-fugitive"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-fugitive"
  },
  ["vim-repeat"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-repeat"
  },
  ["vim-rhubarb"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-rhubarb"
  },
  ["vim-startify"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-startify"
  },
  ["vim-surround"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-surround"
  },
  ["vim-test"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/vim-test"
  },
  ["weather.nvim"] = {
    loaded = true,
    path = "/home/ellison/.local/share/nvim/site/pack/packer/start/weather.nvim"
  }
}

-- Config for: kommentary
try_loadstring("\27LJ\2\n|\0\0\4\0\5\0\b6\0\0\0'\2\1\0B\0\2\0029\0\2\0'\2\3\0005\3\4\0B\0\3\1K\0\1\0\1\0\1 prefer_single_line_comments\2\fdefault\23configure_language\22kommentary.config\frequire\0", "config", "kommentary")
-- Config for: gitsigns.nvim
try_loadstring("\27LJ\2\nD\0\0\3\0\4\0\a6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0B\0\2\1K\0\1\0\1\0\1\nnumhl\2\nsetup\rgitsigns\frequire\0", "config", "gitsigns.nvim")
-- Config for: nvim-colorizer.lua
try_loadstring("\27LJ\2\n7\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\14colorizer\frequire\0", "config", "nvim-colorizer.lua")
-- Config for: formatter.nvim
try_loadstring("\27LJ\2\n1\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\22modules.formatter\frequire\0", "config", "formatter.nvim")
-- Config for: nvim-treesitter
try_loadstring("\27LJ\2\nA\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\vconfig\23modules.treesitter\frequire\0", "config", "nvim-treesitter")
-- Config for: nvim-lspconfig
try_loadstring("\27LJ\2\nH\0\0\3\0\3\0\a6\0\0\0'\2\1\0B\0\2\0016\0\0\0'\2\2\0B\0\2\1K\0\1\0\16modules.lsp\21modules.snippets\frequire\0", "config", "nvim-lspconfig")
-- Config for: telescope.nvim
try_loadstring("\27LJ\2\n.\0\0\3\0\2\0\0046\0\0\0'\2\1\0B\0\2\1K\0\1\0\19modules.search\frequire\0", "config", "telescope.nvim")
-- Config for: lualine.nvim
try_loadstring("\27LJ\2\n\4\0\0\a\0\27\0+6\0\0\0'\2\1\0B\0\2\0029\0\2\0005\2\3\0005\3\5\0005\4\4\0=\4\6\0035\4\a\0=\4\b\0034\4\3\0005\5\t\0>\5\1\0045\5\n\0005\6\v\0=\6\f\5>\5\2\4=\4\r\0035\4\14\0=\4\15\0035\4\16\0=\4\17\0035\4\18\0=\4\19\3=\3\20\0025\3\21\0004\4\0\0=\4\6\0034\4\0\0=\4\b\0035\4\22\0=\4\r\0035\4\23\0=\4\15\0034\4\0\0=\4\17\0034\4\0\0=\4\19\3=\3\24\0025\3\25\0=\3\26\2B\0\2\1K\0\1\0\15extensions\1\2\0\0\rfugitive\22inactive_sections\1\2\0\0\rlocation\1\2\0\0\rfilename\1\0\0\rsections\14lualine_z\1\2\0\0\rlocation\14lualine_y\1\2\0\0\rprogress\14lualine_x\1\4\0\0\rencoding\15fileformat\rfiletype\14lualine_c\fsources\1\2\0\0\rnvim_lsp\1\2\0\0\16diagnostics\1\2\1\0\rfilename\14full_path\2\14lualine_b\1\2\0\0\vbranch\14lualine_a\1\0\0\1\2\0\0\tmode\1\0\2\14separator\6|\ntheme\fgruvbox\nsetup\flualine\frequire\0", "config", "lualine.nvim")
-- Config for: nvim-bufferline.lua
try_loadstring("\27LJ\2\n8\0\0\3\0\3\0\0066\0\0\0'\2\1\0B\0\2\0029\0\2\0B\0\1\1K\0\1\0\nsetup\15bufferline\frequire\0", "config", "nvim-bufferline.lua")
END

catch
  echohl ErrorMsg
  echom "Error in packer_compiled: " .. v:exception
  echom "Please check your config for correctness"
  echohl None
endtry
