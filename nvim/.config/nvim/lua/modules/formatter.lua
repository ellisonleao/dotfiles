-- formatter modules
local function prettier()
  return {exe = "prettier", args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0)}}
end

require("formatter").setup({
  logging = false,
  filetype = {
    lua = {
      function()
        return {
          exe = "lua-format",
          args = {"-c " .. vim.fn.expand("~/.config/nvim/lua/.lua-format")},
        }
      end,
    },
    python = {
      function()
        return {exe = "black", args = {"-q", "-"}}
      end,
    },
    javascript = {prettier()},
    javascriptreact = {prettier()},
    markdown = {prettier()},
    json = {
      function()
        return {
          exe = "prettier",
          args = {"--stdin-filepath", vim.api.nvim_buf_get_name(0), "--parser", "json"},
        }
      end,
    },
    go = {
      -- gofmt, goimports
      function()
        return {exe = "gofmt"}
      end,
      function()
        return {exe = "goimports"}
      end,
    },
  },

})

-- adding format on save autocmd
vim.api.nvim_exec([[
augroup Format
    autocmd!
    autocmd BufWritePost * FormatWrite
augroup END
]], true)
