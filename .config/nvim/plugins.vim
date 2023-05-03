" this installs it at ~/.local/share/nvim/plugged
call plug#begin(stdpath('data') . '/plugged')
" -----------------------------------------------------------------------------
"   ________                   _
"  /_  __/ /_  ___  ____ ___  (_)___  ____ _
"   / / / __ \/ _ \/ __ `__ \/ / __ \/ __ `/
"  / / / / / /  __/ / / / / / / / / / /_/ /
" /_/ /_/ /_/\___/_/ /_/ /_/_/_/ /_/\__, /
"                                 /____/
" -----------------------------------------------------------------------------
Plug 'nburns/vim-auto-light-dark'
Plug 'sonph/onehalf', { 'rtp': 'vim' }
function DarkMode()
  colorscheme onehalfdark
  set background=dark
  autocmd FocusLost * nested silent! highlight Normal guibg=brightgrey
  autocmd FocusGained * nested silent! highlight Normal guibg=brightblack
    " let g:lightline = { 'colorscheme': 'solarized' }
    " let g:airline_theme = 'testdark'
endfunction

function LightMode()
  colorscheme onehalflight
  set background=light
  autocmd FocusLost * nested silent! highlight Normal guibg=brightgrey
  autocmd FocusGained * nested silent! highlight Normal guibg=brightblack
    "let g:lightline = { 'colorscheme': 'PaperColor' }
endfunction

Plug 'dylanaraps/wal'

" colorscheme wal

" --- Telescope ---------------------------------------------------------------
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" Find files using Telescope command-line sugar.
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>
" -----------------------------------------------------------------------------

" --- Markdown ----------------------------------------------------------------
Plug 'Shougo/neoinclude.vim'
Plug 'godlygeek/tabular'
Plug 'Konfekt/FastFold'
Plug 'preservim/nerdtree'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'dag/vim-fish'
Plug 'tpope/vim-abolish'
Plug 'junegunn/goyo.vim'
source ~/.config/nvim/plugins/markdown.vim
source ~/.config/nvim/plugins/whitespace.vim
source ~/.config/nvim/plugins/abook.vim

" -----------------------------------------------------------------------------
Plug 'majutsushi/tagbar'
nmap <F8> :TagbarToggle<CR>
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
Plug 'mileszs/ack.vim'
if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif
" -----------------------------------------------------------------------------

" ---- Coc --------------------------------------------------------------------
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
source ~/.config/nvim/plugins/coc.vim
" ---- OR Coq -----------------------------------------------------------------
" " main one
" let g:coq_settings = {'auto_start': v:true }
" Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
" Plug 'neovim/nvim-lspconfig'
" -----------------------------------------------------------------------------

"---- Airline -----------------------------------------------------------------
Plug 'vim-airline/vim-airline'
" Plug 'vim-airline/vim-airline-themes'
source ~/.config/nvim/plugins/airline.vim
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
Plug 'yggdroot/indentline'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
let g:indentLine_setColors = 1
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_map = '<c-p>'
" let g:ctrlp_cmd = 'CtrlP .'
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_use_caching = 0
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\.git$\|\.yardoc\|__pycache__$\|log\',
  \ 'file': '\.so$\|\.dat$|\.DS_Store$'
  \ }
" -----------------------------------------------------------------------------

" ---- devicons ---------------------------------------------------------------
"  Needs to load after plugins it interfaces with like airline, ctrlp, etc.
Plug 'ryanoasis/vim-devicons'
let g:DevIconsEnableDistro = 0
let g:webdevicons_enable_airline_statusline = 1
" -----------------------------------------------------------------------------

" ---- Google formatter--------------------------------------------------------
Plug 'google/vim-maktaba'
Plug 'google/vim-codefmt'
Plug 'google/vim-glaive'

augroup autoformat_settings
  autocmd FileType c,cpp,proto,arduino AutoFormatBuffer clang-format
  autocmd FileType html,css,sass,scss,less,json AutoFormatBuffer js-beautify
  autocmd FileType java AutoFormatBuffer google-java-format
  " Alternative: autocmd FileType python AutoFormatBuffer autopep8
  autocmd FileType rust AutoFormatBuffer rustfmt
  autocmd FileType vue AutoFormatBuffer prettier
augroup END

" -----------------------------------------------------------------------------
Plug 'SirVer/ultisnips' |  Plug 'honza/vim-snippets'

" Trigger configuration. You need to change this to something other than <tab> if you use one of the following:
" - https://github.com/Valloric/YouCompleteMe
" - https://github.com/nvim-lua/completion-nvim
let g:UltiSnipsExpandTrigger=""
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"------------------------------------------------------------------------------"
"                                 Comment stuff                                "
"------------------------------------------------------------------------------"
Plug 'folke/todo-comments.nvim'
Plug 'cometsong/commentframe.vim'
Plug 'scrooloose/nerdcommenter'
" Create default mappings
let g:NERDCreateDefaultMappings = 1
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 0
"------------------------------------------------------------------------------"

" Misc
Plug '/tmp/testPlug'
Plug 'tpope/vim-obsession'
Plug 'folke/which-key.nvim'

"------------------------------------------------------------------------------"
"                                      End                                     "
" To install call:
" :PlugInstall
"  IMPORTANT: This needs to be last
" -----------------------------------------------------------------------------
call plug#end()
call glaive#Install()
lua << EOF
  require("which-key").setup {}
EOF

lua << EOF
  require("todo-comments").setup { }
EOF

lua << EOF
require'nvim-treesitter.configs'.setup {
   -- ensure_installed = { "c", "lua", "rust", "vim", "yaml", "bash", "fish", "markdown", "python" },

  sync_install = false,

  auto_install = true,

  highlight = {
    enable = true,
  },
  indent = {
    enable = true
  },
}
EOF


lua << EOF
  vim.keymap.set("n", "z", function()
      vim.lsp.buf_request(
          0,
          "textDocument/signatureHelp",
          vim.lsp.util.make_position_params(),
          function(err, result, crx, config)
              print(result.signatures[1].label)
          end
      )
  end)
EOF
" * source ~/.config/nvim/plugins/ncm.vim
" * source ~/.config/nvim/plugins/syntastic.vim
" * Plug 'jsfaint/gen_tags.vim'
" -----------------------------------------------------------------------------
" vim: set sw=2 ts=2 sts=2 et tw=80 ft=vim fdm=marker fmr={{{,}}}:
