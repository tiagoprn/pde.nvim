local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pytest_parametrize",
      t([[
@pytest.mark.parametrize('var1,var2',
    [
        ('tuple1-var1', 'tuple1-var2',),
        ('tuple2-var1', 'tuple2-var2',),
    ],
)
def test_name(var1, var2):
    # use var1 and var2 here
]])
    ),
  },
}

return snippet
