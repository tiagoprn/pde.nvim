-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, oil = pcall(require, "oil")
if not status_ok then
  return
end

oil.setup({
  columns = {
    "icon",
    "permissions",
    "size",
    "mtime",
  },
  view_options = {
    show_hidden = true,
  },
  float = {
    padding = 5,
  },
  watch_for_changes = true,
})

vim.keymap.set("n", "<Esc>", require("oil").close, { desc = "Close oil" })
