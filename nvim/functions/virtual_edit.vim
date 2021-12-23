nnoremap <leader>gv :<C-u>call ToggleVirtualedit()<cr>

" virtualedit does not support ! toggle
function! ToggleVirtualedit()
if &virtualedit ==# ""
	set virtualedit=all
else
	set virtualedit=""
endif
endfunction
