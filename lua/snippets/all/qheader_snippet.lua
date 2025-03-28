local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "qheader",
      fmt(
        [[
---
created: {}
modified: {}
type: Journal
---

{}]],
        {
          f(function()
            return os.date("%Y-%m-%dT%H:%M:%S")
          end),
          f(function()
            return os.date("%Y-%m-%dT%H:%M:%S")
          end),
          i(1, ""),
        }
      )
    ),
  },
}

return snippet
