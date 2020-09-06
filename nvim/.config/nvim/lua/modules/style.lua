local style = {}

function style.set_globals()
  -- lightline config
  nvim.g.lightline = {
    colorscheme = "seoul256";
    active = {
      left = {
        {"mode"; "paste"};
        {"gitbranch"; "readonly"; "filename"; "modified"; "lineinfo"};
      };
      right = {{"lsp"}};
    };
    tabline = {left = {{"buffers"}}; right = {{"close"}}};
    component_function = {gitbranch = "FugitiveHead"; lsp = "LspStatus"};
    component_expand = {buffers = "lightline#bufferline#buffers"};
    component_type = {buffers = "tabsel"};
  }
end

function style.config()
  style.set_globals()
  require("colorizer").setup()
  local base16 = require("base16")
  base16(base16.themes["gruvbox-dark-hard"], true)
end

return style.config()
