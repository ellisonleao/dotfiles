vim.cmd [[packadd plenary.nvim]]
vim.cmd [[packadd nvim-web-devicons]]
vim.cmd [[packadd express_line.nvim]]

local builtin = require("el.builtin")
local extensions = require("el.extensions")
local sections = require("el.sections")
local subscribe = require("el.subscribe")
local lsp_statusline = require("el.plugins.lsp_status")

require("nvim-web-devicons").setup()

local generator = function()
  return {
    extensions.mode,
    sections.split,
    sections.collapse_builtin {"[", builtin.help_list, builtin.readonly_list, "]"},
    sections.split,
    subscribe.buf_autocmd("el_git_status", "BufWritePost", function(window, buffer)
      return extensions.git_changes(window, buffer)
    end),
    sections.split,
    builtin.file,
    sections.collapse_builtin {" ", builtin.modified_flag},
    sections.split,
    lsp_statusline.segment,
    lsp_statusline.current_function,
    "[" .. builtin.line .. ":" .. builtin.column .. "]",
    subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, buffer)
      return "[" .. buffer.filetype .. " " .. extensions.file_icon(_, buffer) .. "]"
    end),
  }
end

require("el").setup({generator = generator})
