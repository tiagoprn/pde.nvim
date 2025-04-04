local base_picker = require("tiagoprn.telescope_template_picker")
local M = {}

function M.preview_and_open_codecompanion_chat_history()
  local chats_dir = vim.fn.expand("~/.local/share/nvim/code-companion-chat-history/")
  local prompt_title = "Chat History (press ENTER to open on a new tab)"

  base_picker.preview_and_open_file(chats_dir, prompt_title)
end

return M
