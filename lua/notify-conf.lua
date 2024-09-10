-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, notify = pcall(require, "notify")
if not status_ok then
	return
end

notify.setup({
	opacity = 50,
	fps = 60,
	timeout = 100,
	top_down = false,
	stages = "slide", -- slide, fade, fade_in_slide_out, static
	render = "minimal", -- minimal, simple, default
})
