local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "colors_simple",
      t(
        "# Define color variables\nRED='\\033[0;31m'\nNC='\\033[0m' # No Color\n\n# example: Print part of a string in red\necho -e \"This is ${RED}a test${NC}, and the remaining is back to normal font color.\""
      )
    ),
  },
}

return snippet
