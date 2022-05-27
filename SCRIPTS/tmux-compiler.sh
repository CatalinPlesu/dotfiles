#!/bin/sh
FILE=$1
FILE="main.rs"

declare -a arr=("rs:cargo run:cargo run --release" "py:python" "sh:sh")

# for((i=0;i<${#arr[@]};i++))
# do
#     echo "$i: ${arr[$i]}"
# done

for language in "${arr[@]}"
do
   strings=(${language//:/ })
   echo "${strings[0]}"                  
   echo "${strings[1]}"                  
   echo "${strings[2]}"                  
   echo "$language"

    if [ "${FILE##*.}" = "${strings[0]}" ]; 
    then
       text="command to run> ${strings[1]}"
    else
        text="echo unknown file"
    fi

done


# done
# tmux neww zsh


# tmux send "$text" ENTER


  # if !empty(glob('makefile')) && !isdirectory('makefile')
  #   exec '!make'
  # elseif match(@%, '.rb$') != -1
  #   exec '!ruby % '
  # elseif match(@%, '.py$') != -1
  #   exec '!python % '
  # elseif match(@%, '.js$') != -1
  #   exec '!node % '
  # elseif match(@%, '.ts$') != -1
  #   exec '!tsc %'
  #   exec '!node %:r.js'
  # elseif match(@%, '.cpp$') != -1
  #   exec '!g++ % '
  #   exec '!./a.out'
  # elseif match(@%, '.c$') != -1
  #   exec '!g++ % '
  #   exec '!./a.out'
  # elseif match(@%, '.cs$') != -1
	# exec '!mcs % '
	# exec '!mono %:r '
  # elseif match(@%, '.sh$') != -1
	# exec '!sh % '
  # elseif match(@%, '.csv$') != -1
	# exec '!~/Documents/notes/Journal/Goals/fitness/plot.py %'
  # elseif match(@%, '.rs$') != -1
	    # if !empty(glob('../Cargo.lock')) && !isdirectory('../Cargo.lock')
			# exec '!cargo run --release'
		# elseif !empty(glob('Cargo.lock')) && !isdirectory('Cargo.lock')
			# exec '!cargo run --release'
		# else
			# exec '!rustc % '
			# exec '!./%:r'
	  # endif
  # else
  #   echo '<< ERROR >> RunFile() only supports rb, py, cpp, c, rs, js, ts, makefile'
