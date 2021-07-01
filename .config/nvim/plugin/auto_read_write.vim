" " trigger `autoread` when files changes on disk
" set autoread
" autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" " notification after file change
" autocmd FileChangedShellPost *
" \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
" " autosave on FocusLost
" :au FocusLost * silent! wa
" " autocmd FileType md,markdown,MarkDown
" " 	\autocmd FocusLost * :wa
