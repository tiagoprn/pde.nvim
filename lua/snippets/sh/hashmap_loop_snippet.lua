local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "hashmap_loop",
      t(
        'declare -A MAPPINGS=(\n    [\'k1\']="value1"\n    [\'k2\']="value2"\n    [\'k3\']="value3"\n)\nfor key in "${!MAPPINGS[@]}"; do\n    value=${MAPPINGS[$key]}\n    echo "$key value is: $value"\ndone\n'
      )
    ),
  },
}

return snippet
