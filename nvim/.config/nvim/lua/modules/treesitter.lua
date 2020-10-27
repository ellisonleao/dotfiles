-- module treesiter
local M = {}

function M.config()
  require("nvim-treesitter.configs").setup({
    highlight = {enable = true},
    ensure_installed = {
      "go",
      "python",
      "lua",
      "html",
      "yaml",
      "json",
      "javascript",
      "css",
      "bash",
      "toml",
    },
    disable = {"typescript.tsx", "typescript", "tsx"},
  })
end

return M
