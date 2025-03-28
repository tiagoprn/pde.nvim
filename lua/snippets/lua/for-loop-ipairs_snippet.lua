local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "for-loop-ipairs",
      fmt(
        [[
for {},{} in ipairs({}) do
  {}
end]],
        { i(1, "i"), i(2, "v"), i(3, "table_name"), i(0, "-- body") }
      )
    ),
  },
}

return snippet
