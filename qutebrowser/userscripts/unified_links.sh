#!/bin/sh
bookmarks_dir="/home/$(whoami)/.config/qutebrowser/bookmarks/"
alias ls='ls --ignore={"urls",""}' # blacklist files

while getopts soOrf:u: name
do
    case $name in
    s)    s_flag=1;;
    o)    o_flag=1;;
    O)    O_flag=1;;
    r)    r_flag=1;;
    f)    file_flag=1
          file_val="$OPTARG";;
    ?)   printf "Usage: %s: [-s] [-o] [-O] [-r] [-f file]\n" $0
          exit 2;;
    esac
done

# save
if [ ! -z "$s_flag" ]; then
    if [ -z "$file_flag" ]; then
        file_val=$(ls $bookmarks_dir | rofi -dmenu -p "save link in")
    fi

    if ! [ -f $file_val ]; then
        echo "$QUTE_URL" >> "$bookmarks_dir$file_val"
    fi
fi

# open
if [ ! -z "$O_flag" ] || [ ! -z "$o_flag" ]; then
    if [ ! -z "$o_flag" ]; then
        tab_val=""
    else
        tab_val="-t"
    fi

    if [ -z "$file_flag" ] || [ ! -f "$bookmarks_dir$file_val" ]; then
        file_val=$(ls $bookmarks_dir | rofi -dmenu -p "open")
    fi

    if ! [ -f $file_val ]; then
        url_val=$(cat $bookmarks_dir$file_val | rofi -dmenu -p $file_val)
    fi

    if ! [ -f $url_val ]; then
        echo "open $tab_val $url_val" >> "$QUTE_FIFO"
    fi
fi

# remove
if [ ! -z "$r_flag" ]; then
    # this require rg
    file_path=$(rg -l "$QUTE_URL" "$bookmarks_dir")
    if [ ! -z "$file_path" ]; then
        sed -i "s|$QUTE_URL||g" $file_path
        sed -i "/^$/d" $file_path
    fi
fi
