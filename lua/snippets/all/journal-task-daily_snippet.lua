local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "journal-task-daily",
      fmt(
        [[
## {}

### DID

TBD

### DOING

TBD

### NEXT

- [ ] {}
- [ ] rnote: Draw a diagram with the tables involved, if that is the case]],
        {
          f(function()
            return os.date("%Y-%m-%d")
          end),
          i(1, "..."),
        }
      )
    ),
  },
}

return snippet
