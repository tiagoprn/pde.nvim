
augroup txtconf
    autocmd!
    " set virtualedit=all  " BREAKTHROUGH CHANGE: allows to move the cursor past the last character. If you insert a new character there, it is automatically padded with spaces. Useful for e.g. tables
    " autocmd FileType markdown,txt InsertLeave * normal gwap<CR> " formats the current paragraph when leaving insert mode
    " do not use txtwidth with soft wrap, it has no effect
    autocmd FileType markdown,txt,vim set linebreak  " soft wrap: wrap the txt when it hits the screen edge

    " disables conceallevel=2 for markdown files, so they can be properly read/edited as pointed at https://vi.stackexchange.com/questions/12520/markdown-in-neovim-which-plugin-sets-conceallevel-2
    autocmd FileType markdown,txt,vim let g:indentLine_enabled=0
    autocmd FileType markdown,txt,vim let g:indentLine_fileTypeExclude = ['markdown']

    autocmd FileType markdown,txt,vim setlocal conceallevel=0
    autocmd FileType markdown,txt,vim setlocal concealcursor=
    autocmd FileType markdown,txt,vim setlocal nofoldenable  " disable folding
augroup END

augroup convertmarkdownconf
	autocmd!
	autocmd FileType markdown nnoremap <leader>pp :call ConvertMarkdownToFormat('pdf')<cr>| " pandoc: convert markdown to pdf
	autocmd FileType markdown nnoremap <leader>ph :call ConvertMarkdownToFormat('html')<cr>| " pandoc: convert markdown to html
augroup END

" "stop conceal (hiding characters) from markdown buffers
" augroup MarkdownConceal
"   autocmd!
"   autocmd FileType markdown setlocal conceallevel=0
" augroup END

