local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "journal-task-branch",
      fmt(
        [[
- "{}" - created on {}, derived from "{}" at commit "{}" (merged into "{}" on YYYY-MM-DD)]],
        {
          i(1, "branch-name"),
          f(function()
            return os.date("%Y-%m-%d")
          end),
          i(2, "derived-branch-name"),
          i(3, "derived-branch-commit-hash"),
          i(4, "merged-branch-name"),
        }
      )
    ),
  },
}

return snippet
