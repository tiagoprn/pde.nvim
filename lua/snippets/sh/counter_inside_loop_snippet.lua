local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "counter_inside_loop",
      t(
        "# initializes the counter (put BEFORE the loop)\ncounter=0\n# increments on each loop (put INSIDE the loop)\ncounter=$((counter + 1))"
      )
    ),
  },
}

return snippet
