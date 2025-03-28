local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "repeat-clause",
      fmt(
        [[
repeat
  {}
until {}]],
        { i(1, "--body"), i(0, "condition") }
      )
    ),
  },
}

return snippet
