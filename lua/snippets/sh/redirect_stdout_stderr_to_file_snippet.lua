local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "redirect_stdout_stderr_to_file",
      t(
        ": '\nBash executes the redirects from left to right as follows:\n    >>file.txt: Open file.txt in append mode and redirect stdout there.\n    2>&1: Redirect stderr to \"where stdout is currently going\". In this case, that is a file opened in append mode. In other words, the &1 reuses the file descriptor which stdout currently uses.\n'\ncmd >>file.txt 2>&1"
      )
    ),
  },
}

return snippet
