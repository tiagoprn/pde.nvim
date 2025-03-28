local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "regex",
      t([[
-- this can also be used when I need e.g. to split a string by some character.
local regex = "class%s%w+%(*.-%)*:"
local text = "class Casa: \n this is a houre"
for match in string.gmatch(text, regex) do
    -- If a match is found, print the match
    print(match)
end]])
    ),
  },
}

return snippet
