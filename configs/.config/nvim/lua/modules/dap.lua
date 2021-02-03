-- dap module
local dap = require("dap")

-- python
require("dap-python").setup("python")
require('dap-python').test_runner = 'pytest'

dap.adapters.go = {
  type = "executable",
  command = "node",
  args = {
    string.format("%s/go/vscode-go/dist/debugAdapter.js", vim.fn.stdpath("cache")),
  },
}
dap.configurations.go = {
  type = "go",
  name = "Debug",
  request = "launch",
  showLog = false,
  program = "${file}",
  dlvToolPath = vim.fn.exepath("dlv"),
}
