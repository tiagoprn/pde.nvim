local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pprint_to_console",
      fmt(
        [[
print('\n'); __import__('pprint').pprint({}, width=2); print('\n');  # noqa: E702, E703
]],
        {
          i(1, "var_name"),
        }
      )
    ),
  },
}

return snippet
