local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  markdown = {
    new_snippet(
      "table",
      fmt(
        [[
| {} | {} |
| {} | {} |
| {} | {} |
]],
        {
          i(1, "title column 1"),
          i(2, "title column 2"),
          i(3, "row 1 column 1"),
          i(4, "row 1 column 2"),
          i(5, "row 2 column 1"),
          i(6, "row 2 column 2"),
        }
      )
    ),
  },
}

return snippet
