"--------------------------------------------------------------------------
" General settings
"--------------------------------------------------------------------------

set clipboard+=unnamedplus
set colorcolumn=80
set encoding=utf-8
set hidden
set ignorecase
set linebreak
set listchars=eol:¶,tab:<->,space:°,trail:°,extends:>,precedes:<
set mouse=a
set nobackup
set nowritebackup
set noerrorbells
set noswapfile
set nowrap
set number relativenumber
set redrawtime=10000 " Allow more time for loading syntax on large files
set scrolloff=8
set sidescrolloff=8
set smartcase
set expandtab tabstop=4 shiftwidth=4
set undodir=~/.local/share/nvim/undodir
set undofile
set updatetime=300 " Reduce time for highlighting other references
set wildmode=longest,list,full
set background=dark
set cursorline cursorcolumn

"--------------------------------------------------------------------------
" Key maps
"--------------------------------------------------------------------------

let mapleader = "\<space>"

nnoremap <leader>ve :edit ~/.config/nvim/init.vim<cr>
nmap <leader>vr :w<cr>:source ~/.config/nvim/init.vim<cr>
nnoremap <leader>vpi :PlugInstall<cr>
nnoremap <leader>vpc :PlugClean<cr>

nnoremap <leader>k :nohlsearch<CR>
nnoremap <leader>Q :bufdo bdelete<cr>

" Allow gf to open non-existent files
nnoremap gf :edit <cfile><cr>
" create new file in directory which doesn't exist
nnoremap ge :e %:h/
nnoremap <silent> <Leader>gx :set cursorline! cursorcolumn!<CR>
nnoremap <silent> <Leader>gp :set list!<CR>
nnoremap <silent> <leader>gw :set wrap!<cr>

nnoremap <silent> <leader>gt :put =strftime('%d.%m.%y %H:%M:%S')<cr>

" Reselect visual selection after indenting
vnoremap < <gv
vnoremap > >gv

" Maintain the cursor position when yanking a visual selection
" http://ddrscott.github.io/blog/2016/yank-without-jank/
vnoremap y myy`y
vnoremap Y myY`y

" When text is wrapped, move by terminal rows, not lines, unless a count is provided
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

"escape terminal
tnoremap <Esc> <C-\><C-n>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

" Paste replace visual selection without copying it
vnoremap p "_dP

nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>

" Make Y behave like the other capitals
nnoremap Y y$

" Open the current file in the default program
nmap <leader>x :!xdg-open '%:p'<cr><cr>

" Quicky escape to normal mode
inoremap jj <esc>
inoremap ZZ <esc>:x<cr>
" inoremap :w <esc>:w<cr>

nnoremap <leader>cl :w<cr>:!xelatex main.tex<cr>

"--------------------------------------------------------------------------
" Plugins
"--------------------------------------------------------------------------

source ~/.config/nvim/functions/vim_plug_install.vim

call plug#begin('~/.local/share/nvim/plugged')

    source ~/.config/nvim/plugins/gruvbox.vim
    source ~/.config/nvim/plugins/vim-surround.vim
    source ~/.config/nvim/plugins/vim-commentary.vim
    source ~/.config/nvim/plugins/basic_editor.vim
    source ~/.config/nvim/plugins/trackers.vim
    source ~/.config/nvim/plugins/undotree.vim
    source ~/.config/nvim/plugins/nerdtree.vim
    source ~/.config/nvim/plugins/vim-maximize.vim
    source ~/.config/nvim/plugins/vim-airline.vim
    source ~/.config/nvim/plugins/vimwiki.vim
    source ~/.config/nvim/plugins/fzf.vim
    source ~/.config/nvim/plugins/goyo.vim
    source ~/.config/nvim/plugins/nvim-treesitter.vim
    " source ~/.config/nvim/plugins/vimspector.vim
    source ~/.config/nvim/plugins/autoformat.vim
    source ~/.config/nvim/plugins/python-syntax.vim
    source ~/.config/nvim/plugins/markdown-preview.vim
    source ~/.config/nvim/plugins/lsp.vim
    source ~/.config/nvim/plugins/emmet.vim
    Plug 'jbyuki/instant.nvim'
    let g:instant_username = "catalin"

    source ~/.config/nvim/plugins/which-key.vim

call plug#end()
doautocmd User When_PlugLoaded


"--------------------------------------------------------------------------
" Miscellaneous
"--------------------------------------------------------------------------

source ~/.config/nvim/functions/virtual_edit.vim
source ~/.config/nvim/functions/run_file.vim
source ~/.config/nvim/functions/compile_markdown.vim

autocmd InsertEnter * norm zz

augroup Mkdir
  autocmd!
  autocmd BufWritePre * call mkdir(expand("<afile>:p:h"), "p")
augroup END

highlight ColorColumn ctermbg=darkgrey
hi CursorLine   cterm=NONE ctermbg=238
hi CursorColumn cterm=NONE ctermbg=238

call matchadd("GroupN", '\n')
call matchadd("GroupSpace", ' ')
call matchadd("GroupTab", '\t')
hi GroupSpace ctermfg=50
hi GroupTab ctermfg=197
hi GroupN ctermfg=63
