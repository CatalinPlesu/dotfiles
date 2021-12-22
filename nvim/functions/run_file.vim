nnoremap <leader>cc :w<cr>:call RunFile()<cr>

"" To automatically compile and or run source code
function! RunFile()
  if match(@%, '.rb$') != -1
    exec '!ruby % '
  elseif match(@%, '.py$') != -1
    exec '!python % '
  elseif match(@%, '.cpp$') != -1
    exec '!g++ % '
    exec '!./a.out'
  elseif match(@%, '.c$') != -1
    exec '!g++ % '
    exec '!./a.out'
  elseif match(@%, '.cs$') != -1
	exec '!mcs % '
	exec '!mono %:r '
  elseif match(@%, '.sh$') != -1
	exec '!sh % '
  elseif match(@%, '.rs$') != -1
	    if !empty(glob('../Cargo.lock')) && !isdirectory('../Cargo.lock')
			exec '!cargo run'
		elseif !empty(glob('Cargo.lock')) && !isdirectory('Cargo.lock')
			exec '!cargo run'
		else
			exec '!rustc % '
			exec '!./%:r'
	  endif
  else
    echo '<< ERROR >> RunFile() only supports rb, py, cpp, c, rs'
  endif
endfunction

