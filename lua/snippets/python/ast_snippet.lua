local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "ast",
      fmt(
        [[
import ast
print(ast.dump(ast.parse("{}")))
]],
        {
          i(1, "python_code_as_string"),
        }
      )
    ),
  },
}

return snippet
