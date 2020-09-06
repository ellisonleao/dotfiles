local http = require("http")
local snippets = {}

-- grab licenses copy using github's API
local function licenses(input)
  local url = "https://api.github.com/licenses/" .. input
  local response = http.get(url)
  return response.body
end

-- golang snippets
local function go_snippets()
  local snp_utils = require("snippets.utils")
  return {
    errn = snp_utils.match_indentation [[
if err != nil {
    ${0}
}
    ]];
    fp = "fmt.Println(\"${0}\")";
    fpf = "fmt.Printf(\"${0}\", \"${1:i}\")";
  }
end

-- lua snippets
local function lua_snippets()
  local snp_utils = require("snippets.utils")
  return {
    ["fun"] = snp_utils.match_indentation [[
function ${1}()

end
]];
    ["for"] = snp_utils.match_indentation [[
for ${1:i}, ${2:1} in ipairs(${3:i}) do
  ${0}
end
    ]];
  }
end

local function global_snippets()
  local snp_utils = require("snippets.utils")
  return {
    todo = snp_utils.force_comment("TODO(ellisonleao)");
    now = snp_utils.force_comment("${=os.date()}");
  }
end

function snippets.config()
  local snp = require("snippets")
  snp.set_ux(require("snippets.inserters.vim_input"))
  snp.use_suggested_mappings()

  vim.g.completion_enable_snippet = "snippets.nvim"

  -- snippets list
  snp.snippets = {
    _global = global_snippets();
    lua = lua_snippets();
    go = go_snippets();
  }
end

return snippets.config()
