local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  markdown = {
    new_snippet(
      "image",
      fmt(
        [[
![{}]({})
]],
        {
          i(1, "alttext"),
          i(2, "/images/image.jpg"),
        }
      )
    ),
  },
}

return snippet
