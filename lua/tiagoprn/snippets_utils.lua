local base_picker = require("tiagoprn.telescope_template_picker")
local M = {}

function M.preview_and_open_snippet()
  local snippets_dir = vim.fn.expand("~/.config/nvim/lua/snippets/")
  local prompt_title = "Snippets (press ENTER to open on a new tab)"

  base_picker.preview_and_open_file(snippets_dir, prompt_title)
end

return M
