--- Lua layer
local autocmd = require("cfg.autocmd")
local keybind = require("cfg.keybind")
local edit_mode = require("cfg.edit_mode")
local kbc = keybind.bind_command

local layer = {}

local function on_filetype_lua()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2

  -- run *.lua with \r
  kbc(edit_mode.NORMAL, "<leader>r", ":!lua %<CR>", {noremap = true})
end

--- Returns plugins required for this layer
function layer.register_plugins()
end

--- Configures vim and plugins for this layer
function layer.config()
  local lsp = require("modules.lsp")
  local nvim_lsp = require("nvim_lsp")
  local config = {
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT";
          -- TODO: Figure out how to get plugins here.
          path = vim.split(package.path, ';');
          -- path = {package.path},
        };
        diagnostics = {
          enable = true;
          globals = {
            "vim"; -- Neovim
            "describe"; "it"; "before_each"; "after_each"; -- Busted
          };
        };

        workspace = {
          library = {
            -- This loads the `lua` files from nvim into the runtime.
            [vim.fn.expand("$VIMRUNTIME/lua")] = true;

            -- TODO: Figure out how to get these to work...
            --  Maybe we need to ship these instead of putting them in `src`?...
            [vim.fn.expand("~/.local/neovim/src/nvim/lua")] = true;
          };
        };
      };
    };
  }

  lsp.register_server(nvim_lsp.sumneko_lua, config)

  autocmd.bind_filetype("lua", on_filetype_lua)
  autocmd.bind("BufWrite *.lua", function()
    vim.api.nvim_exec("call LuaFormat()", false)
  end)
end

return layer
