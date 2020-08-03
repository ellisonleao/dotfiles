local reload = require("cfg.reload")
reload.unload_user_modules()

local log = require("cfg.log")
local layer = require("cfg.layer")
local autocmd = require("cfg.autocmd")
local plug = require("cfg.plug")

autocmd.init()
log.init()
plug.install()

local modules = {
  "editor"; -- Mappings, autocmd configs
  "style"; -- color, syntax, configs
  "lsp"; -- Common language server configs
  "git"; -- Git configs
  "go"; -- Go configs
  "python"; -- Python configs
  "rust"; -- Rust configs
  "lua"; -- Lua configs
  "html"; -- html/css
  "js"; -- Js, ts, react configs
  "yaml"; -- YAML configs
}
layer.load_modules(modules)
