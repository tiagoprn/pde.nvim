local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

-- TODO: change all snippets on this directory that use "strftime" to use the lua function returning the date/time as it was done with the snippet "journal"

local snippet = {
  all = {
    new_snippet("prompt_code_explain", i(1, [[  Can you explain the code above to me?]])),
    new_snippet(
      "prompt_unit_test",
      i(1, [[  Can you output a unit test for the happy path on the code above using pytest?]])
    ),
    new_snippet(
      "prompt_refactor",
      i(
        1,
        [[  Can you output a refactored version of the code above, using clean code principles and summarizing what you changed?]]
      )
    ),
  },
}

return snippet
