-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, codecompanion = pcall(require, "codecompanion")
if not status_ok then
	return
end

-- NOTE: if this plugin breaks, here are the instructions to fix it: <https://github.com/olimorris/codecompanion.nvim/issues/9>

-- examples here: https://github.com/olimorris/codecompanion.nvim/blob/main/RECIPES.md#recipes
local custom_actions = {}

codecompanion.setup({
	adapters = {
		chat = require("codecompanion.adapters").use("openai", {
			env = {
				api_key = "cmd:pass api-keys/OPENAI 2>/dev/null",
			},
		}),
		inline = "openai",
	},
	actions = custom_actions,
	saved_chats = {
		save_dir = vim.fn.getenv("HOME") .. "/nvim-codecompanion/saved_chats", -- Path to save chats to
	},
})
