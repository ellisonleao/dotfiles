-- lua module
local M = {}

function M.config()
  vim.bo.shiftwidth = 2
  vim.bo.softtabstop = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2

  vim.g.neoformat_lua_luaformat = {
    exe = "lua-format",
    args = {"-c " .. vim.fn.expand("~/.config/nvim/lua/.lua-format")},
  }
  vim.g.neoformat_enabled_lua = {"luaformat"}

  vim.api.nvim_buf_set_keymap(0, "n", "<leader>r", "<Cmd>luafile %<CR>",
                              {noremap = true, silent = true})
end

return M
