local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "ic",
      t([[
from icecream import ic
ic.configureOutput(prefix='icecream debug-> ')
ic('world')
]])
    ),
  },
}

return snippet
