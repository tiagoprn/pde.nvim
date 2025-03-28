local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "recall-flashcard-new",
      i(
        1,
        [[
## Card
id: `strftime("%s")`
Q: ${1:type the question here}
A: ${2:type the answer here}
QR: ${3:type the reverse question here (turn the original answer into the question)}
AR: ${4:type the reverse answer here (turn the original question into the answer)}
Tags: ${5:tag1, tag2, ...}]]
      )
    ),
  },
}

return snippet
