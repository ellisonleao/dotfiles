local packer_exists = pcall(vim.cmd, [[ packadd packer.nvim ]])
if not packer_exists then
  local dest = string.format("%s/site/pack/packer/opt/", vim.fn.stdpath("data"))
  local repo_url = "https://github.com/wbthomason/packer.nvim"

  vim.fn.mkdir(dest, "p")

  print("Downloading packer")
  vim.fn.system(string.format("git clone %s %s", repo_url, dest .. "packer.nvim"))
  vim.cmd([[packadd packer.nvim]])
  vim.cmd("PackerSync")
  print("packer.nvim installed")
end

-- load plugins
return require("packer").startup(function(use)
  use {"wbthomason/packer.nvim", opt = true}
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  }

  -- loading page and float terminals for general usage
  use {"mhinz/vim-startify"}
  use {"voldikss/vim-floaterm"}

  -- better directory viewer
  use {"justinmk/vim-dirvish"}

  -- colors, style, icons
  use {"kyazdani42/nvim-web-devicons"}
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("modules.treesitter").config()
    end,
  }
  -- local
  use {"~/code/gruvbox.nvim", requires = {"tjdevries/colorbuddy.vim"}}
  use {"~/code/twitch.nvim"}
  use {"~/code/weather.nvim"}
  use {"~/code/glow.nvim"}

  -- plugin development and utils
  use {"vim-test/vim-test"}
  use {"nvim-lua/plenary.nvim"}

  -- editor
  use {"tpope/vim-surround"}
  use {"tpope/vim-commentary"}
  use {"tpope/vim-repeat"}
  use {"junegunn/fzf", run = ":call fzf#install()"}
  use {"sbdchd/neoformat"}
  use {"mhartington/formatter.nvim"}

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
  use {"tpope/vim-fugitive"}
  use {
    "mhinz/vim-signify",
    config = function()
      vim.g.signify_sign_add = " "
      vim.g.signify_sign_change = " "
      vim.g.signify_sign_delete_first_line = " "
    end,
  }

  -- lsp, completion, linting and snippets
  use {
    "~/code/nvim-lspconfig",
    config = function()
      require("modules.snippets")
      require("modules.lsp")
    end,
    requires = {
      "nvim-lua/completion-nvim",
      "norcalli/snippets.nvim",
      "tjdevries/nlua.nvim",
    },
  }

  -- statusline
  use {
    "~/code/galaxyline.nvim",
    config = function()
      require("modules.statusline")
    end,
    requires = {"~/code/gruvbox.nvim"},
  }

  -- go
  use {"fatih/vim-go", run = ":GoUpdateBinaries", ft = {"go"}}

  -- zig
  use {"ziglang/zig.vim"}

  -- html/css
  use {"mattn/emmet-vim", ft = {"html", "css", "scss", "gohtml", "jinja"}}

  -- bufferline tabs
  use {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("bufferline").setup()
    end,
  }

end)
