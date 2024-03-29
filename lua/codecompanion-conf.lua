-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, codecompanion = pcall(require, "codecompanion")
if not status_ok then
	return
end

codecompanion.setup({
	adapters = {
		chat = require("codecompanion.adapters").use("openai", {
			env = {
				api_key = "cmd:pass api-keys/OPENAI 2>/dev/null",
			},
		}),
		inline = "openai",
	},
	saved_chats = {
		save_dir = vim.fn.getenv("HOME") .. "/nvim-codecompanion/saved_chats", -- Path to save chats to
	},
})
