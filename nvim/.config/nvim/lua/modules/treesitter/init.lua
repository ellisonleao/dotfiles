-- module treesiter
local layer = {}

function layer.config()
  require("nvim-treesitter.configs").setup(
    {
      highlight = {enable = true};
      ensure_installed = {"lua"; "python"; "html"; "yaml"; "javascript"; "css"};
      disable = {'lua'; 'typescript.tsx'; 'typescript'; 'tsx'};
    })
end

return layer
