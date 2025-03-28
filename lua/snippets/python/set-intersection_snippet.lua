local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "set-intersection",
      fmt(
        [[
{} & {}
]],
        {
          i(1, "set1"),
          i(2, "set2"),
        }
      )
    ),
  },
}

return snippet
