local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "test_report",
      fmt(
        [[
- timestamp: {}

- environment: {}

- branch: `{}`

- context: {}

- file: <report.txt>]],
        {
          f(function()
            return os.date("%Y-%m-%d %H:%M:%S")
          end),
          i(1, "development (my machine), ci, etc.."),
          i(2, ""),
          i(3, "describe here the reason I ran the suite - e.g. after refactoring xyz"),
        }
      )
    ),
  },
}

return snippet
