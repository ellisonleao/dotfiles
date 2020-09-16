local utils = {}
local api = vim.api

function utils.escape_keymap(key)
  -- Prepend with a letter so it can be used as a dictionary key
  return "k" .. key:gsub(".", string.byte)
end

-- grabbed from https://github/norcalli/nvim-utils
function utils.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command("augroup " .. group_name)
    api.nvim_command("autocmd!")
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten {"autocmd", def}, " ")
      api.nvim_command(command)
    end
    api.nvim_command("augroup END")
  end
end

return utils
