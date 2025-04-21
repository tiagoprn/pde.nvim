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
      fmt(
        [[
@pytest.mark.parametrize('{}',
    [
        ({},),
        ({},),
    ],
)
def test_{}({}):{}
        ]],
        {
          i(1, "var1,var2"),
          i(2, "'tuple1-var1', 'tuple1-var2'"),
          i(3, "'tuple2-var1', 'tuple2-var2'"),
          i(4, "name"),
          f(function(args)
            return args[1][1]
          end, { 1 }),
          f(function(args)
            local vars = args[1][1]
            local var_list = {}
            for var in string.gmatch(vars, "([^,]+)") do
              table.insert(var_list, var:match("^%s*(.-)%s*$")) -- trim whitespace
            end

            local comment = "\n    # use "
            for i, var in ipairs(var_list) do
              if i > 1 then
                comment = comment .. " and "
              end
              comment = comment .. var
            end
            comment = comment .. " here"
            return comment
          end, { 1 }),
        }
      )
    ),
  },
}

return snippet
