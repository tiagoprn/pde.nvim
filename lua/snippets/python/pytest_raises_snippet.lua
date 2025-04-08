local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pytest_raises",
      ls.snippet_node("", {
        t("with pytest.raises(IntegrityError) as exception_instance:"),
        t({
          "",
          "    pass  # code that triggers the exception, in this example SQLAlchemy when an attribute is None",
          "",
        }),
        t({ "", "assert exception_instance.type is IntegrityError" }),
        t({
          "",
          "expected_exception_value = '(pymysql.err.IntegrityError) (1048, \"Column \\'company_id\\' cannot be null\")'",
        }),
        t({ "", "assert exception_instance.value.args[0] == expected_exception_value" }),
      })
    ),
  },
}

return snippet
