local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "journal-task-daily",
      i(
        1,
        [[
## `strftime("%Y-%m-%d")`

### DID

TBD

### DOING

TBD

### NEXT

- [ ] ${1:"..."}
- [ ] rnote: Draw a diagram with the tables involved, if that is the case]]
      )
    ),
  },
}

return snippet
