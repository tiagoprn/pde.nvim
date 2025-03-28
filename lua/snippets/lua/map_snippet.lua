local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "map",
      fmt(
        [[
map.set("{}", "{}", "{}", {{ desc = "{}" }})]], -- Fixed placeholders
        { i(1, "n"), i(2, "command"), i(3, "action"), i(4, "description") }
      )
    ),
  },
}

return snippet
