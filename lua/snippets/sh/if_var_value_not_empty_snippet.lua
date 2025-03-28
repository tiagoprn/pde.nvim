local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  sh = {
    simple_text_snippet(
      "if_var_value_not_empty",
      t(
        'MY_VAR="VALUE"\nif [ -n "${MY_VAR+set}" ]; then\n      echo "$MY_VAR has value! o/"\nelse\n      echo "$MY_VAR does not have value. :("\nfi'
      )
    ),
  },
}

return snippet
