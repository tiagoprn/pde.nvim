local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "use",
      fmt(
        [[
use({{"{}"}})]],
        { i(1, "string") }
      )
    ),

    new_snippet(
      "function",
      fmt(
        [[
function {}({})
  {}
end]],
        { i(1, "fname"), i(2, "..."), i(0, "-- body") }
      )
    ),

    new_snippet(
      "for-loop",
      fmt(
        [[
for {}={},{} do
  {}
end]],
        { i(1, "i"), i(2, "1"), i(3, "10"), i(0, "print(i)") }
      )
    ),

    new_snippet(
      "for-loop-pairs",
      fmt(
        [[
for {},{} in pairs({}) do
  {}
end]],
        { i(1, "k"), i(2, "v"), i(3, "table_name"), i(0, "-- body") }
      )
    ),

    new_snippet(
      "nvim-filetype",
      t([[
local filetype = vim.bo.filetype]])
    ),

    new_snippet(
      "for-loop-ipairs",
      fmt(
        [[
for {},{} in ipairs({}) do
  {}
end]],
        { i(1, "i"), i(2, "v"), i(3, "table_name"), i(0, "-- body") }
      )
    ),

    new_snippet(
      "if-clause",
      fmt(
        [[
if {} then
  {}
end]],
        { i(1, "condition"), i(2, "-- body") }
      )
    ),

    new_snippet(
      "if-else-clause",
      fmt(
        [[
if {} then
  {}
else
  {}
end]],
        { i(1, "condition"), i(2, "-- if condition"), i(0, "-- else") }
      )
    ),

    new_snippet(
      "if-elif-clause",
      fmt(
        [[
elseif {} then
  {}]],
        { i(1, "condition"), i(0, "--body") }
      )
    ),

    new_snippet(
      "repeat-clause",
      fmt(
        [[
repeat
  {}
until {}]],
        { i(1, "--body"), i(0, "condition") }
      )
    ),

    new_snippet(
      "while-clause",
      fmt(
        [[
while {} do
  {}
end]],
        { i(1, "condition"), i(0, "--body") }
      )
    ),

    new_snippet(
      "notify",
      fmt(
        [[
vim.notify("{}")]],
        { i(1, "string") }
      )
    ),

    new_snippet(
      "open-file-for-reading",
      fmt(
        [[
local file = io.open({}, "r")
local lines = file:read("*all")
file:close()]],
        { i(1, "file_path") }
      )
    ),

    new_snippet(
      "open-file-for-writing",
      fmt(
        [[
local file = io.open({}, "a")
io.output(file)
io.write({})
io.close(file)]],
        { i(1, "file_path"), i(2, "content") } -- Added the missing second placeholder
      )
    ),

    new_snippet(
      "current-date",
      t([[
local current_date = os.date("%Y-%m-%d-%H%M%S")]])
    ),

    new_snippet(
      "random-number",
      t([[
local random_number = math.random(100, 999)]])
    ),

    new_snippet(
      "debug_lua_object_or_table",
      fmt(
        [[
print(vim.inspect({}))]],
        { i(1, "object_or_table") }
      )
    ),

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

    new_snippet(
      "map",
      fmt(
        [[
map.set("{}", "{}", "{}", {{ desc = "{}" }})]], -- Fixed placeholders
        { i(1, "n"), i(2, "command"), i(3, "action"), i(4, "description") }
      )
    ),

    new_snippet(
      "whichkey-item",
      fmt(
        [[
{} = {{"{}", "{}"}},]],
        { i(1, "key"), i(2, "command"), i(3, "description") }
      )
    ),

    new_snippet(
      "whichkey-group",
      fmt(
        [[
{} = {{
  name = "+{}",
}},]],
        { i(1, "key"), i(2, "group_name") }
      )
    ),

    new_snippet(
      "nvim-get-current-line",
      t([[
vim.fn.getline(".")]])
    ),

    new_snippet(
      "nvim-get-current-line-matching-regex",
      t([[
vim.fn.getline("."):match("amazing")]])
    ),

    new_snippet(
      "nvim-get-node-under-cursor",
      t([[
local node = vim.treesitter.get_node()
-- see <https://www.youtube.com/watch?v=q-oBU2fO1H4> to check how do deal with treesitter nodes]])
    ),
  },
}

return snippet
