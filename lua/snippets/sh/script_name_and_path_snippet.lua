local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local interactive_snippet = ls.s -- Use fmt with simpler braces

local snippet = {
  sh = {
    simple_text_snippet(
      "script_name_and_path",
      t(
        'script_name=$(basename "${0}")\nscript_path=$(dirname "$(readlink -f "${0}")")\nscript_path_with_name="$script_path/$script_name"\necho "script path: $script_path"\necho "script name: $script_name"\necho "script path with name: $script_path_with_name"'
      )
    ),
  },
}

return snippet
