-- iron.nvim module
local iron = require("iron")
local M = {}

function M.config()
  iron.core.add_repl_definitions({lua = {croissant = {command = {"croissant"}}}})
  iron.core.set_config({preferred = {python = "ptipython", lua = "croissant"}})
end
return M
