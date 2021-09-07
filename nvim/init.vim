" Bootstrap Plug
let autoload_plug_path = stdpath('data') . '/site/autoload/plug.vim'
if !filereadable(autoload_plug_path)
  silent execute '!curl -fLo ' . autoload_plug_path . '  --create-dirs 
      \ "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif
unlet autoload_plug_path

"" plugins
call plug#begin('~/.local/share/nvim/plugged')
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround' " have to test
Plug 'wakatime/vim-wakatime' " count time using vim in each file
Plug 'gruvbox-community/gruvbox' " sexy color scheme
Plug 'vim-airline/vim-airline' " bottom line
Plug 'mbbill/undotree' " leader u
Plug 'preservim/nerdtree' " leader n
Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color' " preview colors in some fies
Plug 'frazrepo/vim-rainbow'
" Plug 'jiangmiao/auto-pairs'
" Plug 'maxboisvert/vim-simple-complete' " autocompletion for everything
Plug 'vimwiki/vimwiki' " great note taking experience
Plug 'dhruvasagar/vim-table-mode' " good looking tables
"" games XD
Plug 'ThePrimeagen/vim-be-good' " game that encourage to use relative number
Plug 'johngrib/vim-game-snake' " snake game
call plug#end()

""plugin settings
let g:airline_powerline_fonts=0
let g:rainbow_active = 1
colorscheme gruvbox
let maplocalleader=";"
let g:vimwiki_list = [{'path': '~/Documents/notes/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]

"" settings
syntax on
set noerrorbells
""use system clipboard
set clipboard+=unnamedplus
""mouse selection
set mouse=a
set wildmode=longest,list,full
set encoding=utf-8
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
set ignorecase
set colorcolumn=80
set scrolloff=10
" set cursorline cursorcolumn
"" to be able to write anywhere even in the midle of nowhere
" set virtualedit=all
highlight ColorColumn ctermbg=darkgrey
"" 232 blackest to 255 white
:hi CursorLine   cterm=NONE ctermbg=238
:hi CursorColumn cterm=NONE ctermbg=238

""bindings
let mapleader = " "
nnoremap <Leader>c :set cursorline! cursorcolumn!<cr>
nnoremap <leader>va :set virtualedit=all<cr>
nnoremap <leader>vo :set virtualedit=""<cr>
"" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
"" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
nnoremap <silent> <leader>l :vertical resize +5<CR>
nnoremap <silent> <leader>h :vertical resize -5<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>f :FZF<CR>
"" clean white space
nnoremap <leader>cl BufWritePre * %s/\s\+$//e<cr>
"" for markdown previewing
function Preview()
	silent! execute '!markdown-folder-to-html ~/Documents/notes/'
	silent! execute "!echo %:p | sed 's/notes/_notes/' | sed 's/md/html/' | xargs $BROWSER"
endfunction
nnoremap <silent> <leader>mc :silent! execute '!markdown-folder-to-html ~/Documents/notes/'<cr>
nnoremap <silent> <leader>md :call Preview()<cr>
nnoremap <leader>s :!syncthing<cr>
nnoremap <leader>br :silent exec '!"$BROWSER" % &'<cr>
""inserting empty lines
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>
""compile groff files
nnoremap <leader>me :silent exec '!groff -Tpdf -me % > %.pdf'<cr>
nnoremap Y y$ 
inoremap ZZ <esc>:x<cr> 
nnoremap <leader>t :r!day<cr>
inoremap jk <esc>
inoremap kj <esc>

""autocmd settings
" Vertically center document when entering insert mode
autocmd InsertEnter * norm zz
"" Remove trailing whitespace on save
" autocmd BufWritePre * %s/\s\+$//e
autocmd BufEnter NERD_tree_* | execute 'normal R'
