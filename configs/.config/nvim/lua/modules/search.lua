-- search module
require("telescope").setup {defaults = {shorten_path = false}}

-- create mappings
local opts = {noremap = true}
local mappings = {
  {"n", "<leader>f", [[<Cmd>lua require("telescope.builtin").live_grep{}<CR>]], opts},
  {"n", "<leader>ff", [[<Cmd>lua require("telescope.builtin").find_files{}<CR>]], opts},
  {
    "n",
    "<leader>fc",
    [[<Cmd>lua require("telescope.builtin").find_files{cwd = "~/.config/nvim"}<CR>]],
    opts,
  },
  {"n", "<leader>fg", [[<Cmd>lua require("telescope.builtin").git_files{}<CR>]], opts},
  {
    "n",
    "<leader>fr",
    [[<Cmd>lua require("telescope.builtin").lsp_references{ shorten_path = true }<CR>]],
    {noremap = true, silent = true},
  },
}

for _, map in pairs(mappings) do
  vim.api.nvim_set_keymap(unpack(map))
end

