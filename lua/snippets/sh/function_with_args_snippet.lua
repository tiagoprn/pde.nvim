local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "function_with_args",
      t(
        'my_function()\n{\n\tlocal first_param=${1}\n\tlocal second_param=${2}\n\techo "first param: $first_param, second param: $second_param"\n}\n\nmy_function "FIRST" "SECOND"'
      )
    ),
  },
}

return snippet
