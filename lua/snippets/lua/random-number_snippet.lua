local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "random-number",
      t([[
local random_number = math.random(100, 999)]])
    ),
  },
}

return snippet
