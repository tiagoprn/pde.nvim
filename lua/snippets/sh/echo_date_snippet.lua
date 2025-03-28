local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    -- Use simple fmt with proper escaping for echo
    interactive_snippet(
      "echo_date",
      fmt('echo "[$(date +%r)]----> {}"', {
        i(1, "MESSAGE"),
      })
    ),
  },
}

return snippet
