augroup luaconf
    autocmd!

    " TABs to spaces
    autocmd FileType lua set tabstop=2
    autocmd FileType lua set softtabstop=2
    autocmd FileType lua set shiftwidth=2
    autocmd FileType lua set shiftround
    autocmd FileType lua set expandtab

    " Indentation
    autocmd FileType lua set autoindent
    autocmd FileType lua set smartindent
augroup END
