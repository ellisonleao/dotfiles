require("plugins")
require("editor")
-- pretty print lua tables
P = function(v)
  print(vim.inspect(v))
  return v
end
PP = function(...)
  local vars = vim.tbl_map(vim.inspect, {...})
  print(unpack(vars))
end
-- reload all active lsp clients
RLSP = function()
  vim.schedule_wrap(function()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
    vim.api.nvim_command("edit")
  end)
end
-- helper function for quick reloading a lua module
R = function(name)
  if package.loaded[name] ~= nil then
    package.loaded[name] = nil
    print("reloaded:", name)
    return require(name)
  else
    vim.api.nvim_err_writeln(string.format("package does not exist: %s", name))
  end
end
-- reload all my custom modules
RR = function()
  local packages = {
    "plugins",
    "editor",
    "modules.treesitter",
    "modules.formatter",
    "modules.search",
    "modules.utils",
    "modules.lsp",
    "modules.lsp.lua",
  }
  for _, pkg in pairs(packages) do
    R(pkg)
  end
end
