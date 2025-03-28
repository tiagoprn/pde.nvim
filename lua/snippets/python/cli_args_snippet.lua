local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "cli_args",
      t([[
import argparse

parser = argparse.ArgumentParser()
parser.add_argument("name", type=str, help="type the person name here")
parsed_arguments = parser.parse_args()
message = f"The 'name' arg has this value: {parsed_arguments.name}"
print(message)
]])
    ),
  },
}

return snippet
