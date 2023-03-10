" CORE REMAPPPINGS - those that do not depend on any function, command or plugin

nnoremap <leader><Backspace> :bw<Enter>| " close buffer
nnoremap <Backspace> <C-w>c<Enter>| " close window but keep buffer
nnoremap <leader>k :bp<bar>sp<bar>bn<bar>bd<CR>| " close buffer but keep window

nnoremap <Leader>fcb <cmd>let @+=expand('%:t')..":"..line(".")<CR>| " copy current file/buffer name to clipboard
nnoremap <Leader>fcB <cmd>let @+=expand('%:p')..":"..line(".")<CR>| " copy current file/buffer full/absolute path name to clipboard
nnoremap <Leader>fcr <cmd>let @+=expand('%:.')..":"..line(".")<CR>| " copy current file/buffer relative path name to clipboard

noremap <Up> <Nop> | " disable Up key in normal mode
noremap <Down> <Nop> | " disable Down key in normal mode
noremap <Left> <Nop> | " disable Left key in normal mode
noremap <Right> <Nop> | " disable Right key in normal mode

noremap <Leader>y "+y | " copy to system clipboard
noremap <Leader>p "+p | " paste from system clipboard

nnoremap <Leader>hc :set cuc!<CR> | " toggle highlight current column identation
nnoremap <Leader>hl :set cursorline!<CR> | " toggle highlight current line

nnoremap <c-j> :m .+1<CR>== | "(movement) move current line or selection down
nnoremap <c-k> :m .-2<CR>== | "(movement) move current line or selection up

nnoremap <leader>nt :tabnew<CR> | " (tabs) Open new empty tab
nnoremap <leader>ct :tabclose<CR> | " (tabs) close
nnoremap <C-right> :tabnext<CR> | " (NORMAL) (tabs) next
nnoremap <C-left> :tabprevious<CR> | " (NORMAL) (tabs) previous
inoremap <C-right> <Esc>:tabnext<CR> | " (INSERT) (tabs) next
inoremap <C-left> <Esc>:tabprevious<CR> | " (INSERT) (tabs) previous

" CUSTOM NAVIGATION
" Keep the cursor in place when you join lines with J. That will also drop a mark before the operation to which you return afterwards:
nnoremap J mzJ`z

nnoremap <Leader>M :Marks<CR>| " (marks) show all
nnoremap <Leader>Mda :delmarks!<CR>| " (marks) delete all

nnoremap <Leader>wj <c-w>j| " (windows) move to down window
nnoremap <Leader>wk <c-w>k| " (windows) move to up window
nnoremap <Leader>wh <c-w>h| " (windows) move to left window
nnoremap <Leader>wl <c-w>l| " (windows) move to right window
nnoremap <Leader>wJ <c-w>J| " (windows) shift to down window
nnoremap <Leader>wK <c-w>K| " (windows) shift to up window
nnoremap <Leader>wH <c-w>H| " (windows) shift to left window
nnoremap <Leader>wL <c-w>L| " (windows) shift to right window
nnoremap <Leader>wr <c-w>r| " (windows) swap / shift rotate split window
noremap <Leader>ws  <c-w>t<c-w>K| " (windows) change split orientation to horizontal
noremap <Leader>wv  <c-w>t<c-w>H| " (windows) change split orientation to vertical
nnoremap <Leader>ww <C-w>w| " (windows)  toggle between windows
nnoremap <Leader>wV :vnew<CR>| " (windows) new vertical window split
nnoremap <Leader>wS :new<CR>| " (windows) new horizontal window split

nnoremap <Leader>llt :set spell!<CR>| " (spellcheck) toggle on/off
nnoremap <Leader>llo :set spell?<CR>| " (spellcheck) show spell status on/off
nnoremap <Leader>lls :set spelllang?<CR>| " (spellcheck) show current spelllang
nnoremap <Leader>llb :set spelllang=en,pt_br<CR>| " (spellcheck) set language to english and portuguese brazil
nnoremap <Leader>lle :set spelllang=en<CR>| " (spellcheck) set language to english
nnoremap <Leader>llp :set spelllang=pt_br<CR>| " (spellcheck) set language to portuguese brazil
nnoremap <Leader>llf :normal! mz[s1z=`z]<CR>| " (spellcheck) automatically fix last misspelled word and jump back to where you were
nnoremap <Leader>og :!gedit %<CR>| " open current file on gedit

nnoremap <Leader>sb :new<CR>| " ( windows) splits - Open new empty buffer below
nnoremap <Leader>sr :vnew<CR>| " ( windows) splits - Open new empty buffer aside

" jumps to the previous spelling mistake [s, then picks the first suggestion 1z=, and then jumps back `]a. The <c-g>u in the middle make it possible to undo the spelling correction quickly.
inoremap <C-l> <c-g>u<Esc>[s1z=`]a<c-g>u| " (spellcheck)(INSERT) Fix the previous spelling mistake while typing
