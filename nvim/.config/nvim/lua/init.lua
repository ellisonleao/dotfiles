require("plugins")
require("editor")

-- helper functions for quick reloading
RELOAD = require('plenary.reload').reload_module

R = function(name)
  RELOAD(name)
  print("reloaded:", name)
  return require(name)
end

P = function(v)
  print(vim.inspect(v))
  return v
end

RLSP = function()
  vim.schedule_wrap(function()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.api.nvim_command("edit")
  end)
end
