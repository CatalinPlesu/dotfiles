#!/bin/sh

DIR="$HOME/.config/rofi"
FILE="$DIR/emojis.txt"


if [ "$@" ]
then
  smiley=$(echo $@ | cut -d' ' -f1)
  echo -n "$smiley" | xsel -bi
  exit 0
fi

cat $FILE
