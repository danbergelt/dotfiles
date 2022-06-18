" Plugins
call plug#begin('~/.vim/plugged')

Plug 'dense-analysis/ale'   " linting + formatting
Plug 'natebosch/vim-lsc'    " language server
Plug 'tpope/vim-surround'   " pairs helper
Plug 'agude/vim-eldar'      " color scheme
Plug 'FooSoft/vim-argwrap'  " function argument wrapping
Plug 'Raimondi/delimitMate' " auto-closing pairs
Plug 'junegunn/fzf'         " fzf hookup
Plug 'junegunn/fzf.vim'     " fzf hookup enhancement
Plug 'tpope/vim-commentary' " comment bindings
Plug 'tpope/vim-fugitive'   " git bindings
Plug 'sheerun/vim-polyglot' " syntax highlighting

call plug#end()

" Remappings
nnoremap <space> <nop>
let mapleader=" "

" Theme
colorscheme eldar

" Syntax
syntax on
filetype plugin indent on

" Keyboard
nmap <leader>a :ArgWrap<CR>
nmap <leader>b <C-o>
nmap <leader>e :echo expand('%:p')<CR>
nmap <leader>ff :GFiles<CR>
nmap <leader>fc :Rg<CR>
nmap <leader>gb :Git blame<CR>
nmap <leader>gd :Git diff<CR>
nmap <leader>gs :G<CR>
nmap <leader>gw :Gwrite<CR>
nmap <leader>p :set paste!<CR>:set paste?<CR>
nmap <leader>t :Lex<CR>
nmap <leader>w <C-W>w
nmap <tab> :tabn<CR>
nmap <S-tab> :tabp<CR>

" Explore mode
let g:netrw_liststyle=3
let g:netrw_banner=0
let g:netrw_winsize=30

" Appearance
set number
set relativenumber
set modelines=0
set ruler
set scrolloff=8

" Spacing/formatting
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set backspace=indent,eol,start

" Search
set incsearch
set ignorecase

" Interaction
set mouse=a
set autoread

" Linting + formatting
let g:ale_fix_on_save = 1
let g:ale_linters_explicit = 1
let g:ale_fixers = {
    \ '*': ['remove_trailing_lines', 'trim_whitespace'],
    \ }
let g:ale_linters = {
    \ 'javascript': ['eslint'],
    \ 'python': ['flake8', "bandit"]
    \ }

let g:ale_javascript_eslint_options = '-c ~/.eslintrc.json'

" Language server
let g:lsc_enable_popup_syntax = v:false
let g:lsc_auto_map = {
    \ 'Completion': 'completefunc',
    \ 'ShowHover': '<leader>qi',
    \ 'Rename': '<leader>qr',
    \ 'GoToDefinition': '<leader>qd',
    \ }
let g:lsc_server_commands = {
    \ 'python': 'pyright-langserver --stdio',
    \ 'javascript': 'typescript-language-server --stdio',
    \ 'typescript': 'typescript-language-server --stdio',
    \ }
