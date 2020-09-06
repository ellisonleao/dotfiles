local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
if not packer_exists then
  local dest = string.format("%s/site/pack/packer/opt/", vim.fn.stdpath("data"))
  local repo_url = "https://github.com/wbthomason/packer.nvim"

  vim.fn.mkdir(dest, "p")

  print("Downloading packer")
  vim.fn.system(string.format("git clone %s %s", repo_url,
  dest .. "packer.nvim"))
  print("packer.nvim installed")
end


-- load plugins
return require("packer").startup(function(use)
  use {"wbthomason/packer.nvim"; opt = true}

  -- plugin dev
  use {"dstein64/vim-startuptime"}
  use {"norcalli/nvim_utils"}

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
  use {"norcalli/nvim-colorizer.lua"}
  use {"ryanoasis/vim-devicons"}
  use {"norcalli/nvim-base16.lua"}

  -- lsp
  -- Completion and linting
  use {
    "neovim/nvim-lspconfig";
    requires = {
      {"haorenW1025/completion-nvim"};
      {"nvim-lua/lsp-status.nvim"};
      {"nvim-lua/diagnostic-nvim"};
      {"norcalli/snippets.nvim"};
    };
  };

  use {"nvim-treesitter/nvim-treesitter", opt = true };

  -- lua
  use "andrejlevkovitch/vim-lua-format"
  use "euclidianAce/BetterLua.vim"

  -- go
  use {"fatih/vim-go"; run = "GoUpdateBinaries";}

  -- html
  use {"mattn/emmet-vim"; ft = {"html"; "css"; "scss"}}
end)
