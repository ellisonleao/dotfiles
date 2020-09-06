local lsp = {}
local lsp_status = require("lsp-status")
local completion = require("completion")
local nvim_lsp = require("nvim_lsp")
require("nvim_utils")

local function make_on_attach(config)
  return function(client)
    if config.before then config.before(client) end

    lsp_status.config({status_symbol = "🔎"})
    completion.on_attach(client)
    lsp_status.on_attach(client)

    local mappings = {
      ["i<expr> <tab>"] = {[[ pumvisible() ? '<C-n>' : '<tab>' ]]};
      ["i<expr> <S-tab>"] = {[[ pumvisible() ? '<C-p>' : '<S-tab>' ]]};
      ["ngd"] = {[[<cmd>lua vim.lsp.buf.definition()<CR>]]};
      ["nK"] = {[[<cmd>lua vim.lsp.buf.hover()<CR>]]};
      ["n<leader>lr"] = {[[<cmd>lua vim.lsp.buf.rename()<CR>]], noremap=true};
    }

    if client.resolved_capabilities.document_formatting then
      mappings["n<leader>lf"] = {"<cmd>lua vim.lsp.buf.formatting()<cr>"}
    end

    nvim_apply_mappings(mappings)

    if client.resolved_capabilities.document_highlight then
      vim.api.nvim_command('augroup lsp_aucmds')
      vim.api.nvim_command('au CursorHold <buffer> lua vim.lsp.buf.document_highlight()')
      vim.api.nvim_command('au CursorMoved <buffer> lua vim.lsp.buf.clear_references()')
      vim.api.nvim_command('augroup END')
    end

    if config.after then config.after(client) end
  end
end


local function deep_extend(policy, ...)
  local result = {}
  local function helper(policy, k, v1, v2)
    if type(v1) ~= 'table' or type(v2) ~= 'table' then
      if policy == 'error' then
        error('Key ' .. vim.inspect(k) .. ' is already present with value ' .. vim.inspect(v1))
      elseif policy == 'force' then
        return v2
      else
        return v1
      end
    else
      return deep_extend(policy, v1, v2)
    end
  end

  for _, t in ipairs({...}) do
    for k, v in pairs(t) do
      if result[k] ~= nil then
        result[k] = helper(policy, k, result[k], v)
      else
        result[k] = v
      end
    end
  end

  return result
end

local servers = {
  gopls = {};
  tsserver = {};
  pyls_ms = {
    callbacks = lsp_status.extensions.pyls_ms.setup();
    root_dir = function(fname)
      return nvim_lsp.util.root_pattern('pyproject.toml', 'setup.py', 'setup.cfg',
                                        'requirements.txt', 'mypy.ini', '.pylintrc', '.flake8rc',
                                        '.gitignore')(fname)
               or nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
    end
  };
  yamlls = {};
  sumneko_lua = {
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
            "nvim"; -- nvim_utils
            "vim"; -- Neovim
            "describe"; "it"; "before_each"; "after_each"; -- Busted
          };
        };

        workspace = {
          library = {
            -- This loads the `lua` files from nvim into the runtime.
            [vim.fn.expand("$VIMRUNTIME/lua")] = true;
            [vim.fn.expand("~/.local/neovim/src/nvim/lua")] = true;
          };
        };
      };
    };
  }
}

function lsp.config()
  lsp_status.register_progress()
  for server, config in pairs(servers) do
    config = config or {}
    config.on_attach = make_on_attach(config)
    config.capabilities = deep_extend("keep", config.capabilities or {}, lsp_status.capabilities)
    nvim_lsp[server].setup(config)
  end
end

return lsp
