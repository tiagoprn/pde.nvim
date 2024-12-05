-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, bookmarks = pcall(require, "spelunk")
if not status_ok then
  return
end

bookmarks.setup({
  enable_persist = true,
  base_mappings = {
    -- Toggle the UI open/closed
    toggle = "<leader>kk",
    -- Add a bookmark to the current stack
    add = "<leader>ka",
    -- Move to the next bookmark in the stack
    next_bookmark = "<leader>kn",
    -- Move to the previous bookmark in the stack
    prev_bookmark = "<leader>kp",
    -- Fuzzy-find all bookmarks
    search_bookmarks = "<leader>kf",
    -- Fuzzy-find bookmarks in current stack
    search_current_bookmarks = "<leader>kc",
  },
})
