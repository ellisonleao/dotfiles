-- special settings for lua lsp
local M = {}

-- Configure lua language server for neovim development
M.lua_settings = {
  Lua = {
    runtime = {version = "LuaJIT", path = vim.split(package.path, ";")},
    diagnostics = {globals = {"vim", "R", "P", "PP"}},
    workspace = {
      library = {
        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
        [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true,
      },
    },
  },
}

M.lua_special_hover = function(word)
  local original_iskeyword = vim.bo.iskeyword

  vim.bo.iskeyword = vim.bo.iskeyword .. ',.'
  word = word or vim.fn.expand("<cword>")

  vim.bo.iskeyword = original_iskeyword

  if string.find(word, 'vim.api') then
    local _, finish = string.find(word, 'vim.api.')
    local api_function = string.sub(word, finish + 1)

    vim.cmd(string.format('help %s', api_function))
    return
  elseif string.find(word, 'vim.fn') then
    local _, finish = string.find(word, 'vim.fn.')
    local api_function = string.sub(word, finish + 1) .. '()'

    vim.cmd(string.format('help %s', api_function))
    return
  else
    local ok = pcall(vim.cmd, string.format('help %s', word))
    if not ok then
      local split_word = vim.split(word, '.', true)
      ok = pcall(vim.cmd, string.format('help %s', split_word[#split_word]))
    end

    if not ok then
      vim.lsp.buf.hover()
    end
  end
end

return M
