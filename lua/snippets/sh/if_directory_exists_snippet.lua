local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    interactive_snippet(
      "if_directory_exists",
      fmt('if [ -d "{}" ]; then\n\techo "Directory exists \\o/"\nelse\n\techo "Directory DOES NOT exist :("\nfi', {
        i(1, "DIRECTORY"),
      })
    ),
  },
}

return snippet
