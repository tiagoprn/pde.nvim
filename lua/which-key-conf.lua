-- This allows nvim to nfocus ot crash if this plugin is not installed.
-- It would be great to extend this to my other plugins configuration.
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

-- --
-- 1) WHICH-KEY mappings (can/must be triggered with the LEADER key)
-- --
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
			name = "+launchers", -- telescope, buffer_manager and others
			t = {
				name = "+telescope",
				a = { ":Telescope builtin<cr>", "all commands" },
			},
		},
		b = {
			name = "+clipboard",
			a = { "<cmd>let @+=expand('%:p')..':'..line('.')<cr>", "current buffer absolute path" },
			e = { ":Telescope registers<cr>", "telescope browse registers" },
			n = { "<cmd>let @+=expand('%:t')..':'..line('.')<cr>", "current buffer name" },
			p = { '"+p', "paste from system clipboard" },
			r = { "<cmd>let @+=expand('%:.')..':'..line('.')<cr>", "current buffer relative path" },
			y = { '"+y', "copy to system clipboard" },
		},
		c = {
			name = "+coding",
			a = { ":Lspsaga code_action<cr>", "code action" },
			d = {
				name = "+go to definition",
				f = { "<cmd>lua require('goto-preview').goto_preview_definition()<cr>", "LSP open on floating window" },
				o = { "<cmd>lua vim.lsp.buf.definition()<cr>", "LSP open on current window" },
				q = { "<cmd>lua require('goto-preview').close_all_win()<cr>", "LSP close all floating windows" },
				t = { '<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="tab"})<cr>', "LSP open on tab" },
				x = {
					'<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="split"})<cr>',
					"LSP open on horizontal window",
				},
				v = {
					'<cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<cr>',
					"LSP open on vertical window",
				},
			},
			e = { "<cmd>lua vim.lsp.buf.declaration()<cr>", "go to declaration" },
			f = { "<cmd>lua vim.lsp.buf.format(nil,1200)<cr>", "format file (null-ls)" },
			h = { ":Lspsaga hover_doc<cr>", "documentation hover" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "go to implementation" },
			l = { ":LspInfo <cr>", "LSP info" },
			m = { ":Telescope make<cr>", "telescope run Makefile command" },
			n = { ":Telescope aerial<cr>", "telescope navigation through classes, methods and functions" },
			q = { "<cmd>lua vim.diagnostic.setqflist()<cr>", "send linter/diagnostics to quickfix list" },
			r = { ":Lspsaga lsp_finder<cr>", "finder" },
			t = {
				name = "+treesitter",
				n = { ":TSNodeUnderCursor<cr>", "current node info" },
				p = { ":TSPlaygroundToggle<cr>", "toggle playground" },
			},
			u = { ":NullLsInfo <cr>", "null-ls info" },
		},
		e = {
			name = "+etc",
			c = { ":Telescope colorscheme<cr>", "telescope browse color schemes" },
			h = { ":Telescope help_tags<cr>", "telescope search tag on nvim help (builtins and plugins)" },
		},
		f = {
			name = "+files, buffers, tabs & windows",
			b = {
				name = "+buffers",
				k = { ":bw<Enter>", "close" },
				K = { ":bp<bar>sp<bar>bn<bar>bd<cr>", "close & keep window" },
				w = { ":bufdo w!<cr>", "save all" },
				m = { '<cmd>lua require("buffer_manager.ui").toggle_quick_menu()<cr>', "buffer_manager open menu" },
				l = {
					'<cmd>lua require("buffer_manager.ui").load_menu_from_file()<cr>',
					"buffer_manager load from file",
				},
				s = { '<cmd>lua require("buffer_manager.ui").save_menu_to_file()<cr>', "buffer_manager save to file" },
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
			name = "+git",
			t = { ":!tmux select-window -t git<cr>", "go to gitui tmux window" },
		},
		h = {
			name = "+harpoon",
			a = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "add current file" },
			n = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "next file on list" },
			p = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "previous file on list" },
			t = { '<cmd>lua require("harpoon.tmux").gotoTerminal("{down-of}")<cr>', "go to tmux pane below" },
			c = {
				'<cmd>lua require("harpoon.tmux").sendCommand("{down-of}", vim.fn.input("Enter the command: "))<cr>',
				"run command on tmux pane below",
			},
			m = { ":Easypick make<cr>", "run easypick select make command on tmux pane below" },
		},
		l = {
			name = "+lazy",
		},
		m = {
			name = "+messages & notifications",
			h = {
				name = "+history",
				n = { ":Telescope notify<cr>", "telescope notifications" },
			},
		},
		n = {
			name = "+navigation (code, hop, marks, lists etc)",
			f = { ":AerialNext<cr>", "aerial go to next function / method" },
			F = { ":AerialPrev<cr>", "aerial go to previous function/method" },
			c = { ":lua require'aerial'.next_up()<cr>", "aerial go to next class" },
			C = { ":lua require'aerial'.prev_up()<cr>", "aerial go to previous class" },
			h = {
				name = "+hop",
				s = { "<cmd>Svart<cr>", "search" },
				r = { "<cmd>SvartRepeat<cr>", "repeat last" },
				e = { "<cmd>SvartRegex<cr>", "regex" },
			},
			l = {
				name = "+location list",
				b = { ":Telescope loclist<cr>", "telescope browse" },
			},
			m = {
				name = "+marks",
				d = { ":delmarks!<cr>", "delete all" },
				b = { ":Telescope marks<cr>", "telescope browse" },
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
			b = { ":Telescope quickfix<cr>", "telescope browse" },
			e = { ":clast<cr>", "end" },
			h = { ":Telescope quickfixhistory<cr>", "telescope browse history" },
			l = { ":colder<cr>", "older" },
			n = { ":cnewer<cr>", "newer" },
			o = { ":copen<cr>", "open" },
			q = { ":cclose<cr>", "close" },
			s = { ":cfirst<cr>", "start" },
		},
		r = { ":redo<cr>", "redo changes" },
		s = { ":w!<cr>", "save current buffer" },
		S = {
			name = "+session",
			d = { ":SessionManager delete_session<cr>", "delete" },
			l = { ":SessionManager load_session<cr>", "load" },
			s = { ":SessionManager save_current_session<cr>", "save" },
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
			m = {
				name = "+Mind",
				i = { ":MindOpenMain<cr>", "open main index menu" },
				I = { ":MindOpenSmartProject<cr>", "open smart project index menu" },
				q = { ":MindClose<cr>", "close index menu" },
			},
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
		z = {
			name = "+zen focus mode",
			c = { ":ZenCode<cr>", "code full screen" },
			w = { ":ZenWrite<cr>", "write full screen" },
		},
		["<C-Space>"] = { ":bufdo w! | :q!<cr>", "save all buffers and quit" },
		["<C-q>"] = { ":qa!<cr>", "quit without saving" },
		["<C-e>"] = { ":e<cr>", "reload file" },
	},
})

