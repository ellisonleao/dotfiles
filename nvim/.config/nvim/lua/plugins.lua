local packer_exists = pcall(vim.cmd, [[packadd packer.nvim]])
if not packer_exists then
  local dest = string.format("%s/site/pack/packer/opt/", vim.fn.stdpath("data"))
  local repo_url = "https://github.com/wbthomason/packer.nvim"

  vim.fn.mkdir(dest, "p")

  print("Downloading packer")
  vim.fn.system(string.format("git clone %s %s", repo_url, dest .. "packer.nvim"))
  print("packer.nvim installed")
end

-- load plugins
return require("packer").startup(function(use)
  use {"wbthomason/packer.nvim", opt = true}

  -- plugin development and utils
  use {"dstein64/vim-startuptime"}
  use {"nvim-lua/plenary.nvim"}

  -- editor
  use {"tpope/vim-surround"}
  use {"tpope/vim-commentary"}
  use {"tpope/vim-repeat"}
  use {"vim-test/vim-test"}
  use {"junegunn/fzf", run = ":call fzf#install()"}
  use {"junegunn/fzf.vim"}
  use {"npxbr/glow.nvim", run = ":GlowInstall", cmd = "Glow"}
  use {"sbdchd/neoformat"}
  use {"ap/vim-buftabline"}

  -- colors & style
  use {"tjdevries/colorbuddy.nvim"}
  use {"tjdevries/gruvbuddy.nvim"}
  use {"euclidianAce/BetterLua.vim"}
  use {"ryanoasis/vim-devicons"}

  -- git
  use {"tpope/vim-fugitive"}
  use {"tpope/vim-rhubarb"}
  use {"airblade/vim-gitgutter"}

  -- style

  -- statusline
  use {"tjdevries/express_line.nvim"}

  -- lsp, completion, linting and snippets
  use {"norcalli/snippets.nvim"}
  use {"nvim-lua/completion-nvim"}
  use {"nvim-lua/diagnostic-nvim"}
  use {"nvim-lua/lsp-status.nvim"}
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("modules.lsp")
    end,
  }

  -- go
  use {"fatih/vim-go", run = ":GoUpdateBinaries"}

  -- html
  use {"mattn/emmet-vim", ft = {"html", "css", "scss"}}
end)
