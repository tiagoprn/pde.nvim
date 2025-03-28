local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pytest_run_on_condition",
      fmt(
        [[
@pytest.mark.skipif({}, reason="{}")
]],
        {
          i(1, "bool_condition"),
          i(2, "string_describing_condition"),
        }
      )
    ),
  },
}

return snippet
