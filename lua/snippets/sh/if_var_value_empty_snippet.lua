local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  sh = {
    simple_text_snippet(
      "if_var_value_empty",
      t(
        'MY_VAR="VALUE"\nif [ -z "${MY_VAR+set}" ]; then\n      echo "$MY_VAR is NULL"\nelse\n      echo "$MY_VAR is NOT NULL"\nfi'
      )
    ),
  },
}

return snippet
