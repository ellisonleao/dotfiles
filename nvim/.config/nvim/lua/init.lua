local reload = require("cfg.reload")
reload.unload_user_modules()

local log = require("cfg.log")
local layer = require("cfg.layer")
local autocmd = require("cfg.autocmd")

autocmd.init()
log.init()

local modules = {
  "lsp"; -- Common language server configs
  "editor"; -- Mappings, autocmd configs
  "snippets"; -- snippets configs
  "style"; -- color, syntax, configs
  "treesitter"; -- treesitter configs
  "lua"; -- Lua configs
  "go"; -- Go configs
  "python"; -- Python configs
  "html"; -- html/css
  "js"; -- Js, ts, react configs
  "yaml"; -- YAML configs
  "proto"; -- protobuf configs
}

layer.load_modules(modules)
