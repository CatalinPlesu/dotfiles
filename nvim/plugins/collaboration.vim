Plug 'jbyuki/instant.nvim'
let g:instant_username = "catalin"
nnoremap <leader>ISS :InstantStartServer<cr>:InstantStartSession 127.0.0.1 8080<cr>
nnoremap <leader>ISs :InstantStartServer<cr>:InstantStartSingle 127.0.0.1 8080<cr>
" 1. Start Server
" 2. Start Session or Single
" 3. Ngrok to share it | localtunel cant do it
" ngrok http 8080
" 4. Client connect
