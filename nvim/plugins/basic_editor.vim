" Plug 'ap/vim-css-color'
Plug 'lilydjwg/colorizer'
Plug 'frazrepo/vim-rainbow'
let g:rainbow_active = 1
" Plug 'jiangmiao/auto-pairs'
Plug 'farmergreg/vim-lastplace'

Plug 'voldikss/vim-translator'
let g:translator_target_lang = 'en'
""" Configuration example
" Echo translation in the cmdline
nmap <silent> <Leader>tt <Plug>Translate
" Display translation in a window
nmap <silent> <Leader>tw <Plug>TranslateW
" Replace the text with translation
nmap <silent> <Leader>tr <Plug>TranslateR
" Translate the text in clipboard
nmap <silent> <Leader>tx <Plug>TranslateX


Plug 'vim-scripts/Typer'
" :Typer filename
" just smash the keyboard
