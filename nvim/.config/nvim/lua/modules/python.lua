--- Python module
local M = {}

M.config = function()
  vim.g["test#python#runner"] = "pytest"
  vim.g.neoformat_enabled_python = {"black"}
end

return M
