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
  use {"junegunn/fzf", run = ":call fzf#install()"}

  -- tpopes
  use {"tpope/vim-surround"}
  use {"tpope/vim-repeat"}
  use {"tpope/vim-fugitive"}

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

  -- -- landing page and float terminals for general usage
  use {"voldikss/vim-floaterm"}
  use {"mhinz/vim-startify"}

  -- local
  use {"~/code/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
  -- use {"~/code/glow.nvim"}
  -- use {"~/code/go.nvim"}
  use {"fatih/vim-go", run = {":GoUpdateBinaries"}}

  -- plugin development and utils
  use {"vim-test/vim-test"}
  use {"nvim-lua/plenary.nvim"}
  use {"mjlbach/babelfish.nvim"}

  -- editor
  use {
    "b3nj5m1n/kommentary",
    config = function()
      require("kommentary.config").configure_language("default", {
        prefer_single_line_comments = true,
      })
    end,
  }

  use {
    "lukas-reineke/format.nvim",
    config = function()
      require("modules.formatter")
    end,
  }

  use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
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

  -- lsp, completion, linting and snippets
  use {"kabouzeid/nvim-lspinstall"}
  use {"rafamadriz/friendly-snippets"}
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("modules.lsp")
    end,
    requires = {
      "glepnir/lspsaga.nvim",
      "hrsh7th/nvim-compe",
      "hrsh7th/vim-vsnip",
      "hrsh7th/vim-vsnip-integ",
    },
  }

  -- statusline
  use {
    "hoob3rt/lualine.nvim",
    config = function()

      require("lualine").setup {
        theme = "gruvbox",
        separator = "|",
        sections = {
          lualine_a = {"mode"},
          lualine_b = {"branch"},
          lualine_c = {{"filename", path = 2}, {"diagnostics", sources = {"nvim_lsp"}}},
          lualine_x = {"encoding", "fileformat", "filetype"},
          lualine_y = {"progress"},
          lualine_z = {"location"},
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {"filename"},
          lualine_x = {"location"},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {"fugitive", "quickfix"},
      }
    end,
  }

  -- bufferline tabs
  use {
    "akinsho/nvim-bufferline.lua",
    config = function()
      require("bufferline").setup()
    end,
  }

end)
