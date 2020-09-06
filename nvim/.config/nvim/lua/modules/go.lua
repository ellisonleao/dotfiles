--- Go layer
require("nvim_utils")

local go = {}

local function build_go_files()
  local file = nvim.fn.expand('%')
  local is_test_file = file:sub(-#"_test.go") == "_test.go"
  if is_test_file then
    nvim.call("go#test#Test", {0, 1})
  else
    nvim.call("go#cmd#Build", 0)
  end
end

function go.config()
    local mappings = {
      ["n<leader>c"] = {"<Plug>(go-coverage-toggle)", {buffer=true; silent=true;}};
      ["n<leader>r"] = {"<Plug>(go-run)", {buffer=true; silent=true;}};
      ["n<leader>l"] = {"<Plug>(go-metalinter)", {buffer=true; silent=true;}};
      ["n<leader>b"] = {build_go_files, {buffer=true; silent=true;}};
    }

    nvim.bo.shiftwidth = 4
    nvim.bo.tabstop = 4

    -- vim-test
    nvim.g["test#go#executable"] = "go test -v"

    -- vim-go vars
    nvim.g.go_fmt_command = "goimports"
    nvim.g.go_list_type = "quickfix"
    nvim.g.go_addtags_transform = "camelcase"
    nvim.g.go_metalinter_command = "golangci-lint run --fix --out-format tab"
    nvim.g.go_metalinter_enabled = {}
    nvim.g.go_metalinter_autosave_enabled = {}

    nvim_apply_mappings(mappings)
    nvim.print("go config called!")
end

return go
