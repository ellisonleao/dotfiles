local lsp_status = require("lsp-status")
local completion = require("completion")
local diagnostic = require("diagnostic")
local nvim_lsp = require("nvim_lsp")

lsp_status.register_progress()

-- not available yet!
-- local function setup_custom_diagnostics()
--   Diagnostic = require('vim.lsp.actions').Diagnostic
--   Location = require('vim.lsp.actions').Location
--   vim.lsp.callbacks["textDocument/publishDiagnostics"] =
--     Diagnostic.handle_publish_diagnostics.with {
--       should_underline = true,
--       update_in_insert = false,
--     }

--   local mappings = {
--     {"n", "[e", "<cmd>lua vim.lsp.structures.Diagnostic.buf_move_next_diagnostic()<CR>"},
--     {"n", "]e", "<cmd>lua vim.lsp.structures.Diagnostic.buf_move_prev_diagnostic()<CR>"},
--   }

--   for _, map in pairs(mappings) do
--     vim.api.nvim_buf_set_keymap(0, unpack(map))
--   end
-- end

local function make_on_attach(config)
  return function(client)
    if config.before then
      config.before(client)
    end

    lsp_status.on_attach(client)
    diagnostic.on_attach(client)
    completion.on_attach(client)

    --       pcall(setup_custom_diagnostics)

    local opts = {silent = true, noremap = true}
    local mappings = {
      {"i", "<expr> <tab>", [[ pumvisible() ? '<C-n>' : '<tab>' ]], opts},
      {"i", "<expr> <S-tab>", [[ pumvisible() ? '<C-p>' : '<S-tab>' ]], opts},
      {"n", "gd", [[<Cmd>lua vim.lsp.buf.definition()<CR>]], opts},
      {"n", "K", [[<Cmd>lua vim.lsp.buf.hover()<CR>]], opts},
      {"n", "<leader>lr", [[<Cmd>lua vim.lsp.buf.rename()<CR>]], opts},
      {"i", "<C-x>", [[<Cmd>lua vim.lsp.buf.signature_help()<CR>]], opts},
      {"n", "[e", [[<Cmd>NextDiagnosticCycle<CR>]], opts},
      {"n", "]e", [[<Cmd>PrevDiagnosticCycle<CR>]], opts},
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

    -- vim.cmd("setlocal omnifunc=v:lua.vim.lsp.omnifunc")
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
    cmd = function()
      local cache_location = vim.fn.stdpath("cache")
      return {
        string.format(
          "%s/nvim_lsp/sumneko_lua/lua-language-server/bin/Linux/lua-language-server",
          cache_location),
        "-E",
        string.format("%s/nvim/nvim_lsp/sumneko_lua/lua-language-server/main.lua",
                      cache_location),
      }
    end,
    settings = {
      Lua = {
        runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
        diagnostics = {
          enable = true,
          globals = {
            "vim",
            "describe",
            "it",
            "before_each",
            "after_each",
            "teardown",
            "pending",
          },
        },
        completion = {keywordSnippet = "Disable"},
        workspace = {
          library = {
            -- This loads the `lua` files from nvim into the runtime.
            [vim.fn.expand("$VIMRUNTIME/lua")] = true,
            [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
          },
        },
      },
    },
  },
}

for server, config in pairs(servers) do
  config = config or {}
  config.on_attach = make_on_attach(config)
  config.capabilities = vim.tbl_deep_extend("keep", config.capabilities or {},
                                            lsp_status.capabilities)
  nvim_lsp[server].setup(config)
end