-- --
-- 2) DIRECT mappings (can/must NOT be triggered with the LEADER key)
-- --
local map = vim.keymap

--> NORMAL mode (TODO: map these with which-key as I did SPECIAL leader mappings)
map.set("n", "<cr>", ":nohlsearch<cr>", { desc = "clean current highlighted search" })
map.set("n", "<Del>", "<C-w>c<Enter>", { desc = "close window & keep buffer" })

map.set("n", "<Up>", "<Nop>", { desc = "disable Up in normal mode" })
map.set("n", "<Down>", "<Nop>", { desc = "disable Down in normal mode" })
map.set("n", "<Left>", "<Nop>", { desc = "disable Left in normal mode" })
map.set("n", "<Right>", "<Nop>", { desc = "disable Right in normal mode" })

map.set("n", "<C-j>", ":m .+1<cr>==", { desc = "move current line/selection down" })
map.set("n", "<C-k>", ":m .-2<cr>==", { desc = "move current line/selection up" })

map.set("n", "<C-right>", ":tabnext<cr>", { desc = "go to next tab" })
map.set("n", "<C-left>", ":tabprevious<cr>", { desc = "go to previous tab" })

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

map.set("n", "<C-h>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', { desc = "harpoon quick menu" })

map.set("n", "<PageDown>", ":Gitsigns next_hunk<cr>", { desc = "gitsigns go to next hunk" })
map.set("n", "<PageUp>", ":Gitsigns prev_hunk<cr>", { desc = "gitsigns go to previous hunk" })
map.set("n", "<Home>", ":Gitsigns blame_line<cr>", { desc = "gitsigns blame line" })
map.set("n", "<End>", ":Gitsigns preview_hunk<cr>", { desc = "gitsigns preview hunk" })

map.set("n", "<leader>]<cr>", ":cn", { desc = "quickfix next item" })
map.set("n", "<leader>[<cr>", ":cp", { desc = "quickfix previous item" })

-- FUNCTION KEYS
map.set("n", "<F3>", ":NvimTreeToggle<cr>", { desc = "nvim tree (project directory)" })
map.set("n", "<F4>", ":AerialToggle<cr>", { desc = "aerial classes and methods tree" })

--> VISUAL mode
map.set("v", "<", "<gv", { desc = "dedent" })
map.set("v", ">", ">gv", { desc = "indent" })

map.set("v", "<leader>cA", ":<C-U>Lspsaga range_code_action<cr>", { desc = "code action" })

--> INSERT mode
map.set("i", "<C-right>", "<Esc>:tabnext<cr>", { desc = "go to next tab" })
map.set("i", "<C-left>", "<Esc>:tabprevious<cr>", { desc = "go to previous tab" })
map.set(
	"i",
	"<C-s>",
	"<cmd>lua require'snippy'.complete()<cr>",
	{ desc = "show all available snippets for current filetype" }
)

-- --
-- 3) DYNAMIC (programatic) MAPPINGS
--   references: https://gist.github.com/benfrain/97f2b91087121b2d4ba0dcc4202d252f#file-mappings-lua
-- --
-- Easier window switching with leader + Number
-- Creates mappings like this: km.set("n", "<Leader>2", "2<C-W>w", { desc = "Move to Window 2" })
for i = 1, 6 do
	local lhs = "<Leader>" .. i
	local rhs = i .. "<C-W>w"
	map.set("n", lhs, rhs, { desc = "Go to Window " .. i })
end
--
-- Harpoon
--   Go to file
for i = 1, 9 do
	local lhs = "<Leader>h" .. i
	local rhs = '<cmd>lua require("harpoon.ui").nav_file(' .. i .. ")<cr>"
	map.set("n", lhs, rhs, { desc = "harpoon go to file" .. i })
end
-- Run project command
for i = 1, 9 do
	local lhs = "<Leader>hc" .. i
	local rhs = '<cmd>lua require("harpoon.tmux").sendCommand("{down-of}", ' .. 1 .. ")<cr>"
	map.set("n", lhs, rhs, { desc = "harpoon run project command" .. i .. "on tmux pane below" })
end
