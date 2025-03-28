local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "loop_on_list_popping_elements",
      t([[
while my_list:
    # pop the first element from the list, when finished exits the loop
    elem = my_list.pop(0)
    print(elem)
]])
    ),
  },
}

return snippet
