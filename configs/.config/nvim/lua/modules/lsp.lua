local nvim_lsp = require("lspconfig")
local saga = require("lspsaga")
saga.init_lsp_saga({code_action_prompt = {enable = false}})

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
    snippets_nvim = true,
    vim_dadbod = true,
  },
}

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn["compe#complete"]()
  end
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<CR>", "compe#confirm('CR')",
                        {expr = true, noremap = true})
vim.api.nvim_set_keymap("i", "<C-e>", "compe#close('<C-e>')",
                        {expr = true, noremap = true})

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
      {
        "n",
        "<leader>gR",
        [[<Cmd>lua require("telescope.builtin").lsp_references{ shorten_path = true }<CR>]],
        {noremap = true, silent = true},
      },
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
