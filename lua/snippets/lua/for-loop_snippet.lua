local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "for-loop",
      fmt(
        [[
for {}={},{} do
  {}
end]],
        { i(1, "i"), i(2, "1"), i(3, "10"), i(0, "print(i)") }
      )
    ),
  },
}

return snippet
