-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, bookmarks = pcall(require, "bookmarks")
if not status_ok then
  return
end

bookmarks.setup({
  save_file = vim.fn.getenv("HOME") .. "/.config/nvim.bookmarks",
})
