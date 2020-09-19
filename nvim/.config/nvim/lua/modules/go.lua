-- go configs
local M = {}

function M.config()
  local opts = {noremap = true}
  local mappings = {
    {"n", "<leader>c", "<Plug>(go-coverage-toggle)", opts},
    {"n", "<leader>r", "<Plug>(go-run)", opts},
    {"n", "<leader>lk", [[<Cmd>call go#lsp#Restart()<CR>]], opts},
    {
      "n",
      "<leader>l",
      [[<Cmd>FloatermNew golangci-lint run --fix --out-format tab<CR>]],
      opts,
    },
  }
  vim.bo.shiftwidth = 4
  vim.bo.softtabstop = 4
  vim.bo.tabstop = 4

  -- disable vim-go snippet engine
  vim.g.go_snippet_engine = ""

  -- vim-go vars
  vim.g.go_fmt_command = "goimports"
  vim.g.go_list_type = "quickfix"
  vim.g.go_addtags_transform = "camelcase"
  vim.g.go_metalinter_enabled = {}
  vim.g.go_metalinter_autosave_enabled = {}

  for _, map in pairs(mappings) do
    vim.api.nvim_buf_set_keymap(0, unpack(map))
  end
end

return M
