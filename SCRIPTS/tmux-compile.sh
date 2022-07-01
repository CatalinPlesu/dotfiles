#!/usr/bin/env bash

ext=${1##*.}
file_ext=$1
file_name=${1%.*}
executed="false"

present_keywords=(
    # "startuml plantuml $file_ext"
    "/bin/sh sh $file_ext"
)
suported_keywords=""

present_file=(
    "Cargo.toml cargo run --release"
    "makefile make"
)
suported_files=""

present_ext=(
    "c gcc $file_ext -o $file_name && ./$file_name"
    "cpp g++ $file_ext -o $file_name && ./$file_name"
    "py python $file_ext"
    "rb ruby $file_ext"
    "rs rustc $file_ext && ./$file_name"
    "sh sh $file_ext"
    "csv python ~/Documents/notes/Journal/Goals/fitness/plot.py $file_ext"
)
suported_extensions=""

comand_to_be_executed=""
message_to_be_shown=""

if [[ "$executed" == "false" ]]; then
    for line in "${present_keywords[@]}"; do
        keyword=$(echo $line | awk '{print $1}')
        suported_keywords="$suported_keywords$keyword; "
        comand=$(echo $line| sed "s/^[^ ]* //")
        if grep "$keyword" $file_ext ; then
            executed="true"
            message_to_be_shown="Keyword detected: $keyword"
            comand_to_be_executed=$comand
            break
        fi
    done
fi

if [[ "$executed" == "false" ]]; then
    for line in "${present_file[@]}"; do
        filename=$(echo $line | awk '{print $1}')
        suported_files="$suported_files$filename; "
        comand=$(echo $line| sed "s/^[^ ]* //")
        if [[ $(find -iname "$filename" | wc -c) -ne 0 ]]; then
            executed="true"
            message_to_be_shown="File detected: $filename"
            comand_to_be_executed=$comand
            break
        fi
    done
fi

if [[ "$executed" == "false" ]]; then
    for line in "${present_ext[@]}"; do
        extension=$(echo $line | awk '{print $1}')
        suported_extensions="$suported_extensions$extension; "
        comand=$(echo $line| sed "s/^[^ ]* //")
        if [ "$ext" = "$extension" ]; then
            executed="true"
            message_to_be_shown="Extension detected: $ext"
            comand_to_be_executed=$comand
            break
        fi
    done
fi

if [[ "$executed" == "false" ]]; then
    echo "File was not executed"
    echo "Supported keywords: ${suported_keywords}"
    echo "Supported files: ${suported_files}"
    echo "Supported extensions: ${suported_extensions}"
fi


if [[ "$2" == "true" ]]; then
    session=main
    window=${session}:0
    new_pane=$(tmux list-panes | wc -l)
    pane=${window}.$new_pane
else
    echo $message_to_be_shown
    echo $comand_to_be_executed
    eval $comand_to_be_executed
    exit 0
fi

tmux neww bash -c "$comand_to_be_executed && while [ : ]; do sleep 1; done" 

# tmux split-window 
# tmux send-keys -t "$pane" "$comand_to_be_executed" Enter
