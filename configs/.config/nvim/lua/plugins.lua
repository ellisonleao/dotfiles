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

vim.cmd([[autocmd BufWritePost plugins.lua PackerCompile ]])

-- load plugins
return require("packer").startup(function(use)
  use {"wbthomason/packer.nvim", opt = true}
  use {"alexaandru/nvim-lspupdate"}
  -- colors, style, icons
  use {
    "norcalli/nvim-colorizer.lua",
    config = function()
      require("colorizer").setup()
    end,
  }

  use {"kyazdani42/nvim-web-devicons"}
  use {
    "nvim-treesitter/nvim-treesitter",
    config = function()
      require("modules.treesitter").config()
    end,
  }

  -- debugging
  use {
    "mfussenegger/nvim-dap",
    "mfussenegger/nvim-dap-python",
    setup = function()
      require("modules.dap")
    end,
  }

  -- landing page and float terminals for general usage
  use {"mhinz/vim-startify"}
  use {"voldikss/vim-floaterm"}

  -- better directory viewer
  use {"justinmk/vim-dirvish"}

  -- local
  use {"~/code/gruvbox.nvim", requires = {"ktjmp/lush.nvim"}}
  use {"~/code/weather.nvim"}
  use {"~/code/glow.nvim"}

  -- plugin development and utils
  use {"vim-test/vim-test"}
  use {"nvim-lua/plenary.nvim"}

  -- editor
  use {
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language("default", {
        prefer_single_line_comments = true,
      })
    end,
  }
  use {"tpope/vim-surround"}
  use {"tpope/vim-repeat"}
  use {"junegunn/fzf", run = ":call fzf#install()"}
  use {
    "mhartington/formatter.nvim",
    config = function()
      require("modules.formatter")
    end,
  }
  use {
    "nvim-lua/telescope.nvim",
    config = function()
      require("modules.search")
    end,
    requires = {"nvim-lua/popup.nvim"},
  }

  -- git
  use {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup {numhl = true}
    end,
  }
  use {"tpope/vim-rhubarb"}
  use {"tpope/vim-fugitive"}

  -- lsp, completion, linting and snippets
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("modules.snippets")
      require("modules.lsp")
    end,
    requires = {
      "glepnir/lspsaga.nvim",
      "hrsh7th/nvim-compe",
      "norcalli/snippets.nvim",
      "tjdevries/nlua.nvim",
    },
  }

  -- statusline
  use {
    "hoob3rt/lualine.nvim",
    config = function()
      require("modules.statusline")
    end,
  }

  -- go
  use {"fatih/vim-go", run = ":GoUpdateBinaries", ft = {"go"}}

  -- zig
  use {"ziglang/zig.vim", ft = {"zig"}}

  -- html/css
  use {"mattn/emmet-vim", ft = {"html", "css", "jsx", "gohtml"}}

  -- bufferline tabs
  use {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("bufferline").setup()
    end,
  }

end)
