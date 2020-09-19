-- vim.cmd [[ packadd plenary.nvim ]]
-- vim.cmd [[ packadd express_line.nvim ]]
-- vim.cmd [[ packadd nvim-web-devicons ]]
-- vim.cmd [[ packadd lsp-status.nvim ]]
local builtin = require("el.builtin")
local extensions = require("el.extensions")
local subscribe = require("el.subscribe")
local sections = require("el.sections")
local lsp_statusline = require("el.plugins.lsp_status")

require("nvim-web-devicons").setup()

local generator = function()
  return {
    extensions.mode,
    sections.split,
    sections.collapse_builtin {builtin.file, builtin.modified_flag},
    sections.split,
    lsp_statusline.segment,
    lsp_statusline.current_function,
    lsp_statusline.server_progress,
    "[" .. builtin.line .. ":" .. builtin.column .. "]",
    subscribe.buf_autocmd("el_file_icon", "BufRead", function(_, buffer)
      return "[" .. buffer.filetype .. " " .. extensions.file_icon(_, buffer) .. "]"
    end),
  }
end

require("el").setup({generator = generator})
