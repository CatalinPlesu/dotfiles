" Compile code
nnoremap <leader>cc :w<cr>:call RunFile()<cr>

"" To automatically compile and or run source code
function! RunFile()
  if match(readfile(expand("%:p")),"startuml")!=-1 
    exec '!plantuml %:p'
  elseif !empty(glob('makefile')) && !isdirectory('makefile')
    exec '!make'
  elseif match(@%, '.rb$') != -1
    exec '!ruby % '
  elseif match(@%, '.py$') != -1
    exec '!python % '
  elseif match(@%, '.js$') != -1
    exec '!node % '
  elseif match(@%, '.ts$') != -1
    exec '!tsc %'
    exec '!node %:r.js'
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
  elseif match(@%, '.csv$') != -1
	exec '!~/Documents/notes/Journal/Goals/fitness/plot.py %'
  elseif match(@%, '.rs$') != -1
	    if !empty(glob('../Cargo.lock')) && !isdirectory('../Cargo.lock')
			exec '!cargo run --release'
		elseif !empty(glob('Cargo.lock')) && !isdirectory('Cargo.lock')
			exec '!cargo run --release'
		else
			exec '!rustc % '
			exec '!./%:r'
	  endif
  else
    echo '<< ERROR >> RunFile() only supports rb, py, cpp, c, rs, js, ts, makefile'
  endif
endfunction
