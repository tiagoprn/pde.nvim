local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "function",
      fmt(
        [[
function {}({})
  {}
end]],
        { i(1, "fname"), i(2, "..."), i(0, "-- body") }
      )
    ),
  },
}

return snippet
