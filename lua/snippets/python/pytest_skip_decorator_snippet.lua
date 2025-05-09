local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pytest_skip_decorator",
      fmt(
        [[
@pytest.mark.skip(reason="{}")
]],
        {
          i(1, ""),
        }
      )
    ),
  },
}

return snippet
