require("plugins")
require("editor")

-- helper functions for quick reloading
R = function(name)
  package.loaded[name] = nil
  print("reloaded:", name)
  return require(name)
end

P = function(v)
  print(vim.inspect(v))
  return v
end

PP = function(...)
  local vars = vim.tbl_map(vim.inspect, {...})
  print(unpack(vars))
end

RLSP = function()
  vim.schedule_wrap(function()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.api.nvim_command("edit")
  end)
end
