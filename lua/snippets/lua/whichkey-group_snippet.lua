local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "whichkey-group",
      fmt(
        [[
{} = {{
  name = "+{}",
}},]],
        { i(1, "key"), i(2, "group_name") }
      )
    ),
  },
}

return snippet
