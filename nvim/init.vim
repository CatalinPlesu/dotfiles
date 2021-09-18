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
" Plug 'tpope/vim-commentary'
Plug 'ap/vim-css-color' " preview colors in some fies
Plug 'frazrepo/vim-rainbow'
" Plug 'jiangmiao/auto-pairs'
Plug 'vimwiki/vimwiki' " great note taking experience
Plug 'dhruvasagar/vim-table-mode' " good looking tables
Plug 'ThePrimeagen/vim-be-good' " game that encourage to use relative number
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}  " We recommend updating the parsers on update
Plug 'preservim/nerdcommenter'
call plug#end()

""plugin settings
let g:airline_powerline_fonts=0
let g:rainbow_active = 1
colorscheme gruvbox
let maplocalleader=";"
let g:vimwiki_list = [{'path': '~/Documents/notes/',
                      \ 'syntax': 'markdown', 'ext': '.md'}]
let g:NERDSpaceDelims = 1
let g:NERDCompactSexyComs = 1
let g:NERDCustomDelimiters = { 'c': { 'left': '//','right': '' } }
let g:NERDCommentEmptyLines = 1
let g:NERDTrimTrailingWhitespace = 1
let g:NERDToggleCheckAllLines = 1

"" settings
syntax on
set noerrorbells
set clipboard+=unnamedplus
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
highlight ColorColumn ctermbg=darkgrey
"" 232 blackest to 255 white
:hi CursorLine   cterm=NONE ctermbg=238
:hi CursorColumn cterm=NONE ctermbg=238

""bindings
let mapleader = " "
nnoremap <silent> <Leader>x :set cursorline! cursorcolumn!<cr>
nnoremap <leader>v :<C-u>call ToggleVirtualedit()<cr>
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <silent> <leader>l :vertical resize +5<CR>
nnoremap <silent> <leader>h :vertical resize -5<CR>
nnoremap <silent> <leader>c} V}k:call nerdcommenter#Comment('x', 'toggle')<CR>
nnoremap <silent> <leader>c{ V{j:call nerdcommenter#Comment('x', 'toggle')<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>
nnoremap <leader>f :FZF<CR>
nnoremap <leader>cl BufWritePre * %s/\s\+$//e<cr>
nnoremap <silent> <leader>mc :silent! execute '!markdown-folder-to-html ~/Documents/notes/'<cr>
nnoremap <silent> <leader>md :call PreviewMD()<cr>
nnoremap <leader>s :!syncthing<cr>
nnoremap <leader>br :silent exec '!"$BROWSER" % &'<cr>
nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>
nnoremap <leader>p :!python %<cr>
nnoremap <leader>r :w<cr>:!make<cr>
nnoremap Y y$ 
nnoremap <leader>d :r!date +\%d_\%b_\%Y<cr>:norm I[<cr>:norm A]<cr>:r!date +\%d_\%b_\%Y<cr>:norm I(<cr>:norm A.md)<cr>:norm kJx<cr>
nnoremap <leader>t :r!date +\%T<cr>:norm I[<cr>:norm A]<cr>
nnoremap <leader>e :e %:h/
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
inoremap ZZ <esc>:x<cr> 
inoremap jk <esc>
inoremap kj <esc>

""autocmd settings
autocmd InsertEnter * norm zz
" autocmd BufWritePre * %s/\s\+$//e
autocmd BufEnter NERD_tree_* | execute 'normal R'
augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

""functions
function PreviewMD()
	silent! execute '!markdown-folder-to-html ~/Documents/notes/'
	silent! execute "!echo %:p | sed 's/notes/_notes/' | sed 's/md/html/' | xargs $BROWSER"
endfunction

function ToggleVirtualedit()
if &virtualedit ==# ""
	set virtualedit=all
else
	set virtualedit=""
endif
endfunction
