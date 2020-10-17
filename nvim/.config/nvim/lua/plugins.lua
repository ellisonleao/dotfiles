local packer_exists = pcall(vim.cmd, [[ packadd packer.nvim ]])
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
  use {"mhinz/vim-startify"}
  use {"voldikss/vim-floaterm"}

  -- local
  use {"~/code/twitch.nvim"}

  -- plugin development and utils
  use {"dstein64/vim-startuptime"}
  use {"nvim-lua/plenary.nvim"}

  -- repl
  use {
    "hkupty/iron.nvim",
    config = function()
      require("modules.iron").config()
    end,
    cmd = {"IronRepl", "IronSend", "IronWatchCurrentFile"},
  }

  -- editor
  use {"tpope/vim-surround"}
  use {"tpope/vim-commentary"}
  use {"tpope/vim-repeat"}
  use {"vim-test/vim-test"}
  use {"junegunn/fzf", run = ":call fzf#install()"}
  use {"sbdchd/neoformat"}
  use {
    "Akin909/nvim-bufferline.lua",
    config = function()
      require("bufferline").setup()
    end,
  }

  -- colors & style
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("modules.treesitter").config()
    end,
  }

  use {
    "gruvbox-community/gruvbox",
    config = function()
      vim.g.gruvbox_italics = true
      vim.g.gruvbox_contrast_dark = "hard"
      vim.cmd("colorscheme gruvbox")
    end,
  }

  -- search
  use {
    "nvim-lua/telescope.nvim",
    config = function()
      require("modules.search")
    end,
    requires = {"nvim-lua/popup.nvim"},
  }

  -- git
  use {"tpope/vim-rhubarb"}
  use {"mhinz/vim-signify"}

  -- lsp, completion, linting and snippets
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("modules.lsp")
      require("modules.snippets")
    end,
    requires = {
      "nvim-lua/completion-nvim",
      "nvim-lua/diagnostic-nvim",
      "nvim-lua/lsp-status.nvim",
      "nvim-lua/completion-nvim",
      "norcalli/snippets.nvim",
    },
  }
  -- statusline
  use {"kyazdani42/nvim-web-devicons"}
  use {
    "tjdevries/express_line.nvim",
    config = function()
      require("modules.statusline")
    end,
  }

  -- go
  use {"fatih/vim-go", run = ":GoUpdateBinaries", ft = {"go"}}

  -- html/css
  use {
    "mattn/emmet-vim",
    ft = {"html", "css", "scss"},
    config = function()
      require("modules.html")
    end,
  }

end)
