
autocmd BufWritePre *.py :silent call CocAction('runCommand', 'pyright.organizeimports')
set foldmethod=indent
nnoremap <space> za
" autocmd BufWritePre *.py :silent call CocAction('runCommand', 'editor.action.organizeImport')
