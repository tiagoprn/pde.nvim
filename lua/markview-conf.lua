-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, markview = pcall(require, "markview")
if not status_ok then
  return
end

markview.setup({
  highlight_groups = "dark",
  preview = {
    enable = false,
    hybrid_modes = { "n" },
  },
  checkboxes = {
    enable = true,
  },
  markdown = {
    list_items = {
      enable = false,
    },
  },
})
