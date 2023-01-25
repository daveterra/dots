" ==============================================================================
" NVIM / VIM settings
" ==============================================================================

set encoding=UTF-8

" Need a more compatible shell for plugins and such
if &shell =~# 'fish$'
    set shell=bash
endif

source ~/.config/nvim/plugins.vim
source ~/.config/nvim/settings.vim

" Filetype detection
au BufNewFile,BufRead *.md set filetype=markdown
au BufNewFile,BufRead *.{yaml,yml} set filetype=yaml
au BufNewFile,BufRead *.fdoc set filetype=yaml
au BufNewFile,BufRead *neomutt* setlocal filetype=mail
autocmd Filetype json setlocal nospell
autocmd Filetype python setlocal colorcolumn=100
autocmd Filetype c setlocal foldmethod=syntax
autocmd FileType c,cpp nnoremap <buffer> gd :<c-u>call ncm2_pyclang#goto_declaration()<cr>
autocmd! bufwritepost *.vim nested so ~/.vimrc
autocmd! bufwritepost .tmux.conf execute ':!tmux source-file %'

" vim: ft=vim fdm=marker fmr={{{,}}}:
