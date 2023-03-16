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
		a = {
			name = "+launchers", -- telescope, harpoon, buffer_manager and others
		},
		b = {
			name = "+clipboard",
			n = { "<cmd>let @+=expand('%:t')..':'..line('.')<cr>", "current buffer name" },
			a = { "<cmd>let @+=expand('%:p')..':'..line('.')<cr>", "current buffer absolute path" },
			r = { "<cmd>let @+=expand('%:.')..':'..line('.')<cr>", "current buffer relative path" },
			y = { '"+y', "copy to system clipboard" },
			p = { '"+p', "paste from system clipboard" },
		},
		c = {
			name = "+coding",
		},
		e = {
			name = "+etc",
		},
		f = {
			name = "+files, buffers, tabs & windows",
			b = {
				name = "+buffers",
				k = { ":bw<Enter>", "close" },
				K = { ":bp<bar>sp<bar>bn<bar>bd<cr>", "close & keep window" },
				w = { ":bufdo w!<cr>", "save all" },
			},
			o = { ":!gedit %<cr>", "open current file on gedit" },
			f = { ":Telescope find_files find_command=fd,-H,-E,.git prompt_prefix=fd:  <cr>", "telescope open files" },
			t = {
				name = "+tabs",
				n = { ":tabnew<cr>", "new" },
				c = { ":tabclose<cr>", "close" },
			},
			w = {
				name = "+windows",
				j = { "<c-w>J", "move down" },
				k = { "<c-w>K", "move up" },
				h = { "<c-w>H", "move left" },
				l = { "<c-w>L", "move right" },
				r = { "<c-w>r", "rotate split window" },
				x = { "<c-w>t<c-w>K", "become horizontal split" },
				v = { "<c-w>t<c-w>H", "become vertical split" },
				X = { ":new", "empty buffer on new horizontal split" },
				V = { ":vnew", "empty buffer on new vertical split" },
			},
		},
		g = {
			name = "+grep",
		},
		h = {
			name = "+harpoon",
		},
		l = {
			name = "+lazy",
		},
		m = {
			name = "+messages & notifications",
		},
		n = {
			name = "+navigation (marks, lists etc)",
			m = {
				name = "+marks",
				d = { ":delmarks!<cr>", "delete all" },
			},
		},
		o = {
			name = "+formatting",
		},
		p = {
			name = "+python",
		},
		q = {
			name = "+quickfix",
		},
		r = { ":redo<cr>", "redo changes" },
		s = { ":w!<cr>", "save current buffer" },
		S = {
			name = "+session",
		},
		t = {
			name = "+tree",
		},
		T = {
			name = "+toggle",
			c = { ":set list!<cr>", "special chars (listchars)" },
			n = { ":set rnu!<cr>", "relative line numbers" },
			i = { ":set cuc!<cr>", "current column indentation" },
			l = { ":set cursorline!<cr>", "current line" },
		},
		u = { ":undo<cr>", "undo changes" },
		w = {
			name = "+writing",
			s = {
				name = "+spell",
				t = { ":set spell!<cr>", "toggle" },
				o = { ":set spell?<cr>", "show status" },
				l = { ":set spelllang?<cr>", "show current language" },
				b = { ":set spelllang=en,pt_br<cr>", "set to EN & PT_BR" },
				e = { ":set spelllang=en<cr>", "set to EN" },
				p = { ":set spelllang=pt_br<cr>", "set to PT_BR" },
				a = { ":normal! mz[s1z=`z]<cr>", "fix last misspelled word & jump back to where you were" },
			},
		},
		x = {
			name = "+external commands",
		},
		["<C-Space>"] = { ":bufdo w! | :q!<cr>", "save all buffers and quit" },
		["<C-q>"] = { ":qa!<cr>", "quit without saving" },
		["<C-e>"] = { ":e<cr>", "reload file" },
	},
})

-- --
-- DIRECT mappings (can/must NOT be triggered with the LEADER key)
local map = vim.keymap

map.set("n", "<cr>", ":nohlsearch<cr>", { desc = "clean current highlighted search" })
map.set("v", "<", "<gv", { desc = "dedent" })
map.set("v", ">", ">gv", { desc = "indent" })
map.set("n", "<Del>", "<C-w>c<Enter>", { desc = "close window & keep buffer" })

map.set("n", "<Up>", "<Nop>", { desc = "disable Up in normal mode" })
map.set("n", "<Down>", "<Nop>", { desc = "disable Down in normal mode" })
map.set("n", "<Left>", "<Nop>", { desc = "disable Left in normal mode" })
map.set("n", "<Right>", "<Nop>", { desc = "disable Right in normal mode" })

map.set("n", "<C-j>", ":m .+1<cr>==", { desc = "move current line/selection down" })
map.set("n", "<C-k>", ":m .-2<cr>==", { desc = "move current line/selection up" })

map.set("n", "<C-right>", ":tabnext<cr>", { desc = "go to next tab" })
map.set("n", "<C-left>", ":tabprevious<cr>", { desc = "go to previous tab" })
map.set("i", "<C-right>", "<Esc>:tabnext<cr>", { desc = "go to next tab" })
map.set("i", "<C-left>", "<Esc>:tabprevious<cr>", { desc = "go to previous tab" })

-- Keep the cursor in place when you join lines with J. That will also drop a mark before the operation to which you return afterwards:
map.set("n", "J", "mzJ`z", { desc = "join lines keeping cursor in place" })

map.set("n", "<C-g>", ":Telescope live_grep<cr>", { desc = "telescope search string on current path" })
map.set(
	"n",
	"<leader>*",
	":Telescope grep_string<cr>",
	{ desc = "telescope search word/string under cursor on current path" }
)
map.set(
	"n",
	"<C-down>",
	':lua require"tiagoprn.telescope_custom_pickers".switch_to_buffer()<cr>',
	{ desc = "telescope switch to open buffer" }
)
map.set("n", "<C-up>", ":Telescope buffers<cr>", { desc = "telescope open buffer on current window" })

-- --
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
