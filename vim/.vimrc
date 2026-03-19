set mouse=a
set number
set tabstop=4
set softtabstop=4
set shiftwidth=4
set scrolloff=6
set cindent
set expandtab
let mapleader=","
map ; :

call plug#begin()
Plug 'sickill/vim-monokai'
Plug 'joshdick/onedark.vim'
call plug#end()

colorscheme monokai
