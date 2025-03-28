local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "if-clause",
      fmt(
        [[
if {} then
  {}
end]],
        { i(1, "condition"), i(2, "-- body") }
      )
    ),
  },
}

return snippet
