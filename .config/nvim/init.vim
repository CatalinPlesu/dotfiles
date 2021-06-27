call plug#begin('~/.local/share/nvim/plugged')
Plug 'tpope/vim-surround' " have to test
Plug 'wakatime/vim-wakatime' " count time using vim in each file
Plug 'gruvbox-community/gruvbox' " sexy color scheme
Plug 'vim-airline/vim-airline' " bottom line
Plug 'mbbill/undotree' " leader u
Plug 'preservim/nerdtree' " leader n
Plug 'vimwiki/vimwiki' " have to test
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color' " preview colors in some fies
Plug 'frazrepo/vim-rainbow'
Plug 'freitass/todo.txt-vim'
" Plug 'jiangmiao/auto-pairs'
call plug#end()

" airline plugin
let g:airline_powerline_fonts=1
" gruvbox plugin
colorscheme gruvbox

" raimbow
let g:rainbow_active = 1

" vim wiki
let g:vimwiki_list = [{'path': '~/Documents/notes/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

" todo.txt
let maplocalleader=";"

syntax on
set noerrorbells
let mapleader = " "
"use system clipboard
set clipboard+=unnamedplus
set wildmode=longest,list,full
set encoding=utf-8

" Vertically center document when entering insert mode
autocmd InsertEnter * norm zz

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

"set nu rnu
set number relativenumber

set tabstop=4 softtabstop=4
set shiftwidth=4
set smartindent
set nowrap
set nobackup
set nowritebackup
set noswapfile
set undodir=~/.local/share/nvim/undodir
set undofile
set incsearch
set colorcolumn=80
highlight ColorColumn ctermbg=darkgrey


" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>
nnoremap <silent> <leader>L :vertical resize +5<CR>
nnoremap <silent> <leader>H :vertical resize -5<CR>
map <leader>n :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>

" for markdown previewing
nnoremap <silent> <leader>br :!qutebrowser --target window http://localhost:6419/<cr>
nnoremap <silent> <leader>md :!grip %<cr>
