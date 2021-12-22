nnoremap <silent> <leader>cm :call PreviewMD()<cr>

function PreviewMD()
	silent! execute '!markdown-folder-to-html ~/Documents/notes/'
	silent! execute "!echo %:p | sed 's/notes/_notes/' | sed 's/md/html/' | xargs $BROWSER"
endfunction
