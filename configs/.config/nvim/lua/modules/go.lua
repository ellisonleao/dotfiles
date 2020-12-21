-- go language module
local opts = {noremap = true}
local mappings = {
  {"n", "<leader>lk", [[<Cmd>call go#lsp#Restart()<CR>]], opts},
  {"n", "<leader>l", [[<Cmd>GoMetaLinter<CR>]], opts},
  {"n", "<leader>ga", [[<Cmd>GoAlternate<CR>]], opts},
  {"n", "<leader>gc", [[<Cmd>GoCoverageToggle<CR>]], opts},
}
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.bo.tabstop = 4

-- disable vim-go snippet engine
vim.g.go_snippet_engine = ""

-- vim-go vars
vim.g.go_list_type = "quickfix"
vim.g.go_addtags_transform = "camelcase"
vim.g.go_metalinter_enabled = {}
vim.g.go_metalinter_autosave_enabled = {}
vim.g.go_doc_popup_window = true

-- showing 2 columns
vim.wo.colorcolumn = "80,120"

for _, map in pairs(mappings) do
  vim.api.nvim_buf_set_keymap(0, unpack(map))
end
