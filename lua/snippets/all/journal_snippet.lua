local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "journal",
      fmt(
        [[
---
date: {}
hours: ["{}"]
deep_work: [""]
---]],
        {
          f(function()
            return os.date("%Y-%m-%d")
          end),
          i(1, os.date("%H:%M")),
        }
      )
    ),
  },
}

return snippet
