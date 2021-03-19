-- module treesiter
local M = {}

function M.config()
  require("nvim-treesitter.configs").setup({
    highlight = {enable = true},
    ensure_installed = {
      "go",
      "python",
      "lua",
      "yaml",
      "json",
      "javascript",
      "bash",
      "typescript",
    },
  })
end

return M
