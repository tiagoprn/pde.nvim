" PLUGINS REMAPPPINGS - those that do depend on 3rd party installed plugins
"

" -- telescope
" nnoremap <leader>ta :Telescope builtin<cr>| " (telescope) all commands
" nnoremap <leader>tm :Telescope marks<cr>| " (telescope) browse marks
" nnoremap <leader>tn :Telescope aerial<cr>| " ( telescope) (lsp) F4 code navigation through classes, methods and functions
" nnoremap <leader>th :Telescope command_history<cr>| " (telescope) command history (q:)
" nnoremap <leader>tr :Telescope registers<cr>| " (telescope) browse registers
" nnoremap <leader>tq :Telescope quickfix<cr>| " (telescope) browse quickfix
" nnoremap <leader>ti :Telescope quickfixhistory<cr>| " (telescope) browse quickfix history
" nnoremap <leader>tl :Telescope loclist<cr>| " (telescope) browse location-list
" nnoremap <leader>tt :Telescope help_tags<cr>| " (telescope) tags
" nnoremap <leader>tc :Telescope colorscheme<cr>| " (telescope) browser color schemes
" nnoremap <leader>Mk :Telescope make<cr>| " (telescope) run Makefile command
" nnoremap <leader>lr :lua require'telescope.builtin'.lsp_references{}<CR>| "( lsp) (telescope) search over variable references from your LSP


" LSP config (the mappings used in the default file don't quite work right)
" nnoremap <silent> <leader>ld <cmd>lua vim.lsp.buf.definition()<CR>| " ( lsp) go to definition
" nnoremap <silent> <leader>ldf <cmd>lua require('goto-preview').goto_preview_definition()<CR>| " (lsp) go to definition - floating window
" nnoremap <silent> <leader>ldq <cmd>lua require('goto-preview').close_all_win()<CR>| " (lsp) go to definition - close all floating windows
" nnoremap <silent> <leader>ldv <cmd>lua require"telescope.builtin".lsp_definitions({jump_type="vsplit"})<CR>| " (lsp) go to definition - vertical window (right)
" nnoremap <silent> <leader>ldx <cmd>lua require"telescope.builtin".lsp_definitions({jump_type="split"})<CR>| " (lsp) go to definition - horizontal window (bottom)
" nnoremap <silent> <leader>ldt <cmd>lua require"telescope.builtin".lsp_definitions({jump_type="tab"})<CR>| " (lsp) go to definition - Opens window on a new tab
" nnoremap <silent> <leader>le <cmd>lua vim.lsp.buf.declaration()<CR>| " (lsp) go to declaration
" nnoremap <silent> <leader>li <cmd>lua vim.lsp.buf.implementation()<CR>| " (lsp) go to implementation
" nnoremap <silent> <leader>lt <cmd>lua vim.lsp.buf.format(nil,1200)<CR>| " (lsp) format file (e.g. isort, black) with null-ls
" nnoremap <silent> <leader>lo :LspInfo <CR>| " (lsp) Show Info
" nnoremap <silent> <leader>loo :NullLsInfo <CR>| " (lsp) Show NullLs Info
" nnoremap <silent> <leader>lq <cmd>lua vim.diagnostic.setqflist()<CR>| " ( lsp) linter/diagnostics quickfix list
" nnoremap <silent> <leader>lh :Lspsaga hover_doc<CR>| " (lsp-saga) documentation hover
" nnoremap <silent> <leader>lf :Lspsaga lsp_finder<CR>| " (lsp-sage) finder
" nnoremap <silent> <leader>la :Lspsaga code_action<CR>| " (lsp-saga) code action
" vnoremap <silent> <leader>lar :<C-U>Lspsaga range_code_action<CR>| " (lsp-saga) code action

