local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "iterate_files_on_directory",
      t(
        'FILES_PATH="/path/*.txt"\nfor FILE in $FILES_PATH; do\n\techo "----------------------"\n\techo "Full file path: $FILE"\n\tfilename=$(basename -- "$FILE")\n\techo "File name: $filename";\ndone'
      )
    ),
  },
}

return snippet
