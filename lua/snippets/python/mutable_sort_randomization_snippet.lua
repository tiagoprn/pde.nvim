local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "mutable_sort_randomization",
      t([[
import random
test_list = [12, 34, 234, 452, -1]
test_list.sort()  # this will change test_list values
print(test_list)
random.shuffle(test_list)   # this will change test_list
print(test_list)
]])
    ),
  },
}

return snippet
