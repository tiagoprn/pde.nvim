local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "journal-task-branch",
      i(
        1,
        [[
- "${1:branch-name}" - created on `strftime("%Y-%m-%d")`, derived from "${2:derived-branch-name}" at commit "${3:derived-branch-commit-hash}" (merged into "${4:merged-branch-name}" on YYYY-MM-DD)]]
      )
    ),
  },
}

return snippet
