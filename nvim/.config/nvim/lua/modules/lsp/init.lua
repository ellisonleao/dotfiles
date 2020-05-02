--- Language server protocol support, courtesy of Neovim
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local autocmd = require("cfg.autocmd")
local plug = require("cfg.plug")

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("neovim/nvim-lsp")
  plug.add_plugin("haorenW1025/completion-nvim")
  plug.add_plugin("haorenW1025/diagnostic-nvim")
end

local function user_stop_all_clients()
  local clients = vim.lsp.get_active_clients()

  if #clients > 0 then
    vim.lsp.stop_client(clients)
    for _, v in pairs(clients) do
      print("Stopped LSP client " .. v.name)
    end
  else
    print("No LSP clients are running")
  end
end

local function user_attach_client()
  local filetype = vim.bo[0].filetype

  local server = layer.filetype_servers[filetype]
  if server ~= nil then
    print("Attaching LSP client " .. server.name .. " to buffer")
    server.manager.try_add()
  else
    print("No LSP client registered for filetype " .. filetype)
  end
end

--- Get the LSP status line part for vim-airline
function layer._get_airline_part()
  local clients = vim.lsp.buf_get_clients()
  local client_names = {}
  for _, v in pairs(clients) do
    table.insert(client_names, v.name)
  end

  if #client_names > 0 then
    return "LSP: " .. table.concat(client_names, ", ")
  else
    return ""
  end
end

--- Configures vim and plugins for this layer
function layer.init_config()
  -- completion confs
  -- diagnostics confs
  vim.api.nvim_set_var("diagnostic_enable_virtual_text", 1)
  -- vim.api.nvim_set_var("diagnostic_set_delay", 1)

  -- Bind leader keys
  keybind.set_group_name("<leader>l", "LSP")
  keybind.bind_function(edit_mode.NORMAL, "<leader>ls", user_stop_all_clients, nil, "Stop all LSP clients")
  keybind.bind_function(edit_mode.NORMAL, "<leader>la", user_attach_client, nil, "Attach LSP client to buffer")

  -- Tabbing
  keybind.bind_command(edit_mode.INSERT, "<tab>", "pumvisible() ? '<C-n>' : '<tab>'", { noremap = true, expr = true })
  keybind.bind_command(edit_mode.INSERT, "<S-tab>", "pumvisible() ? '<C-p>' : '<S-tab>'", { noremap = true, expr = true })
  autocmd.bind_complete_done(function()
    if vim.fn.pumvisible() == 0 then
      vim.cmd("pclose")
    end
  end)

  vim.o.completeopt = "menuone,noinsert,noselect"

  -- Jumping to places
  autocmd.bind_filetype("*", function()
    local server = layer.filetype_servers[vim.bo.ft]
    if server ~= nil then
      keybind.buf_bind_command(edit_mode.NORMAL, "gd", ":lua vim.lsp.buf.definition()<CR>", { noremap = true })
      keybind.bind_command(edit_mode.NORMAL, "K", ":lua vim.lsp.buf.signature_help()<CR>", { noremap = true })
    end
  end)

  keybind.bind_command(edit_mode.NORMAL, "<leader>lr", ":lua vim.lsp.buf.references()<CR>", { noremap = true }, "Find references")
  keybind.bind_command(edit_mode.NORMAL, "<leader>lR", ":lua vim.lsp.buf.rename()<CR>", { noremap = true }, "Rename")
  keybind.bind_command(edit_mode.NORMAL, "<leader>ld", ":lua vim.lsp.buf.document_symbol()<CR>", { noremap = true }, "Document symbol list")
  -- Show docs when the cursor is held over something
  autocmd.bind_cursor_hold(function()
    vim.cmd("lua vim.lsp.buf.hover()")
  end)

  -- Show in vim-airline the attached LSP client
  vim.api.nvim_exec(
    [[
    function! CLspGetAirlinePart()
    return luaeval("require('modules.lsp')._get_airline_part()")
    endfunction
    ]],
    false
    )
  vim.fn["airline#parts#define_function"]("c_lsp", "CLspGetAirlinePart")
  vim.fn["airline#parts#define_accent"]("c_lsp", "yellow")
  vim.g.airline_section_y = vim.fn["airline#section#create_right"]{"c_lsp", "ffenc"}
end

--- Maps filetypes to their server definitions
--
-- <br>
-- Eg: `["rust"] = nvim_lsp.rls`
--
-- <br>
-- See `nvim_lsp` for what a server definition looks like
layer.filetype_servers = {}

--- Register an LSP server
--
-- @param server An LSP server definition (in the format expected by `nvim_lsp`)
-- @param config The config for the server (in the format expected by `nvim_lsp`)
function layer.register_server(server, config)
  local completion = require("completion") -- From completion-nvim
  local diagnostic = require("diagnostic") -- From diagnostic-nvim

  config = config or {}
  config.on_attach = function()
    completion.on_attach()
    diagnostic.on_attach()
  end
  config = vim.tbl_extend("keep", config, server.document_config.default_config)

  server.setup(config)

  for _, v in pairs(config.filetypes) do
    layer.filetype_servers[v] = server
  end
end

return layer
