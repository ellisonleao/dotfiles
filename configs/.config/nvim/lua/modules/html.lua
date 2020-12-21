-- html module
vim.bo.shiftwidth = 4
vim.bo.softtabstop = 4
vim.api.nvim_set_keymap("i", "<tab>", "emmet#expandAbbrIntelligent('<tab>')",
                        {expr = true})
vim.cmd("EmmetInstall")
vim.g.user_emmet_install_global = 0