" harpoon
" nnoremap <silent> <C-h> <cmd>lua require("harpoon.ui").toggle_quick_menu()<cr>| " (navigation - harpoon) quick menu
" nnoremap <silent> <leader>ha <cmd>lua require("harpoon.mark").add_file()<cr>| " (navigation - harpoon) add current file
" nnoremap <silent> <leader>h1 <cmd>lua require("harpoon.ui").nav_file(1)<cr>| " (navigation - harpoon) go to file 1
" nnoremap <silent> <leader>h2 <cmd>lua require("harpoon.ui").nav_file(2)<cr>| " (navigation - harpoon) go to file 2
" nnoremap <silent> <leader>h3 <cmd>lua require("harpoon.ui").nav_file(3)<cr>| " (navigation - harpoon) go to file 3
" nnoremap <silent> <leader>h4 <cmd>lua require("harpoon.ui").nav_file(4)<cr>| " (navigation - harpoon) go to file 4
" nnoremap <silent> <leader>h5 <cmd>lua require("harpoon.ui").nav_file(5)<cr>| " (navigation - harpoon) go to file 5
" nnoremap <silent> <leader>h6 <cmd>lua require("harpoon.ui").nav_file(6)<cr>| " (navigation - harpoon) go to file 6
" nnoremap <silent> <leader>h7 <cmd>lua require("harpoon.ui").nav_file(7)<cr>| " (navigation - harpoon) go to file 7
" nnoremap <silent> <leader>h8 <cmd>lua require("harpoon.ui").nav_file(8)<cr>| " (navigation - harpoon) go to file 8
" nnoremap <silent> <leader>h9 <cmd>lua require("harpoon.ui").nav_file(9)<cr>| " (navigation - harpoon) go to file 9
" nnoremap <silent> <leader>hn <cmd>lua require("harpoon.ui").nav_next()<cr>| " (navigation - harpoon) go to next file on the list
" nnoremap <silent> <leader>hp <cmd>lua require("harpoon.ui").nav_prev()<cr>| " (navigation - harpoon) go to previous file on the list
" nnoremap <silent> <leader>ht <cmd>lua require("harpoon.tmux").gotoTerminal("{down-of}")<cr>| " (navigation - harpoon) go to tmux pane below
" nnoremap <silent> <leader>hc <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", vim.fn.input("Enter the command: "))<cr>| " (navigation - harpoon) run command on tmux pane below
" nnoremap <silent> <leader>hm :Easypick make<cr>| " (navigation - harpoon) run make command from easypick select on tmux pane below
" nnoremap <silent> <leader>hc1 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 1)<cr>| " (navigation - harpoon) run project command 1 on tmux pane below
" nnoremap <silent> <leader>hc2 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 2)<cr>| " (navigation - harpoon) run project command 2 on tmux pane below
" nnoremap <silent> <leader>hc3 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 3)<cr>| " (navigation - harpoon) run project command 3 on tmux pane below
" nnoremap <silent> <leader>hc4 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 4)<cr>| " (navigation - harpoon) run project command 4 on tmux pane below
" nnoremap <silent> <leader>hc5 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 5)<cr>| " (navigation - harpoon) run project command 5 on tmux pane below
" nnoremap <silent> <leader>hc6 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 6)<cr>| " (navigation - harpoon) run project command 6 on tmux pane below
" nnoremap <silent> <leader>hc7 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 7)<cr>| " (navigation - harpoon) run project command 7 on tmux pane below
" nnoremap <silent> <leader>hc8 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 8)<cr>| " (navigation - harpoon) run project command 8 on tmux pane below
" nnoremap <silent> <leader>hc9 <cmd>lua require("harpoon.tmux").sendCommand("{down-of}", 9)<cr>| " (navigation - harpoon) run project command 9 on tmux pane below
" nnoremap <silent> <leader>hz <cmd>lua require("harpoon.tmux").gotoTerminal("{end}")<cr>| " (navigation - harpoon) go to last tmux numbered window

