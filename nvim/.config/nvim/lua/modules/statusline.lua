local gl = require('galaxyline')
local colors = require("gruvbox.palette")
local gls = gl.section

local checkwidth = function()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

local mode_highlights = {
  n = colors.bright_green,
  v = colors.bright_orange,
  i = colors.light0,
  c = colors.bright_aqua,
}

gls.left[1] = {
  ViMode = {
    provider = function()
      local alias = {
        n = '  NORMAL  ',
        i = '  INSERT ',
        c = '  COMMAND ',
        v = '  VISUAL ',
      }
      return alias[vim.fn.mode()]
    end,
    highlight = {
      colors.dark0,
      function()
        return mode_highlights[string.lower(vim.fn.mode())]
      end,
      "bold",
    },
  },
}

gls.left[2] = {
  GitBranch = {
    provider = function()
      local vcs = require("galaxyline.provider_vcs")
      local branch = vcs.get_git_branch()
      local icon = "  "
      return icon .. branch
    end,
    condition = function()
      local vcs = require("galaxyline.provider_vcs")
      return vcs.get_git_branch() ~= nil
    end,
    highlight = {colors.light0, colors.faded_orange, "bold"},
  },
}
gls.left[3] = {
  DiffAdd = {
    provider = 'DiffAdd',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.faded_green, colors.dark0_hard, "bold"},
  },
}
gls.left[4] = {
  DiffModified = {
    provider = 'DiffModified',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.faded_aqua, colors.dark0_hard, "bold"},
  },
}
gls.left[5] = {
  DiffRemove = {
    provider = 'DiffRemove',
    condition = checkwidth,
    icon = ' ',
    highlight = {colors.faded_red, colors.dark0_hard, "bold"},
  },
}

-- LSP
gls.left[6] = {DiagnosticError = {provider = 'DiagnosticError', icon = '  '}}
gls.left[7] = {DiagnosticWarn = {provider = 'DiagnosticWarn', icon = '  '}}

gls.right[1] = {
  FileName = {
    provider = function()
      local fileinfo = require("galaxyline.provider_fileinfo")
      local icon = fileinfo.get_file_icon()
      local output = fileinfo.get_current_file_name()
      return icon .. string.gsub(output, "/home/ellison", "~")
    end,
    condition = function()
      return vim.bo.filetype ~= "help"
    end,
    highlight = {colors.light0, colors.dark2, "bold"},
  },
}
gls.right[2] = {
  ScrollBar = {provider = 'ScrollBar', highlight = {colors.faded_yellow, colors.dark0}},
}
