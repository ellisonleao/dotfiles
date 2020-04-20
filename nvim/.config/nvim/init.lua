-- reload modules
local reload = require("cfg.reload")
reload.unload_user_modules()

-- load log module
local log = require("cfg.log")
log.init()

local layer = require("cfg.layer")
local keybind = require("cfg.keybind")
local autocmd = require("cfg.autocmd")

keybind.register_plugins()
autocmd.init()

local modules = {
  "go", -- Go configs
  "editor", -- Mappings, autocmd configs
  "style", -- color, syntax, configs
  "git", -- Git configs
  "lsp", -- Common language server configs
  "lua", -- Lua configs
  "python", -- Python configs
  "js", -- Js, ts, react configs
  "html", -- html configs
  "rust" -- Rust configs
}
for _, item in ipairs(modules) do
  layer.add_layer("lang."..item)
end
layer.finish_layer_registration()

keybind.post_init()
