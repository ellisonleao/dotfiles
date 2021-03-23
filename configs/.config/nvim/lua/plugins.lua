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

  -- tpopes
  use {"tpope/vim-surround"}
  use {"tpope/vim-repeat"}
  use {"tpope/vim-rhubarb"}
  use {"tpope/vim-fugitive"}
  use {"tpope/vim-dadbod"}

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

  -- discord
  use {"andweeb/presence.nvim"}

  -- debugging
  use {
    "mfussenegger/nvim-dap",
    "nvim-telescope/telescope-dap.nvim",
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
  -- use {"~/code/gruvbox"}
  -- use {"~/code/vim-airline"}
  use {"~/code/gruvbox.nvim", requires = {"rktjmp/lush.nvim"}}
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
    requires = {"nvim-lua/popup.nvim", "nvim-telescope/telescope-fzy-native.nvim"},
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
  use {
    "neovim/nvim-lspconfig",
    config = function()
      require("modules.snippets")
      require("modules.lsp")
    end,
    requires = {"glepnir/lspsaga.nvim", "hrsh7th/nvim-compe", "norcalli/snippets.nvim"},
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
          lualine_c = {
            {"filename", full_path = true},
            {"diagnostics", sources = {"nvim_lsp"}},
          },
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
        extensions = {"fugitive"},
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
