local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "sort_list_items_alphabetically",
      t([[
# the "key" param below makes sort ignore the case,
# as if all strings on the list are lowercase.
sorted(lst, key=str.lower)

# to sort in reverse order and ignoring the case
sorted(lst, key=str.lower, reverse=True)
]])
    ),
  },
}

return snippet
