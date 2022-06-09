Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_powerline_fonts=1
let g:airline_theme='minimalist'

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_symbols.colnr = ' ℅:'
let g:airline_symbols.linenr = '㏑'
" ㏑:119/178☰℅:

Plug 'edkolev/tmuxline.vim'
nnoremap <leader>vt :Tmuxline airline<Cr>:TmuxlineSnapshot ~/.config/tmux/airline<cr>
