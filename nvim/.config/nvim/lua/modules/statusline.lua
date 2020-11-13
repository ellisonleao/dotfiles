local gl = require("galaxyline")
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
  n = colors.light4,
  v = colors.faded_orange,
  i = colors.faded_blue,
  c = colors.faded_aqua,
  R = colors.faded_yellow,
  t = colors.faded_green,
}

gls.left[1] = {
  ViMode = {
    provider = function()
      local alias = {
        n = "NORMAL",
        i = "INSERT",
        c = "COMMAND",
        v = "VISUAL",
        R = "REPLACE",
        t = "TERMINAL",
      }
      -- dirty hack to get bg updates for vi mode
      local bg, fg = mode_highlights[vim.fn.mode()]
      vim.api.nvim_command(string.format("hi GalaxyViMode guifg=%s guibg=%s gui=bold",
                                         fg, bg))
      return alias[vim.fn.mode()]
    end,
    highlight = {colors.light4, colors.dark0, "bold"},
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
    highlight = {colors.light0, colors.faded_blue, "bold"},
  },
}
gls.left[3] = {
  DiffAdd = {
    provider = "DiffAdd",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.faded_green, colors.dark0_hard, "bold"},
  },
}
gls.left[4] = {
  DiffModified = {
    provider = "DiffModified",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.faded_aqua, colors.dark0_hard, "bold"},
  },
}
gls.left[5] = {
  DiffRemove = {
    provider = "DiffRemove",
    condition = checkwidth,
    icon = " ",
    highlight = {colors.faded_red, colors.dark0_hard, "bold"},
  },
}

-- LSP
gls.left[6] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = {colors.faded_red, colors.dark0_hard, "bold"},
  },
}
gls.left[7] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = {colors.faded_yellow, colors.dark0_hard, "bold"},
  },
}

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
    highlight = {colors.light0, colors.dark0_hard, "bold"},
  },
}
gls.right[2] = {
  ScrollBar = {provider = "ScrollBar", highlight = {colors.faded_green, colors.dark0}},
}
