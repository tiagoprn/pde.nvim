-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, markview = pcall(require, "markview")
if not status_ok then
  return
end

markview.setup({
  highlight_groups = "dark",
  hybrid_modes = { "n" },
  initial_state = true, -- show or do not show the preview when opening a file
  checkboxes = {
    enable = true,
  },
  list_items = {
    enable = false,
  },
})
