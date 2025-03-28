local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "qheader",
      i(
        1,
        [[
---
created: `strftime("%Y-%m-%dT%H:%M:%S")`
modified: `strftime("%Y-%m-%dT%H:%M:%S")`
type: Journal
---

${1}]]
      )
    ),
  },
}

return snippet
