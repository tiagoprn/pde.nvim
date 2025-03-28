local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    interactive_snippet(
      "aliases_enable",
      fmt("shopt -s expand_aliases\nsource $HOME/.bashrc\n\n{}", {
        i(0, ""),
      })
    ),
  },
}

return snippet
