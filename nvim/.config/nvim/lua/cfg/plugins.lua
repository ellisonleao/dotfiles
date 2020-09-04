local packer_exists = pcall(vim.cmd, "packadd packer.nvim")
if not packer_exists then
  local dest = string.format("%s/site/pack/packer/opt/", vim.fn.stdpath("data"))
  local repo_url = "https://github.com/wbthomason/packer.nvim"

  vim.fn.mkdir(dest, "p")

  print("Downloading packer")
  vim.fn.system(string.format("git clone %s %s", repo_url,
                              dest .. "/packer.nvim"))
  print("packer.nvim installed")
end

-- load plugins
return require("packer").startup(function(use)
  use {"wbthomason/packer.nvim"; opt = true}

  -- editor
  use {"tpope/vim-surround"}
  use {"tpope/vim-commentary"}
  use {"tpope/vim-repeat"}
  use {"vim-test/vim-test"}
  use {"junegunn/fzf"; run = ":call fzf#install()"}
  use {"junegunn/fzf.vim"}
  use {"npxbr/glow.nvim"; run = "GlowInstall"; cmd = "Glow"}

  -- git
  use {"tpope/vim-fugitive"}
  use {"tpope/vim-rhubarb"}
  use {"airblade/vim-gitgutter"}

  -- style
  use {"chriskempson/base16-vim"}
  use {"itchyny/lightline.vim"}
  -- use {"mengelbrecht/lightline-bufferline"}
  use {"ryanoasis/vim-devicons"}

  -- snippets
  use {"norcalli/snippets.nvim"}

  -- treesiter
  use {"nvim-treesitter/nvim-treesitter"}

  -- lsp
  use {"neovim/nvim-lspconfig"}
  use {"nvim-lua/completion-nvim"}
  use {"nvim-lua/lsp-status.nvim"}

  -- lua
  use {"andrejlevkovitch/vim-lua-format"}
  use {"tjdevries/nlua.nvim"}
  use {"euclidianAce/BetterLua.vim"}

  -- go
  use {"fatih/vim-go"; run = "GoUpdateBinaries"}

  -- python
  use {"psf/black"; branch = "stable"}

  -- html
  use {"mattn/emmet-vim"; ft = {"html"; "css"; "scss"}}
end)
