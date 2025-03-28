local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "ordered_dict",
      fmt(
        [[
{} = OrderedDict[
    ('{}', '{}'),
]
]],
        {
          i(1, "dict_name"),
          i(2, "key"),
          i(3, "value"),
        }
      )
    ),
  },
}

return snippet
