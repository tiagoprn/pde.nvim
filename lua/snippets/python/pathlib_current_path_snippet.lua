local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pathlib_current_path",
      t([[
from pathlib import Path
current_path = str(Path().absolute())
print(f'current_path:{current_path}')
]])
    ),
  },
}

return snippet
