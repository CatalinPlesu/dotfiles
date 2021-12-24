Plug 'puremourning/vimspector'

function VimSpectorSetup()

    nnoremap <Leader>dd :call vimspector#Launch()<CR>
    nnoremap <Leader>de :call vimspector#Reset()<CR>
    nnoremap <Leader>dc :call vimspector#Continue()<CR>

    nnoremap <Leader>dt :call vimspector#ToggleBreakpoint()<CR>
    nnoremap <Leader>dT :call vimspector#ClearBreakpoints()<CR>

    nmap <Leader>dk <Plug>VimspectorRestart
    nmap <Leader>dh <Plug>VimspectorStepOut
    nmap <Leader>dl <Plug>VimspectorStepInto
    nmap <Leader>dj <Plug>VimspectorStepOver

endfunction

augroup VimSpectorSetup
    autocmd!
    autocmd User When_PlugLoaded call VimSpectorSetup()
augroup END
