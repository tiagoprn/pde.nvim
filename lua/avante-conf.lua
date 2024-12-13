-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, avante = pcall(require, "avante")
if not status_ok then
  return
end

-- https://github.com/yetone/avante.nvim?tab=readme-ov-file#custom-prompts

avante.setup({})
