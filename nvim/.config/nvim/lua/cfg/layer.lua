--- Layer management
local log = require("cfg.log")

local layer = {}

layer.layers = {}

local function err_handler(err)
  return {err = err; traceback = debug.traceback()}
end

local function call_on_layers(func_name)
  for _, v in ipairs(layer.layers) do
    local ok, err = xpcall(v.module[func_name], err_handler)
    if not ok then
      log(" ")
      log.set_highlight("WarningMsg")
      log("Error while loading layer " .. v.name .. " / " .. func_name)
      log(
        "================================================================================")
      log.set_highlight("None")
      log(err.err)
      log(" ")
      log.set_highlight("WarningMsg")
      log("Traceback")
      log(
        "================================================================================")
      log.set_highlight("None")
      log(err.traceback)
      log(" ")
    end
  end
end

--- Register a layer to be loaded
function layer.add_layer(name)
  table.insert(layer.layers, {name = name; module = require(name)})
end

function layer.load_modules(modules)
  for _, item in ipairs(modules) do
    layer.add_layer("modules." .. item)
  end
  layer.finish_registration()
end

function layer.finish_registration()
  vim.schedule(function()
    require("cfg.plugins")
    call_on_layers("config")
  end)
end

return layer
