local completion = require("completion")
local nvim_lsp = require("lspconfig")

local function make_on_attach(config)
  return function(client)
    if config.before then
      config.before(client)
    end

    completion.on_attach(client)

    local opts = {silent = true, noremap = true}
    local mappings = {
      {"i", "<expr> <tab>", [[ pumvisible() ? '<C-n>' : '<tab>' ]], opts},
      {"i", "<expr> <S-tab>", [[ pumvisible() ? '<C-p>' : '<S-tab>' ]], opts},
      {"n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts},
      {"n", "gD", [[<Cmd>lua vim.lsp.buf.declaration()<CR>]], opts},
      {"n", "gi", [[<Cmd>lua vim.lsp.buf.implementation()<CR>]], opts},
      {"n", "gr", [[<Cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts},
      {"n", "<leader>lr", [[<Cmd>lua vim.lsp.buf.rename()<CR>]], opts},
      {"i", "<C-x>", [[<Cmd>lua vim.lsp.buf.signature_help()<CR>]], opts},
      {"n", "[e", [[<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>]], opts},
      {"n", "]e", [[<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>]], opts},
    }

    if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'lua' then
      vim.api.nvim_buf_set_keymap(0, "n", "K", [[<Cmd>lua vim.lsp.buf.hover()<CR>]],
                                  opts)
    end

    for _, map in pairs(mappings) do
      vim.api.nvim_buf_set_keymap(0, unpack(map))
    end

    if config.after then
      config.after(client)
    end

    vim.api.nvim_command(
      [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])

    vim.api.nvim_command(
      [[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]])

  end
end

local servers = {gopls = {}, tsserver = {}, yamlls = {}, vimls = {}, pyright = {}}

-- lua special case
require("nlua.lsp.nvim").setup(nvim_lsp, {
  on_attach = make_on_attach({}),
  globals = {
    -- Colorbuddy
    "Color",
    "Group",
    -- Custom global funcs
    "RELOAD",
    "R",
    "P",
  },
})

for server, config in pairs(servers) do
  config = config or {}
  config.on_attach = make_on_attach(config)
  nvim_lsp[server].setup(config)
end
