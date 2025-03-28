local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  lua = {
    new_snippet(
      "nvim-get-node-under-cursor",
      t([[
local node = vim.treesitter.get_node()
-- see <https://www.youtube.com/watch?v=q-oBU2fO1H4> to check how do deal with treesitter nodes]])
    ),
  },
}

return snippet