" zen-mode
" nnoremap <C-z> :ZenCode<CR>| " (zen) toggle current buffer full screen
" nnoremap <leader>zz :ZenWrite<CR>| " (zen) toggle current buffer full screen - distraction free mode for writing

" tmux
" nnoremap <leader>g :!tmux select-window -t git<CR>| " (tmux) go to gitui tmux window


" nvim-tree (a project directory tree)
" nnoremap <F3> :NvimTreeToggle<CR>| " (function-keys) toggle project directory tree


" svart
" nnoremap <silent> <leader>l <cmd>Svart<cr>| " (movement) svart - 'hop' go to position
" nnoremap <silent> <leader>lvs <cmd>SvartRepeat<CR>| " (movement) svart - 'hop' go to position - last searched query
" nnoremap <silent> <leader>lvp <cmd>SvartRegex<CR>| " (movement) svart - 'hop' go to position


" snippy
" inoremap <silent> <c-s> <cmd>lua require'snippy'.complete()<CR>| " (INSERT) show all available snippets for current filetype


" aerial code navigation
" nnoremap <silent> <F4> :AerialToggle<CR>| " (lsp)(function-keys) toggle code navigation through classes and methods
" nnoremap <silent> <leader>; :AerialNext<CR>| " (aerial F4 code navigation) go to next function / method
" nnoremap <silent> <leader>, :AerialPrev<CR>| " (aerial F4 code navigation) go to previous function/method
" nnoremap <silent> <leader>: :lua require'aerial'.next_up()<CR>| " (aerial F4 code navigation) go to next class
" nnoremap <silent> <leader>< :lua require'aerial'.prev_up()<CR>| " (aerial F4 code navigation) go to previous class


" " session manager
" nnoremap <silent> <leader>ss :SessionManager save_current_session<CR>| " (sessions) save current session
" nnoremap <silent> <leader>sl :SessionManager load_session<CR>| " (sessions) load session
" nnoremap <silent> <leader>sd :SessionManager delete_session<CR>| "  (sessions) delete session


" " gitsigns
" nnoremap <silent> <leader>gb :Gitsigns blame_line<CR>| " (gitsigns) blame line
" nnoremap <silent> <leader>gj :Gitsigns next_hunk<CR>| "  (gitsigns) go to next changed hunk
" nnoremap <silent> <leader>gk :Gitsigns prev_hunk<CR>| "  (gitsigns) go to next changed hunk
" nnoremap <silent> <leader>gp :Gitsigns preview_hunk<CR>| "  (gitsigns) preview hunk

" buffer_manager
" nnoremap <silent> <Tab> <cmd>lua require("buffer_manager.ui").nav_next()<CR>| " (buffer_manager) switch to next buffer
" nnoremap <silent> <S-Tab> <cmd>lua require("buffer_manager.ui").nav_prev()<CR>| " (buffer_manager) switch to previous buffer
" nnoremap <silent> <C-b> <cmd>lua require("buffer_manager.ui").toggle_quick_menu()<CR>| " (buffer_manager) open quick menu
" nnoremap <silent> <leader>bl <cmd>lua require("buffer_manager.ui").load_menu_from_file()<CR>| " (buffer_manager) load buffers from file
" nnoremap <silent> <leader>bw <cmd>lua require("buffer_manager.ui").save_menu_to_file()<CR>| " (buffer_manager) save buffers to file

" mind
" nnoremap <silent> <leader>mo :MindOpenMain<CR>| " (mind ) open index menu
" nnoremap <silent> <leader>mO :MindOpenSmartProject<CR>| " (mind ) open index menu (smart project)
" nnoremap <silent> <leader>mq :MindClose<CR>| " (mind ) close index menu

" treesitter
" nnoremap <silent> <leader>i :TSNodeUnderCursor<CR>| " (treesitter) get current node information
" nnoremap <silent> <leader>it :TSPlaygroundToggle<CR>| " (treesitter) toggle playground
