local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  all = {
    new_snippet(
      "book_notes_body",
      i(
        1,
        [[
# IMPRESSIONS

${1:(here is where I write dowm my feelings/impressions about the book)}

# ACTIONABLE TAKEAWAYS

${2:(maximum of 10 top main points I learned from the book that can be applied to my life/routine)}

1.

2.

3.

4.

5.

6.

7.

8.

9.

10.

# QUOTES

${3:(maximum of 5 literal quotes that I must keep as they were written, so to remember or reuse on my own future content)}

1.

2.

3.

4.

5.

# ARCHIVE **(OPTIONAL)**

${4:(on books that are so great that there are many things to remember, here go extra notes and quotes that didn't make the "top" cuts above.)}

**NOTE**: the structure used here to write this post is inspired by <https://elizabeth-filips.notion.site/>.
]]
      )
    ),
  },
}

return snippet
