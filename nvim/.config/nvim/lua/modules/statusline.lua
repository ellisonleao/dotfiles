local builtin = require("el.builtin")
local extensions = require("el.extensions")
local subscribe = require("el.subscribe")
local sections = require("el.sections")
local lsp_statusline = require("el.plugins.lsp_status")

require("nvim-web-devicons").setup()

vim.api.nvim_command("hi! link ElInsert GruvboxRedBold")
vim.api.nvim_command("hi! link ElVisual GruvboxPurpleBold")
vim.api.nvim_command("hi! link ElCommand GruvboxOrangeBold")

local generator = function(_)
  return {
    extensions.mode,
    sections.split,
    builtin.responsive_file(140, 90),
    sections.collapse_builtin {" ", builtin.modified_flag},
    sections.split,
    lsp_statusline.segment,
    lsp_statusline.current_function,
    lsp_statusline.server_progress,
    "[" .. builtin.line_with_width(3) .. ":" .. builtin.column_with_width(2) .. "]",
    subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, buffer)
      return "[" .. buffer.filetype .. " " .. extensions.file_icon(_, buffer) .. "]"
    end),
  }
end

require("el").setup({generator = generator})
