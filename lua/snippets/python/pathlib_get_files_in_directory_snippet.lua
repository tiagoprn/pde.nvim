local ls = require("luasnip")
local new_snippet = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmt = require("luasnip.extras.fmt").fmt

local snippet = {
  python = {
    new_snippet(
      "pathlib_get_files_in_directory",
      t([[
from pathlib import Path

def get_files(path='.', filetype = ".py"):
    # globs notation:
    # **/* : search on subdirectories
    # *    : search on current directory
    files = Path(path).glob('**/*' + filetype)
    for file_name in files:
        print(file_name)
]])
    ),
  },
}

return snippet
