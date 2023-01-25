
autocmd BufWritePre *.py :silent call CocAction('runCommand', 'pyright.organizeimports')
" autocmd BufWritePre *.py :silent call CocAction('runCommand', 'editor.action.organizeImport')
