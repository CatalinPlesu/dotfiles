let mapleader = " "

" j/k will move virtual lines (lines that wrap)
noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

" Shortcutting split navigation, saving a keypress:
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

nnoremap <silent> <leader>L :vertical resize +5<CR>
nnoremap <silent> <leader>H :vertical resize -5<CR>

map <leader>n :NERDTreeToggle<CR>
nnoremap <leader>u :UndotreeToggle<CR>

" for markdown previewing
nnoremap <silent> <leader>br :!qutebrowser --target window http://localhost:6419/ &<cr>
nnoremap <silent> <leader>md :!grip %<cr>
nnoremap <leader>s :!syncthing<cr>
