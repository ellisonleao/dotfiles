local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local autocmd = require("cfg.autocmd")
local plug = require("cfg.plug")
local kbc = keybind.bind_command
local kbbc = keybind.buf_bind_command

local layer = {}

--- Returns plugins required for this layer
function layer.register_plugins()
  plug.add_plugin("neovim/nvim-lsp")
  plug.add_plugin("nvim-lua/completion-nvim")
  plug.add_plugin("nvim-lua/lsp-status.nvim")
end

local function stop_all_clients()
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

local function attach_client()
  local filetype = vim.bo[0].filetype

  local server = layer.filetype_servers[filetype]
  if server ~= nil then
    print("Attaching LSP client " .. server.name .. " to buffer")
    server.manager.try_add()
  else
    print("No LSP client registered for filetype " .. filetype)
  end
end

--- Configures vim and plugins for this layer
function layer.init_config()
  keybind.bind_function(edit_mode.NORMAL, "<leader>ls", stop_all_clients, nil)
  keybind.bind_function(edit_mode.NORMAL, "<leader>la", attach_client, nil)

  kbc(edit_mode.INSERT, "<tab>", "pumvisible() ? '<C-n>' : '<tab>'",
      {noremap = true; expr = true})
  kbc(edit_mode.INSERT, "<S-tab>", "pumvisible() ? '<C-p>' : '<S-tab>'",
      {noremap = true; expr = true})
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
      kbbc(edit_mode.NORMAL, "gd", ":lua vim.lsp.buf.definition()<CR>",
           {noremap = true})
      kbbc(edit_mode.NORMAL, "gD", ":lua vim.lsp.buf.implementation()<CR>",
           {noremap = true})
      kbbc(edit_mode.NORMAL, "K", ":lua vim.lsp.buf.hover()<CR>",
           {noremap = true})
    end
  end)

  kbc(edit_mode.NORMAL, "<leader>lR", ":lua vim.lsp.buf.rename()<CR>",
      {noremap = true})

  autocmd.bind_cursor_hold(function()
    vim.cmd("lua vim.lsp.util.show_line_diagnostics()")
  end)

  vim.api.nvim_exec([[
		function! LspStatus() abort
			if luaeval('#vim.lsp.buf_get_clients() > 0')
				return luaeval("require('modules.lsp').get_status()")
			endif

			return ''
		endfunction
    ]], false)
end

--- Maps filetypes to their server definitions
layer.filetype_servers = {}

--- Register an LSP server
function layer.register_server(server, config)
  local completion = require("completion")
  local lsp_status = require("lsp-status")
  lsp_status.config({status_symbol = "🔎"})
  lsp_status.register_progress()

  config = config or {}
  config.on_attach = function(client)
    lsp_status.on_attach(client)
    completion.on_attach(client)
  end

  config.capabilities = vim.tbl_extend("keep", config.capabilities or {},
                                       lsp_status.capabilities)

  config = vim.tbl_extend("keep", config, server.document_config.default_config)

  server.setup(config)

  for _, v in pairs(config.filetypes) do
    layer.filetype_servers[v] = server
  end
end

-- return lsp status for lightline
function layer.get_status()
  local lsp_status = require("lsp-status")
  local filetype = vim.bo[0].filetype

  local server = layer.filetype_servers[filetype]
  if server ~= nil then
    return "LSP: " .. server.name .. " - " .. lsp_status.status()
  end

  return lsp_status.status()
end

return layer
