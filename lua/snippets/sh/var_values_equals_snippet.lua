local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  sh = {
    interactive_snippet(
      "var_value_equals",
      fmt("{}={}", {
        i(1, "VARIABLE_NAME"),
        i(2, "value"),
      })
    ),
  },
}

return snippet
