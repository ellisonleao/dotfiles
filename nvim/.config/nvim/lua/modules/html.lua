--- HTML module
local M = {}

function M.config()
  vim.bo.shiftwidth = 2
  vim.bo.tabstop = 2
  vim.bo.softtabstop = 2
  vim.api.nvim_set_keymap("i", "<tab>", "emmet#expandAbbrIntelligent('<tab>')",
                          {expr = true})
  vim.cmd("EmmetInstall")
  vim.g.user_emmet_install_global = 0
end

return M
