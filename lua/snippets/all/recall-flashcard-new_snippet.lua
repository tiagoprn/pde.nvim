local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "recall-flashcard-new",
      fmt(
        [[
## Card
id: {}
Q: {}
A: {}
QR: {}
AR: {}
Tags: {}]],
        {
          f(function()
            return os.date("%s")
          end),
          i(1, "type the question here"),
          i(2, "type the answer here"),
          i(3, "type the reverse question here (turn the original answer into the question)"),
          i(4, "type the reverse answer here (turn the original question into the answer)"),
          i(5, "tag1, tag2, ..."),
        }
      )
    ),
  },
}

return snippet
