local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "return_code",
      t('status=$?\n[ $status -eq 0 ] && echo "command successful" || echo "command unsuccessful"')
    ),
  },
}

return snippet
