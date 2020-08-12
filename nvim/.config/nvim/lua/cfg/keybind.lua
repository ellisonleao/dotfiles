local keybind = {}
keybind._leader_info = {}

function keybind.bind_command(mode, keys, command, options)
  options = options or {}
  vim.api.nvim_set_keymap(mode.map_prefix, keys, command, options)
end

function keybind.buf_bind_command(mode, keys, command, options)
  options = options or {}
  vim.api.nvim_buf_set_keymap(0, mode.map_prefix, keys, command, options)
end

keybind._bound_funcs = {}

function keybind.bind_function(mode, keys, func, options)
  options = options or {}
  options.noremap = true

  local func_name = "bind_" .. mode.map_prefix .. "_" .. keys

  local func_name_escaped = func_name
  -- Escape Lua things
  func_name_escaped = func_name_escaped:gsub("'", "\\'")
  func_name_escaped = func_name_escaped:gsub('"', '\\"')
  func_name_escaped = func_name_escaped:gsub("\\[", "\\[")
  func_name_escaped = func_name_escaped:gsub("\\]", "\\]")

  -- Escape VimScript things
  -- We only escape `<` - I couldn't be bothered to deal with how <lt>/<gt> have angle brackets in themselves
  -- And this works well-enough anyways
  --
  func_name_escaped = func_name_escaped:gsub("<", "<lt>")

  keybind._bound_funcs[func_name] = func

  local lua_command =
    ":lua require('cfg.keybind')._bound_funcs['" .. func_name_escaped .. "']()<CR>"
  -- Prefix with <C-o> if this is an insert-mode mapping
  if mode.map_prefix == "i" then
    lua_command = "<C-o>" .. lua_command
  end

  vim.api.nvim_set_keymap(mode.map_prefix, keys, lua_command, options)

end

return keybind
