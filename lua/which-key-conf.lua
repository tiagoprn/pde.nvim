-- This allows nvim to not crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

which_key.setup({})

which_key.register({
	["<leader>"] = {
		-- v = {
		-- 	name = "+sample LEADER group",
		-- 	f = { "<cmd>Telescope find_files<cr>", "LEADER Find File" },
		-- 	r = { "<cmd>Telescope oldfiles<cr>", "LEADER Open Recent File" },
		-- 	n = { "<cmd>enew<cr>", "LEADER New File" },
		-- },
		--
		u = { ":undo<cr>", "undo changes" },
		r = { ":redo<cr>", "redo changes" },
		s = { ":w!<cr>", "save current buffer" },
		--
		l = {
			name = "+lazy",
		},
		S = {
			name = "+session",
		},
		f = {
			name = "+files",
			k = { ":bw<Enter>", "close buffer" },
			K = { ":bp<bar>sp<bar>bn<bar>bd<CR>", "close buffer & keep window" },
			w = { ":bufdo w!<cr>", "save all buffers" },
		},
		i = {
			name = "+lists",
		},
		g = {
			name = "+grep",
		},
		t = {
			name = "+tree",
		},
		T = {
			name = "+toggle",
			c = { ":set list!<cr>", "special chars (listchars)" },
			n = { ":set rnu!<cr>", "relative line numbers" },
			i = { ":set cuc!<CR>", "current column indentation" },
			l = { ":set cursorline!<CR>", "current line" },
		},
		w = {
			name = "+writing",
		},
		c = {
			name = "+coding",
		},
		b = {
			name = "+clipboard",
			n = { "<cmd>let @+=expand('%:t')..':'..line('.')<CR>", "current buffer name" },
			a = { "<cmd>let @+=expand('%:p')..':'..line('.')<CR>", "current buffer absolute path" },
			r = { "<cmd>let @+=expand('%:.')..':'..line('.')<CR>", "current buffer relative path" },
			y = { '"+y', "copy to system clipboard" },
			p = { '"+p', "paste from system clipboard" },
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
		["<C-Space>"] = { ":bufdo w! | :q!<cr>", "save all buffers and quit" },
		["<C-q>"] = { ":qa!<cr>", "quit without saving" },
		["<C-e>"] = { ":e<cr>", "reload file" },
	},
})

local map = vim.keymap

-- DIRECT mappings (can/must NOT be triggered with the LEADER key)
map.set("n", "<CR>", ":nohlsearch<cr>", { desc = "clean current highlighted search" })
map.set("v", "<", "<gv", { desc = "dedent" })
map.set("v", ">", ">gv", { desc = "indent" })
map.set("n", "<Backspace>", "<C-w>c<Enter>", { desc = "close window & keep buffer" })

map.set("n", "<Up>", "<Nop>", { desc = "disable Up in normal mode" })
map.set("n", "<Down>", "<Nop>", { desc = "disable Down in normal mode" })
map.set("n", "<Left>", "<Nop>", { desc = "disable Left in normal mode" })
map.set("n", "<Right>", "<Nop>", { desc = "disable Right in normal mode" })

-- DYNAMIC (programatic) MAPPINGS
--   references: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f#file-mappings-lua
--
-- Easier window switching with leader + Number
-- Creates mappings like this: km.set("n", "<Leader>2", "2<C-W>w", { desc = "Move to Window 2" })
for i = 1, 6 do
	local lhs = "<Leader>" .. i
	local rhs = i .. "<C-W>w"
	map.set("n", lhs, rhs, { desc = "Go to Window " .. i })
end
