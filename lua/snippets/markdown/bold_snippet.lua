local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  markdown = {
    new_snippet(
      "**",
      fmt(
        [[
**{}**
]],
        {
          i(1, "bold"),
        }
      )
    ),
  },
}

return snippet
