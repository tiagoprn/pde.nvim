-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, dap_view = pcall(require, "dap-view")
if not status_ok then
  return
end

-- https://igorlfs.github.io/nvim-dap-view/configuration

dap_view.setup({
  winbar = {
    default_section = "scopes",
  },
  windows = {
    size = 0.30,
    terminal = {
      size = 1,
      position = "below",
    },
  },
})
