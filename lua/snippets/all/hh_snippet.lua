local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "hh",
      f(function()
        return os.date("%H:%M")
      end)
    ),
  },
}

return snippet
