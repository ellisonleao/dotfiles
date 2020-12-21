local gl = require("galaxyline")
local colors = require("gruvbox.palette")
local gls = gl.section
local vcs = require("galaxyline.provider_vcs")

local function skip_filetypes(ft)
  if ft == nil then
    return false
  end

  local fts = {"help", "gitcommit", "fugitive", "telescope", "packer"}
  for _, filetype in pairs(fts) do
    if ft == filetype then
      return false
    end
  end
  return true
end

local function checkwidth()
  local squeeze_width = vim.fn.winwidth(0) / 2
  if squeeze_width > 40 then
    return true
  end
  return false
end

local function get_mode_highlights(mode, bg)
  local guibg
  local dark_colors = {
    n = colors.light4,
    v = colors.bright_orange,
    i = colors.bright_blue,
    c = colors.bright_aqua,
    R = colors.bright_yellow,
    t = colors.bright_green,
  }
  local light_colors = {
    n = colors.dark4,
    v = colors.faded_orange,
    i = colors.faded_blue,
    c = colors.faded_aqua,
    R = colors.faded_yellow,
    t = colors.faded_green,
  }
  if bg == "dark" then
    guibg = dark_colors[mode]
  else
    guibg = light_colors[mode]
  end
  return colors.dark0, guibg
end

local separator = {symbol = " ", highlight = {colors.dark0, colors.dark0, nil}}

local get_lsp_by_ft = function(buf, clients)
  if buf == nil then
    return ""
  end
  local ft = vim.bo[buf].ft

  for _, val in ipairs(clients) do
    local filetypes = val.config.filetypes
    for _, ftype in pairs(filetypes) do
      if ftype == ft then
        return val.name
      end
    end
  end
  return ""
end

gls.left[1] = {
  ViMode = {
    provider = function()
      local alias = {
        n = "  NORMAL ",
        i = "  INSERT ",
        c = "  COMMAND ",
        v = "  VISUAL ",
        R = "  REPLACE ",
        t = "  TERMINAL ",
      }
      -- dirty hack to get bg updates for vi mode
      local bg = vim.o.background
      local guifg, guibg = get_mode_highlights(vim.fn.mode(), bg)
      vim.api.nvim_command(string.format("hi GalaxyViMode guifg=%s guibg=%s gui=bold",
                                         guifg, guibg))
      return alias[vim.fn.mode()]
    end,
    separator = separator.symbol,
    separator_highlight = separator.highlight,
  },
}

gls.left[2] = {
  GitBranch = {
    provider = function()
      local branch = vcs.get_git_branch()
      if branch == nil then
        return ""
      end
      local icon = "  "
      return icon .. branch
    end,
    condition = function()
      return vcs.get_git_branch() ~= nil
    end,
    separator = separator.symbol,
    separator_highlight = separator.highlight,
  },
}

gls.left[3] = {
  LspInfo = {
    condition = function()
      local buf = vim.api.nvim_get_current_buf()
      return skip_filetypes(vim.bo[buf].ft)
    end,
    provider = function()
      local active_clients = vim.lsp.get_active_clients()
      local buf = vim.api.nvim_get_current_buf()
      local lsp_name = get_lsp_by_ft(buf, active_clients)
      return lsp_name ~= "" and " " .. lsp_name or ""
    end,
    separator = separator.symbol,
    separator_highlight = separator.highlight,
  },
}

gls.left[4] = {DiffAdd = {provider = "DiffAdd", condition = checkwidth, icon = " "}}

gls.left[5] = {
  DiffModified = {
    provider = "DiffModified",
    condition = checkwidth,
    icon = " ",
    separator_highlight = separator.highlight,
  },
}

gls.left[6] = {
  DiffRemove = {provider = "DiffRemove", condition = checkwidth, icon = " "},
}

-- LSP
gls.left[7] = {
  DiagnosticError = {
    provider = "DiagnosticError",
    icon = "  ",
    highlight = {colors.faded_red, colors.dark0_hard, "bold"},
  },
}
gls.left[8] = {
  DiagnosticWarn = {
    provider = "DiagnosticWarn",
    icon = "  ",
    highlight = {colors.faded_yellow, colors.dark0_hard, "bold"},
  },
}

gls.right[1] = {
  FileName = {
    condition = function()
      local buf = vim.api.nvim_get_current_buf()
      local ft = vim.bo[buf].ft
      return skip_filetypes(ft)
    end,
    provider = function()
      local fileinfo = require("galaxyline.provider_fileinfo")
      local icon = fileinfo.get_file_icon()
      local output = fileinfo.get_current_file_name()
      return icon .. string.gsub(output, "/home/ellison", "~")
    end,
  },
}
gls.right[2] = {LinePercent = {provider = "LinePercent"}}
gls.right[3] = {ScrollBar = {provider = "ScrollBar"}}
