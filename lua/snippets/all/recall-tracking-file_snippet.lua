local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "recall-tracking-file",
      i(
        1,
        [[
# Tracking Journal

## Card Status Legend
- Status: EASY (21 days), GOOD (14 days), HARD (7 days), FORGOT (1 day)
- Format: id, direction(A/AR), status, current_interval, next_review_date

recall-tracking-file-entry]]
      )
    ),
  },
}

return snippet
