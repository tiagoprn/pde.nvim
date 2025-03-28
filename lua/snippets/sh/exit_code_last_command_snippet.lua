local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  sh = {
    simple_text_snippet("exit_code_last_command", t('EXIT_CODE=$?\necho -e "EXIT_CODE=$EXIT_CODE"')),
  },
}

return snippet
