" ###########################
" # Markdown writing things #
" ###########################
Plug 'plasticboy/vim-markdown'
Plug 'junegunn/limelight.vim'
Plug 'dhruvasagar/vim-table-mode'
" Configuration for vim-markdown
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_math = 1
let g:vim_markdown_toml_frontmatter = 1
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_autowrite = 1
let g:vim_markdown_edit_url_in = 'tab'
let g:vim_markdown_follow_anchor = 1
" Auto preview for markdown
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug', 'mail']}
let g:mkdp_filetypes = ['markdown', 'mail']
" let g:mkdp_auto_start = 1
" let g:mkdp_auto_close = 1
let g:mkdp_preview_options = { 'mkit': { 'html': 'true', 'linkify': 'true', 'typographer': 'true', 'table': 'true'}, }
let g:mkdp_markdown_css = '~/.vim/github.css'

" These were created mostly for blogging
command Date put =strftime('%Y-%m-%d %H:%M:%S%z')
command Update %s/\d\d\d\d-\d\d-\d\d \d\d:\d\d:\d\d.*/\=strftime('%Y-%m-%d %H:%M:%S%z')/g
command Notes tabe .notes/%:t


function! s:goyo_enter()
  set noshowmode
  set noshowcmd
  set scrolloff=999
  Limelight
endfunction

function! s:goyo_leave()
  set showmode
  set showcmd
  set scrolloff=5
  Limelight!
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
