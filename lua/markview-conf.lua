-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, markview = pcall(require, "markview")
if not status_ok then
  return
end

-- https://github.com/OXY2DEV/markview.nvim/wiki/Configuration

markview.setup({
  highlight_groups = "dark",
  preview = {
    enable_hybrid_mode = false,
    linewise_hybrid_mode = false,
    enable = false,
    hybrid_modes = {},
  },
  markdown_inline = {
    checkboxes = {
      enable = false,
    },
  },
  markdown = {
    list_items = {
      enable = false,
    },
  },
})
