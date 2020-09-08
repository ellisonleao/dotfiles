vim.cmd [[ packadd lsp-status.nvim ]]
vim.cmd [[ packadd diagnostic-nvim ]]
vim.cmd [[ packadd completion-nvim ]]
vim.cmd [[ packadd nvim-lspconfig ]]

local lsp_status = require("lsp-status")
local diagnostic = require("diagnostic")
local completion = require("completion")
local nvim_lsp = require("nvim_lsp")
local utils = require("utils")

lsp_status.register_progress()

local function make_on_attach(config)
  return function(client)
    if config.before then
      config.before(client)
    end

    lsp_status.on_attach(client)
    diagnostic.on_attach(client)
    completion.on_attach(client)

    local opts = {silent = true, noremap = true}
    local mappings = {
      {"i", "<expr> <tab>", [[ pumvisible() ? '<C-n>' : '<tab>' ]], opts},
      {"i", "<expr> <S-tab>", [[ pumvisible() ? '<C-p>' : '<S-tab>' ]], opts},
      {"n", "gd", [[<cmd>lua vim.lsp.buf.definition()<CR>]], opts},
      {"n", "K", [[<cmd>lua vim.lsp.buf.hover()<CR>]], opts},
      {"n", "<leader>lr", [[<cmd>lua vim.lsp.buf.rename()<CR>]], opts},
      {"i", "<C-x>", [[<cmd>lua vim.lsp.buf.signature_help()<CR>]], opts},
      {"n", "]e", [[<cmd>NextDiagnosticCycle<CR>]], opts},
      {"n", "[e", [[<cmd>PrevDiagnosticCycle<CR>]], opts},
    }

    if client.resolved_capabilities.document_formatting then
      table.insert(mappings,
                   {"n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts})
    end

    for _, map in pairs(mappings) do
      vim.api.nvim_buf_set_keymap(0, unpack(map))
    end

    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_command("augroup lsp_aucmds")
      vim.api
        .nvim_command("au CursorHold <buffer> lua vim.lsp.buf.document_highlight()")
      vim.api.nvim_command("au CursorMoved <buffer> lua vim.lsp.buf.clear_references()")
      vim.api.nvim_command("augroup END")
    end

    if config.after then
      config.after(client)
    end
  end
end

local servers = {
  gopls = {},
  tsserver = {},
  pyls_ms = {
    callbacks = lsp_status.extensions.pyls_ms.setup(),
    root_dir = function(fname)
      return nvim_lsp.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg",
                                        "requirements.txt", "mypy.ini", ".pylintrc",
                                        ".flake8rc", ".gitignore")(fname) or
               nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end,
  },
  yamlls = {},
  vimls = {},
  sumneko_lua = {
    filetypes = {"lua"},
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
          -- TODO: Figure out how to get plugins here.
          path = vim.split(package.path, ";"),
        },
        diagnostics = {
          enable = true,
          globals = {
            "vim", -- Neovim
            "describe", "it", "before_each", "after_each", -- Busted
          },
        },
        completion = {keywordSnippet = "Disable"},
        workspace = {
          library = {
            -- This loads the `lua` files from nvim into the runtime.
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("~/.local/neovim/src/nvim/lua")] = true,
          },
        },
      },
    },
  },
}

for server, config in pairs(servers) do
  config = config or {}
  config.on_attach = make_on_attach(config)
  config.capabilities = utils.deep_extend("keep", config.capabilities or {},
                                          lsp_status.capabilities)
  nvim_lsp[server].setup(config)
end
