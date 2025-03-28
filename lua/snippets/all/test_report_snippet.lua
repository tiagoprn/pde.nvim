local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "test_report",
      i(
        1,
        [[
- timestamp: `strftime("%Y-%m-%d %H:%M:%S")`

- environment: ${1:development (my machine), ci, etc..}

- branch: \`${2}\`

- context: ${3:describe here the reason I ran the suite - e.g. after refactoring xyz}

- file: <report.txt>]]
      )
    ),
  },
}

return snippet
