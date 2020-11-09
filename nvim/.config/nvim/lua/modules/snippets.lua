local snp_utils = require("snippets.utils")

-- golang snippets
local function go_snippets()
  return {
    errn = snp_utils.match_indentation [[
if err != nil {
    ${0}
}
]],
    fp = "fmt.Println(\"${0}\")",
    fpf = "fmt.Printf(\"${0}\", \"${1:i}\")",
    ld = "log.Debug(\"${0}\")",
    lw = "log.Warning(\"${0}\")",
    lwfd = "log.WithField(\"${0}\", \"\").Debug(\"\")",
    lwfw = "log.WithField(\"${0}\", \"\").Warning(\"\")",
    lwfe = "log.WithField(\"${0}\", \"\").Error(\"\")",
  }
end

-- lua snippets
local function lua_snippets()
  return {
    ["fun"] = snp_utils.match_indentation [[
function ${1}()
  ${0}
end
]],
    ["for"] = snp_utils.match_indentation [[
for ${1:k}, ${2:p} in ipairs(${3}) do
  ${0}
end
]],
  }
end

local function global_snippets()
  return {
    todo = snp_utils.force_comment("TODO(ellisonleao)"),
    now = snp_utils.force_comment("${=os.date()}"),
    npx = snp_utils.force_comment [[
      (((((((*           .(( .(((,(((((((((,                          
      ((     ((((((((((( ,((    (*         (((((((/        (((((((    
      ((               (((((                ((   *((   ((((    /((    
      ((         ,      ((((      (((((            (((((      (((     
      ((.     (((((     .(((      ((.((.     (      ((*      ((*      
      (((     ((.((      (((      ((.((      ((*           *((        
      *((     ((.((     .(((      ((/((     (((((         (((         
       ((     ((.((     ((((      ((((.    ,(( ,((      *((           
       ((     ((/((     ((((      ((((     ((  ((/      .((           
       ((     ((((/    /((((      *((/    ((/ ((          ((          
       ((/    ((((,    (( ((/            ((( ((     ((     ((         
       *((    ((((    /(( /((     (((((((( .((    ((((((    ((        
        ((   (((((    ((   ((     ((       ((/   ((,  *((,  .((       
        ((((((   ((((((.   ((    .((        ((((((       ((((((       
                           ((    .((                                  
                           ((.   *((                                  
                           (((   /((                                  
                            ((  *((                                   
                            (((((,                                    
]],
  }
end

local function python_snippets()
  return {
    ifmain = snp_utils.match_indentation [[ 
def main():
    pass


if __name__ == "__main__":
    main()
]],
    kls = snp_utils.match_indentation [[
class ${1|vim.trim(S.v):gsub("^%l", string.upper)}:
    def __init__(self, *args, **kwargs):
        ${0}
        return
]],
  }
end

local snp = require("snippets")
snp.use_suggested_mappings()

vim.g.completion_enable_snippet = "snippets.nvim"
vim.g.completion_matching_strategy_list = {"exact", "substring", "fuzzy"}
vim.g.completion_trigger_keyword_length = 2

-- snippets list
snp.snippets = {
  _global = global_snippets(),
  lua = lua_snippets(),
  go = go_snippets(),
  python = python_snippets(),
}
