local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pathlib_rootpath",
      t([[
from pathlib import Path
root_path = str(Path().absolute().parent)
print(f'root_path:{root_path}')
]])
    ),
  },
}

return snippet
