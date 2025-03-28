local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  sh = {
    simple_text_snippet(
      "argument_from_script_with_default_value",
      t(
        '# set to the value of the 1st argument passed to the script. If not passed, set "default_value".\nVAR_NAME=${1-"default_value"}'
      )
    ),
  },
}

return snippet
