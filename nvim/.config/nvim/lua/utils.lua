local utils = {}
local api = vim.api

function utils.escape_keymap(key)
  -- Prepend with a letter so it can be used as a dictionary key
  return 'k' .. key:gsub('.', string.byte)
end

-- grabbed from https://github/norcalli/nvim-utils
function utils.nvim_create_augroups(definitions)
  for group_name, definition in pairs(definitions) do
    api.nvim_command('augroup ' .. group_name)
    api.nvim_command('autocmd!')
    for _, def in ipairs(definition) do
      local command = table.concat(vim.tbl_flatten {'autocmd'; def}, ' ')
      api.nvim_command(command)
    end
    api.nvim_command('augroup END')
  end
end

function utils.deep_extend(policy, ...)
  local result = {}
  local function helper(policy, k, v1, v2)
    if type(v1) ~= 'table' or type(v2) ~= 'table' then
      if policy == 'error' then
        error('Key ' .. vim.inspect(k) .. ' is already present with value ' ..
                vim.inspect(v1))
      elseif policy == 'force' then
        return v2
      else
        return v1
      end
    else
      return utils.deep_extend(policy, v1, v2)
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

return utils
