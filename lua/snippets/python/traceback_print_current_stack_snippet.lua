local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet( -- FIXME: error: failed to execute item with error: ....local/share/nvim/lazy/LuaSnip/lua/luasnip/util/util.lua:241: 'replacement string' item contains newlines
      "traceback_print_current_stack",
      t("__import__('traceback').print_stack()")
    ),
  },
}

return snippet
