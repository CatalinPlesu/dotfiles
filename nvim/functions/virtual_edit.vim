"" virtualedit does not support ! toggle
function ToggleVirtualedit()
if &virtualedit ==# ""
	set virtualedit=all
else
	set virtualedit=""
endif
endfunction
