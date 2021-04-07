require("plugins")
require("editor")

-- helper functions for quick reloading
R = function(name)
  if package.loaded[name] ~= nil then
    package.loaded[name] = nil
    print("reloaded:", name)
    return require(name)
  else
    vim.api.nvim_err_writeln(string.format("package does not exist: %s", name))
  end
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

RR = function()
  local packages = {
    "plugins",
    "editor",
    "modules.dap",
    "modules.treesitter",
    "modules.formatter",
    "modules.search",
    "modules.snippets",
    "modules.utils",
    "modules.lsp",
    "modules.lsp.lua",
  }

  for _, pkg in pairs(packages) do
    R(pkg)
  end
end

vim.cmd([[command! RR  lua RR()]])
