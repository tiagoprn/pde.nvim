local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "embed_python_on_bash",
      t(
        '#!/bin/bash\na=10\nb=20\ncode="\nimport json;\nprint(json.dumps({\'a\': $a, \'b\': $b}, indent=2))\n"\njson=$(python3 -c "$code")\n# Use json content\necho -e "$json"'
      )
    ),
  },
}

return snippet
