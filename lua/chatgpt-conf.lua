-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, chatgpt = pcall(require, "chatgpt")
if not status_ok then
	return
end

chatgpt.setup({
	chat = {
		popup_layout = {
			default = "center",
			center = {
				width = "90%",
				height = "90%",
			},
			right = {
				width = "30%",
				width_settings_open = "50%",
			},
		},
	},
})
