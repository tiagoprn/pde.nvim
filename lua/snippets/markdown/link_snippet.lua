local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  markdown = {
    new_snippet(
      "link",
      fmt(
        [[
[{}](https://{})
]],
        {
          i(1, "text"),
          i(2, "address"),
        }
      )
    ),
  },
}

return snippet
