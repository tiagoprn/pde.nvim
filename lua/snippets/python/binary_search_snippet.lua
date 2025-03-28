local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "binary_search",
      t([[
import bisect
index_that_has_555_on_an_array = bisect.bisect(my_array, 555)
bisect.insort(my_array, 666)  # insert element on the binary tree
]])
    ),
  },
}

return snippet
