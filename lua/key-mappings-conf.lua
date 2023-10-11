-- This has all my custom keymappings, configured using which-key

local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
	return
end

-- --
-- 1) WHICH-KEY mappings (can/must be triggered with the LEADER key)
-- --
which_key.setup({
	window = {
		border = "single", -- none, single, double, shadow
	},
	layout = {
		height = { min = 4, max = 25 }, -- min and max height of the columns
		width = { min = 20, max = 80 }, -- min and max width of the columns
		spacing = 3, -- spacing between columns
		align = "center", -- align columns left, center or right
	},
})

-- which_key.register({
-- 	-- VISUAL mode mappings
-- 	["y"] = { '"+y', "Yank to system clipboard" },
-- 	{
-- 		mode = "v", -- Register visual mode mappings
-- 		prefix = "<leader>",
-- 		buffer = nil,
-- 		silent = true,
-- 		noremap = true,
-- 		nowait = false,
-- 	},
-- })

which_key.register({
	-- NORMAL mode mappings
	["<leader>"] = {
		-- v = {
		-- 	name = "+sample LEADER group",
		-- 	f = { "<cmd>Telescope find_files<cr>", "LEADER Find File" },
		-- 	r = { "<cmd>Telescope oldfiles<cr>", "LEADER Open Recent File" },
		-- 	n = { "<cmd>enew<cr>", "LEADER New File" },
		-- },
		--
		a = {
			name = "+automations",
			i = {
				name = "+AI",
				o = { ":FlyboyOpen<cr>", "(flyboy) new markdown chat - CURRENT WINDOW" },
				s = { ":FlyboyOpenSplit<cr>", "(flyboy) new markdown chat - HORIZONTAL SPLIT" },
				v = { ":FlyboyOpenVSplit<cr>", "(flyboy) new markdown chat - VERTICAL SPLIT" },
				a = { ":FlyboySendMessage<cr>", "(flyboy) markdown chat - submit last user message to ChatGPT" },
				c = { "<cmd>ChatGPT<CR>", "(chatgpt) New Prompt" },
				-- you can add custom prompts for ChatGPTActAs like explained at <https://youtu.be/7k0KZsheLP4?t=678>
				d = { "<cmd>ChatGPTActAs<CR>", "(chatgpt) Pre-defined prompt (e.g. Fullstack Software Developer)" },
				m = {
					"<cmd>ChatGPTCompleteCode<CR>",
					"(chatgpt) useful inside an empty function with the name and type hints",
				},
				e = { "<cmd>ChatGPTEditWithInstruction<CR>", "(chatgpt) edit with instruction", mode = { "n", "v" } },
				g = { "<cmd>ChatGPTRun grammar_correction<CR>", "(chatgpt) grammar Correction", mode = { "n", "v" } },
				t = { "<cmd>ChatGPTRun translate<CR>", "(chatgpt) translate", mode = { "n", "v" } },
				k = { "<cmd>ChatGPTRun keywords<CR>", "(chatgpt) keywords", mode = { "n", "v" } },
				p = { "<cmd>ChatGPTRun add_tests<CR>", "(chatgpt) add tests", mode = { "n", "v" } },
				b = { "<cmd>ChatGPTRun optimize_code<CR>", "(chatgpt) optimize Code", mode = { "n", "v" } },
				u = { "<cmd>ChatGPTRun summarize<CR>", "(chatgpt) summarize", mode = { "n", "v" } },
				f = { "<cmd>ChatGPTRun fix_bugs<CR>", "(chatgpt) fix Bugs", mode = { "n", "v" } },
				x = { "<cmd>ChatGPTRun explain_code<CR>", "(chatgpt) explain Code", mode = { "n", "v" } },
				r = { "<cmd>ChatGPTRun roxygen_edit<CR>", "(chatgpt) roxygen Edit", mode = { "n", "v" } },
				l = {
					"<cmd>ChatGPTRun code_readability_analysis<CR>",
					"(chatgpt) code readability analysis",
					mode = { "n", "v" },
				},
			},
			l = { ":PrintLspSupportedRequests<cr>", "print all supported requests on the current LSP server" },
			t = {
				name = "+tmux",
				i = {
					":RunInteractiveCommandOnCurrentFunctionOrMethodAtTmuxScratchpadSession<cr>",
					"run interactive command on current function or method at tmux scratchpad session",
				},
				l = {
					":RerunLastCommandOnTmuxScratchpadSession<cr>",
					"rerun last bash command on tmux scratchpad session",
				},
				p = {
					":RunPytestOnCurrentFunctionOrMethodAtTmuxScratchpadSession<cr>",
					"run pytest on current function or method at tmux scratchpad session",
				},
				r = { ":RunCommandOnTmuxScratchpadSession<cr>", "run bash command on tmux scratchpad session" },
			},
		},
		b = {
			name = "+clipboard",
			a = { "<cmd>let @+=expand('%:p')..':'..line('.')<cr>", "current buffer absolute path" },
			e = { ":Telescope registers<cr>", "telescope browse registers" },
			g = {
				":let @+=system(\"git symbolic-ref --short HEAD 2>/dev/null | tr -d '\\n'\")<cr>",
				"copy current git branch name to clipboard",
			},
			l = { ":let @+=line('.')<cr>", "current line number" },
			n = { "<cmd>let @+=expand('%:t')..':'..line('.')<cr>", "current buffer name" },
			p = { '"+p', "paste from system clipboard" },
			r = { "<cmd>let @+=expand('%:.')..':'..line('.')<cr>", "current buffer relative path" },
			-- s = {
			-- 	":lua vim.lsp.buf.execute_command({command = 'copyReference', arguments = {vim.api.nvim_buf_get_lines(0, vim.fn.line('.')-1, vim.fn.line('.'), false)[1], vim.fn.expand('%:p')}})<cr>",
			-- 	"copy class/method/function under cursor reference",
			-- },
			A = {
				":GetCurrentFilenamePositionAndCopyToClipboard<cr>",
				"treesitter - copy current file/buffer name with position to clipboard",
			},
			N = {
				":GetCurrentFileAbsolutePositionAndCopyToClipboard<cr>",
				"treesitter - copy current file/buffer full/absolute path with position to clipboard",
			},
			R = {
				":GetCurrentFileRelativePositionAndCopyToClipboard<cr>",
				"treesitter - copy current file/buffer relative path with position to clipboard",
			},
		},
		c = {
			name = "+coding",
			A = { ":Lspsaga code_action<cr>", "code action" },
			a = {
				":Telescope lsp_workspace_symbols<cr>",
				"telescope project navigation through symbols (classes, functions etc)",
			},
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
			g = {
				":GeneratePythonProjectDefinitionsFile<cr>",
				"Python Project Search: create/update python project definitions.txt file",
			},
			h = { ":Lspsaga hover_doc<cr>", "documentation hover" },
			i = { "<cmd>lua vim.lsp.buf.implementation()<cr>", "go to implementation" },
			l = { ":LspInfo <cr>", "LSP info" },
			m = { ":Telescope make<cr>", "telescope run Makefile command" },
			-- n = { ":Telescope aerial<cr>", "telescope navigation through classes, methods and functions" },
			n = {
				":Telescope lsp_document_symbols<cr>",
				"telescope buffer navigation through symbols (classes, functions etc)",
			},
			o = { ":Telescope import<cr>", "search for import on project and add to the top imports on this module" },
			q = { "<cmd>lua vim.diagnostic.setqflist()<cr>", "send linter/diagnostics to quickfix list" },
			-- r = { ":Lspsaga lsp_finder<cr>", "finder" },
			r = {
				":Telescope lsp_references<cr>",
				"telescope search references to the current word (class, function, variable, etc)",
			},
			s = {
				":PythonProjectSearch<cr>",
				"Python Project Search: search and open a python class, method or function",
			},
			t = {
				name = "+treesitter",
				n = { ":TSNodeUnderCursor<cr>", "current node info" },
				p = { ":TSPlaygroundToggle<cr>", "toggle playground" },
			},
			u = { ":NullLsInfo <cr>", "null-ls info" },
			-- y = { "<cmd>lua vim.lsp.inlay_hint(0, nil)<cr>", "inlay hints toggle" },
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
				n = { ":LoadBufferWithoutWindow <cr>", "open file without opening a window" },
				o = { ":Telescope buffers<cr>", "telescope menu of all open buffers" },
			},
			o = { ":!gedit %<cr>", "open current file on gedit" },
			f = { ":Telescope find_files find_command=fd,-H,-E,.git prompt_prefix=fd:  <cr>", "telescope open files" },
			r = { ":Easypick recent_files_on_current_folder<cr>", "telescope open files changed recently (<=14 days) " },
			s = { ":SearchOnOpenFiles<cr>", "search on open files" },
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
			b = { ":Gitsigns blame_line<cr>", "blame line" },
			j = { ":Gitsigns next_hunk<cr>", "go to next changed hunk" },
			k = { ":Gitsigns prev_hunk<cr>", "go to previous changed hunk" },
			p = { ":Gitsigns preview_hunk<cr>", "preview hunk" },
		},
		h = {
			name = "+harpoon",
			a = { '<cmd>lua require("harpoon.mark").add_file()<cr>', "add current file" },
			b = { ":Telescope harpoon marks<cr>", "telescope marks browsing" },
			h = { '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', "toggle quick menu" },
			n = { '<cmd>lua require("harpoon.ui").nav_next()<cr>', "next file on list" },
			p = { '<cmd>lua require("harpoon.ui").nav_prev()<cr>', "previous file on list" },
			-- t = { '<cmd>lua require("harpoon.tmux").gotoTerminal("{down-of}")<cr>', "go to tmux pane below" },
			c = {
				'<cmd>lua require("harpoon.tmux").sendCommand("{down-of}", vim.fn.input("Enter the command: "))<cr>',
				"run command on tmux pane below",
			},
			m = { ":Easypick make<cr>", "run easypick select make command on tmux pane below" },
		},
		l = {
			name = "+launchers", -- telescope, AI, lazy and others
			t = {
				name = "+telescope",
				a = { ":Telescope builtin<cr>", "all commands" },
			},
		},
		m = {
			name = "+messages & notifications",
			r = {
				':lua require("tiagoprn.toggle_redir").toggle()<cr>',
				"toggle redirecting messages to file - NOT real time (toggle OFF to stop and see the contents)",
			},
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
				-- TODO: remove or add leap/flit
			},
			l = {
				name = "+location list",
				b = { ":Telescope loclist<cr>", "telescope browse" },
			},
			m = {
				name = "+marks",
				d = { ":delmarks!<cr>", "delete all" },
				b = { ":Telescope marks<cr>", "telescope browse" },
				x = { ":call MarkDelete()<cr>", "delete single" }, -- defined in functions.vim
			},
		},
		o = {
			name = "+formatting",
		},
		P = {
			name = "+python",
			e = {
				":EmbedValueFromPythonPrintableExpression<cr>",
				"type printable / evaluable python expression to embed in current buffer",
			},
			r = { ":RunPythonScriptOnCurrentLine<cr>", "run python script on current line" },
		},
		p = {
			name = "Plugins (packer)",
			s = { ":PackerSync<cr>", "Update all plugins" },
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
			name = "+TODO list",
			i = { ":require('todo-comments').jump_next()<cr>", "next" },
			o = { ":require('todo-comments').jump_prev()<cr>", "prev" },
			t = { ":TodoTelescope keywords=TODO<cr>", "telescope browse TODOs" },
			f = { ":TodoTelescope keywords=FIXME<cr>", "telescope browse FIXMEs" },
			n = { ":TodoTelescope keywords=NOTE<cr>", "telescope browse NOTEs" },
			q = { ":TodoQuickFix<cr>", "quickfix list" },
			l = { ":TodoLocList<cr>", "location list" },
			-- n = {"", ""},
		},
		u = { ":undo<cr>", "undo changes" },
		w = {
			name = "+writing",
			f = {
				name = "+fleeting notes",
				c = { ":CreateFleetingNote<cr>", "create" },
				s = { ":SearchFleetingNotes<cr>", "search" },
				l = { ":ListFleetingNotesCategories<cr>", "list categories" },
				u = { ":UpdateFleetingNotesCategories<cr>", "update categories" },
			},
			m = {
				name = "+Mind",
				i = { ":MindOpenMain<cr>", "open main index menu" },
				I = { ":MindOpenSmartProject<cr>", "open smart project index menu" },
				q = { ":MindClose<cr>", "close index menu" },
				c = {
					":MindCustomCreateNodeIndexOnMainTree<cr>",
					"tree - create node inside another without leaving current buffer",
				},
				y = { ":MindCustomCopyNodeLinkIndexOnMainTree<cr>", "tree - search a node and copy its' link" },
				o = { ":MindCustomOpenDataIndexOnMainProjectTree<cr>", "tree - search node and open it" },
				S = { ":MindCustomInitializeSmartProjectTree<cr>", "smart project - initialize" },
				Y = {
					":MindCustomCopyNodeLinkIndexOnSmartProjectTree<cr>",
					"smart project - search a node and copy its' link",
				},
				O = { ":MindCustomOpenDataIndexOnSmartProjectTree<cr>", "smart project - search node and open it" },
			},
			n = { ":OpenPersonalDoc<cr>", "open note" },
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
			t = {
				name = "+Tasks",
				c = { ":CreateTask<cr>", "create" },
				s = { ":SearchTaskCard<cr>", "search" },
			},
			w = {
				name = "+writeloop",
				s = {
					":SearchWriteloop<cr>",
					"search (INBOX, PERSONAL, zettels, posts, flashcards, mind-maps, etc...)",
				},
				p = { ":CreatePost<cr>", "create post" },
				z = { ":CreateZettel<cr>", "create zettel" },
				f = { ":CreateFlashcard<cr>", "create flashcard" },
			},
		},
		x = {
			name = "+toggle",
			c = { ":set list!<cr>", "special chars (listchars)" },
			n = { ":set rnu!<cr>", "relative line numbers" },
			i = { ":set cuc!<cr>", "current column indentation" },
			l = { ":set cursorline!<cr>", "current line" },
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

--> NORMAL mode
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

map.set(
	"n",
	"<C-g>o",
	":Telescope live_grep<cr>",
	{ desc = "telescope search string on current path - current window" }
)
map.set(
	"n",
	"<C-g>t",
	":tabnew | Telescope live_grep<cr>",
	{ desc = "telescope search string on current path - new tab" }
)
map.set(
	"n",
	"<C-g>s",
	":split | Telescope live_grep<cr>",
	{ desc = "telescope search string on current path - horizontal split" }
)
map.set(
	"n",
	"<C-g>v",
	":vsplit | Telescope live_grep<cr>",
	{ desc = "telescope search string on current path - vertical split" }
)
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

-- map.set("n", "<C-h>", '<cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>', { desc = "harpoon quick menu" })

map.set("n", "<PageDown>", ":Gitsigns next_hunk<cr>", { desc = "gitsigns go to next hunk" })
map.set("n", "<PageUp>", ":Gitsigns prev_hunk<cr>", { desc = "gitsigns go to previous hunk" })
map.set("n", "<Home>", ":Gitsigns blame_line<cr>", { desc = "gitsigns blame line" })
map.set("n", "<End>", ":Gitsigns preview_hunk<cr>", { desc = "gitsigns preview hunk" })

map.set("n", "<leader>]", ":cn<cr>", { desc = "quickfix next item" })
map.set("n", "<leader>[", ":cp<cr>", { desc = "quickfix previous item" })

-- FUNCTION KEYS
map.set("n", "<F3>", ":NvimTreeToggle<cr>", { desc = "nvim tree (project directory)" })
map.set("n", "<F4>", ":AerialToggle<cr>", { desc = "aerial classes and methods tree" })

--> VISUAL mode
map.set("v", "<", "<gv", { desc = "dedent" })
map.set("v", ">", ">gv", { desc = "indent" })
map.set("v", "<leader>f", ":call MoveVisualSelectionToFile()<cr>", {
	desc = "save visual selection to file",
}) -- defined in functions.vim
map.set("v", "<leader>A", ":<C-U>Lspsaga range_code_action<cr>", { desc = "code action" })
map.set("v", "<leader>y", '"+y', { desc = "YANK/COPY to system clipboard" })
map.set(
	"v",
	"<leader>c",
	":FlyboyStartSplit visual<cr>",
	{ desc = "AI - open blank markdown buffer to interact with ChatGPT" }
)
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
	map.set("n", lhs, rhs, { desc = "harpoon go to file mark " .. i })
end
-- Run project command
for i = 1, 9 do
	local lhs = "<Leader>hc" .. i
	local rhs = '<cmd>lua require("harpoon.tmux").sendCommand("{down-of}", ' .. 1 .. ")<cr>"
	map.set("n", lhs, rhs, { desc = "harpoon run project command" .. i .. "on tmux pane below" })
end
