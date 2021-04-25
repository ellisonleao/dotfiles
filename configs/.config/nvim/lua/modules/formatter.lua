-- formatter modules
require("format").setup {
  ["*"] = {
    {cmd = {"sed -i 's/[ \t]*$//'"}}, -- remove trailing whitespace
  },
  lua = {
    {cmd = {"lua-format -i -c " .. vim.fn.expand("~/.config/nvim/lua/.lua-format")}},
  },
  go = {{cmd = {"gofmt -w", "goimports -w"}, tempfile_postfix = ".tmp"}},
  javascript = {{cmd = {"prettier -w"}}},
  javascriptreact = {{cmd = {"prettier -w"}}},
  json = {cmd = {"prettier -w --parser=json"}},
  python = {cmd = {"black -q -"}},
  markdown = {
    {cmd = {"prettier -w"}},
    {
      cmd = {"black -q -"},
      start_pattern = "^```python$",
      end_pattern = "^```$",
      target = "current",
    },
  },
}

-- adding format on save autocmd
vim.cmd([[
augroup FormatAu
autocmd!
autocmd BufWritePost * FormatWrite
augroup END
]])
