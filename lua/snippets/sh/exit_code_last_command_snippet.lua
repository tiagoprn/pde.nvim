local ls = require("luasnip")
local simple_text_snippet = ls.snippet -- Simple snippets with text nodes
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  sh = {
    simple_text_snippet("exit_code_last_command", t('EXIT_CODE=$?\necho -e "EXIT_CODE=$EXIT_CODE"')),
  },
}

return snippet
