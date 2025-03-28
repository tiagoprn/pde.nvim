local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "recall-tracking-file-entry",
      i(
        1,
        [[
## ${1: today}
- ${2: card_id, card_direction(A/AR), status, current_interval, next_review_date}]]
      )
    ),
  },
}

return snippet
