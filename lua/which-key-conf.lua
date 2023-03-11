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
			name = "+sample LEADER group",
			f = { "<cmd>Telescope find_files<cr>", "LEADER Find File" },
			r = { "<cmd>Telescope oldfiles<cr>", "LEADER Open Recent File" },
			n = { "<cmd>enew<cr>", "LEADER New File" },
		},
		--
		l = {
			name = "+lazy",
		},
		s = {
			name = "+session",
		},
		f = {
			name = "+files",
		},
		g = {
			name = "+grep",
		},
		t = {
			name = "+tree",
		},
		T = {
			name = "+toggle",
		},
		w = {
			name = "+writing",
		},
		c = {
			name = "+coding",
		},
		b = {
			name = "+clipboard",
		},
		q = {
			name = "+quickfix",
		},
		m = {
			name = "+messages / notifications",
		},
		o = {
			name = "+formatting",
		},
		h = {
			name = "+harpoon",
		},
		x = {
			name = "+external commands",
		},
		p = {
			name = "+python",
		},
		e = {
			name = "+etc",
		},
	},
})
