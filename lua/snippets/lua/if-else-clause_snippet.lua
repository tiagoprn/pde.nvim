local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "if-else-clause",
      fmt(
        [[
if {} then
  {}
else
  {}
end]],
        { i(1, "condition"), i(2, "-- if condition"), i(0, "-- else") }
      )
    ),
  },
}

return snippet
