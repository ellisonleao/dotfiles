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
		     .:::.           `oyyo:`  `.--.`                        
    `ys/+sy+.-:///:` :y/.:syoysoo+oss:  ``          ```     
    .yo```-yso/::/oy//y:```:-.``````/ysysys-    -/oyssys`   
    .yo````.```````/yyy:`````-:/.````++.``oy/ /ys/-``.ys`   
    `yo`````.//.````oyy/````/yoys.```.:````+ysy/````-ys.    
    `ys````.ysys````-yy/````/y/+y:````s:````oy:````-ys`     
     yy````-y+sy````.yy+````:y/sy.```.yy:````-````:yo`      
     oy.```:y+yy````-yy+````:y+ys````/yyy:```````/y+        
     +y-```:yoys````/yyo````:ysy+````sy`oy/`````oy/         
     /y:```:ysyo````syys````:yyy-```/y/`oy:````.yy`         
     -y+```:ysy+```.yoyy````.sys```.ys`oy:``````-ys`        
     .yo```:yyy/```/y:sy``````..```oy:oy/```:+```:yo        
      yy```/yyy:```sy`oy.```-////+sy/+y/```+yyo.``/y/       
      oy.``+yyy:``:y+ +y-```/y+::-. -yo``.sy:-ys-``oy-      
      /y/-oy+:ys//sy. /y/```/y-     `sy:/ys.  `+yo:-ys      
      `+oo/.  `-:::`  -y+```+y-      `:++:      `:+ss/      
                      .yo```+y.                             
                       ys```oy.                             
                       sy.``sy`                             
                       /y:.oy/                              
                       `oys+.                               
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
local function zig_snippets()
  return {
    main = snp_utils.match_indentation [[ 
const std = @import("std");
pub fn main() void {
    std.debug.print("Hello, {}!\n", .{"World"});
}
]],
  }
end
local snp = require("snippets")
snp.use_suggested_mappings()
snp.set_ux(require("snippets.inserters.vim_input"))
-- snippets list
snp.snippets = {
  _global = global_snippets(),
  lua = lua_snippets(),
  go = go_snippets(),
  python = python_snippets(),
  zig = zig_snippets(),
}
