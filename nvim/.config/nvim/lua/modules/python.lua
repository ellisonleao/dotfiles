--- Python layer
local python = {}
require("nvim_utils")

function python.config()
  nvim.g["test#python#runner"] = "pytest"
  nvim.bo.formatprg = "black"
  print("python configs loaded")
end

return python
