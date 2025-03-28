local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "json_dict_to_file",
      fmt(
        [[
with open("/tmp/output.json", "w+") as output_file:
    output_file.write(__import__('json').dumps({}, indent=2))
]],
        {
          i(1, "dict_var_name"),
        }
      )
    ),
  },
}

return snippet
