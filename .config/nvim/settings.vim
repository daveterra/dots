" ==============================================================================
" NVIM / VIM Settings
" ==============================================================================

set nocompatible               " don't bother with vi compatibility
set noswapfile
syntax enable                  " enable syntax highlighting
filetype plugin indent on
filetype plugin on

" Tab things
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set smarttab
set autoindent smartindent breakindent

" transparency=true
" set softtabstop=0              " insert mode tab and backspace use 2 spaces
" set tabstop=8                  " actual tabs occupy 8 characters
" set shiftwidth=2               " normal mode indentation commands use 2 spaces
" set expandtab                  " expand tabs to spaces
" set smarttab

set timeout timeoutlen=500
set incsearch hlsearch         " search as you type, highlight search
set autoread                   " read file if it's been modified outside of vim
set backspace=2                " Fix broken backspace in some setups
set backupcopy=yes             " see :help crontab
set clipboard=unnamed          " yank and paste with the system clipboard
set directory-=.               " don't store swapfiles in the current directory
set encoding=utf-8
set ignorecase                 " case-insensitive search
set laststatus=3               " always show statusline
set list                       " show trailing whitespace
set listchars=tab:▸\ ,trail:▫,extends:>,precedes:<
set number                     " show line numbers
set relativenumber             " Number gutter shows relative numbers
set ruler                      " show where you are
" set scrolloff=999              " show context above/below cursorline
set showcmd
set smartcase                  " case-sensitive search if any caps
set wildmenu                   " show a navigable menu for tab completion
set wildmode=full
set title
set titlestring=%t\ %m\ %F     " set titlestring=%t\ %m\ (%{expand('%:p:h')})
set foldlevelstart=20          " Open folds by default
set backspace=indent,eol,start " OSX Backspace fix??
set cursorline
set guicursor+=a:blinkon1
set colorcolumn=80
set fileformat=unix
set spell
set clipboard=unnamed
set completeopt=menu,preview,menuone shortmess+=c
set nobackup nowritebackup
set updatetime=300
set hidden
set cmdheight=2
set signcolumn=auto:2
set pyxversion=3
set foldmethod=syntax
let g:indentLine_char = '⦙'

" Keep the current line centered
" augroup VCenterCursor
  " au!
  " au BufEnter,WinEnter,WinNew,VimResized *,*.*
        " \ let &scrolloff=winheight(win_getid())/2
" augroup END

hi Keyword gui=italic cterm=italic
hi Statement gui=italic cterm=italic
hi String gui=italic cterm=italic
hi Todo gui=italic cterm=italic

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor\ -f

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  " let g:ctrlp_user_command = 'ag %s -f --nocolor -g ""'
endif

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Fix Cursor in TMUX
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

set termguicolors t_Co=256
if exists('+termguicolors')
  " These are for enabling transparent backgrounds, not really needed I don't
  " think?
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

" keyboard shortcuts
let mapleader = '\'
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

" Center the cursor when searching and paging
nnoremap n nzzzv
nnoremap N Nzzzv
noremap <C-d> <C-d>zz
noremap <C-u> <C-u>zz

nnoremap <leader>t :CtrlP<CR>
noremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>a :Ack<space>
noremap <silent> <leader>V :source ~/.config/nvim/init.vim<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt
nmap <leader>0 0gt
nmap s gt
nmap S gT
nmap // :let @/ = ""<CR><CR>
" in case you forgot to sudo
cnoremap w!! %!sudo tee > /dev/null %

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" vim: ft=vim fdm=marker fmr={{{,}}}:
