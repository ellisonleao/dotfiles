-- proto layer
local autocmd = require("cfg.autocmd")
local layer = {}

function layer.register_plugins()
end

local function on_filetype_proto()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
end

function layer.init_config()
  autocmd.bind_filetype("proto", on_filetype_proto)
end

return layer
