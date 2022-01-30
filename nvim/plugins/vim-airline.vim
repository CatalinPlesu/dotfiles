Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

let g:airline_powerline_fonts=1
let g:airline_theme='minimalist'

Plug 'edkolev/tmuxline.vim'
nnoremap <leader>vt :Tmuxline airline<Cr>:TmuxlineSnapshot ~/.config/tmux/airline<cr>
