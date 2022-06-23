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

if [[ "$executed" == "false" ]]; then
    for line in "${present_keywords[@]}"; do
        keyword=$(echo $line | awk '{print $1}')
        suported_keywords="$suported_keywords$keyword; "
        comand=$(echo $line| sed "s/^[^ ]* //")
        if grep "$keyword" $file_ext ; then
            executed="true"
            echo "Keyword detected: $keyword"
            echo $comand
            eval " $comand"
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
            echo "File detected: $filename"
            echo $comand
            eval " $comand"
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
            echo "Extension detected: $ext"
            echo $comand
            eval " $comand"
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
