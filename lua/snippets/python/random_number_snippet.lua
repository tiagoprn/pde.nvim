local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "random_number",
      fmt(
        [[
{}import random
import os

def generate_random_number(start: int, finish: int, seed_bytes:int=128) -> str:
    random.seed(os.urandom(seed_bytes))
    return random.randint(start, finish)
]],
        {
          i(1, ""),
        }
      )
    ),
  },
}

return snippet
