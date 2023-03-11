-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

which_key.setup({})

which_key.register({
	["<leader>"] = {
		v = {
			name = "+custom LEADER group",
			f = { "<cmd>Telescope find_files<cr>", "LEADER Find File" },
			r = { "<cmd>Telescope oldfiles<cr>", "LEADER Open Recent File" },
			n = { "<cmd>enew<cr>", "LEADER New File" },
		},
	},
	["<C>"] = {
		n = {
			name = "+custom CTRL group",
			f = { "<cmd>Telescope find_files<cr>", "CTRL Find File" },
			r = { "<cmd>Telescope oldfiles<cr>", "CTRL Open Recent File" },
			n = { "<cmd>enew<cr>", "New File" },
		},
	},
})
