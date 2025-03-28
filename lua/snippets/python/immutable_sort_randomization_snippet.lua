local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "immutable_sort_randomization",
      t([[
import random
test_list = [12, 34, 234, 452, -1]
sorted_list = sorted(test_list)  # you will create a new list, not changing test_list values
shuffled_list = random.sample(sorted_list, k=len(sorted_list))  # you will create a new list, not changing test_list values
]])
    ),
  },
}

return snippet
