local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")
saga.init_lsp_saga()

-- configure completion
require("compe").setup {
  enabled = true,
  autocomplete = true,
  debug = false,
  min_length = 1,
  preselect = "enable",
  throttle_time = 80,
  source_timeout = 200,
  incomplete_delay = 400,
  max_abbr_width = 100,
  max_kind_width = 100,
  max_menu_width = 100,

  source = {
    path = true,
    buffer = true,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    spell = true,
    tags = true,
    snippets_nvim = true,
  },
}

vim.cmd [[inoremap <silent><expr> <C-Space> compe#complete() ]]
vim.cmd [[inoremap <silent><expr> <CR> compe#confirm('<CR>')]]
vim.cmd [[inoremap <silent><expr> <C-e> compe#close('<C-e>') ]]

local function make_on_attach(config)
  return function(client)
    if config.before then
      config.before(client)
    end

    local opts = {silent = true, noremap = true}
    local mappings = {
      {
        "n",
        "gD",
        [[<Cmd>lua require('lspsaga.provider').preview_definition()<CR>]],
        opts,
      },
      {"n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts},
      {"n", "gr", [[<Cmd>lua require('lspsaga.rename').rename()<CR>]], opts},
      {
        "n",
        "gs",
        [[<Cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]],
        opts,
      },
      {"n", "gR", [[<Cmd>lua require('telescope.builtin').lsp_references()<CR>]], opts},
      {"i", "<C-Space>", [[<expr>]], opts},
      {
        "i",
        "<C-x>",
        [[<Cmd>lua require('lspsaga.signaturehelp').signature_help()<CR>]],
        opts,
      },
      {
        "n",
        "[e",
        [[<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_next()<CR>]],
        opts,
      },
      {
        "n",
        "]e",
        [[<Cmd>lua require('lspsaga.diagnostic').lsp_jump_diagnostic_prev() <CR>]],
        opts,
      },
    }

    if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'lua' then
      vim.api.nvim_buf_set_keymap(0, "n", "K",
                                  [[<Cmd>lua require('lspsaga.hover').render_hover_doc()<CR>]],
                                  opts)
      vim.api.nvim_buf_set_keymap(0, "n", "<C-f>",
                                  [[<Cmd>lua require('lspsaga.hover').smart_scroll_hover(1)<CR>]],
                                  opts)
      vim.api.nvim_buf_set_keymap(0, "n", "<C-b>",
                                  [[<Cmd>lua require('lspsaga.hover').smart_scroll_hover(-1)<CR>]],
                                  opts)
    end

    for _, map in pairs(mappings) do
      vim.api.nvim_buf_set_keymap(0, unpack(map))
    end

    if config.after then
      config.after(client)
    end

    if vim.api.nvim_buf_get_option(0, 'filetype') ~= 'yaml' then
      vim.api.nvim_command(
        [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]])

      vim.api.nvim_command(
        [[autocmd CursorMoved <buffer> lua vim.lsp.util.buf_clear_references()]])
    end
  end
end

local servers = {gopls = {}, tsserver = {}, yamlls = {}, vimls = {}, pyright = {}}

-- lua special case
require("nlua.lsp.nvim").setup(nvim_lsp, {
  on_attach = make_on_attach({}),
  globals = {"Color", "Group", "RELOAD", "R", "P"},
})

for server, config in pairs(servers) do
  local capabilities = vim.lsp.protocol.make_client_capabilities()

  config = config or {}
  config.on_attach = make_on_attach(config)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  config.capabilities = capabilities

  nvim_lsp[server].setup(config)
end
