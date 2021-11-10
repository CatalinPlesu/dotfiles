#!/bin/sh

DIR="$HOME/.config/rofi"
EMOJI="$DIR/emojis.txt"
JP="$DIR/jp.txt"
KAOMOJI="$DIR/kaomoji.txt"
MATH="$DIR/math.txt"

if [ "$@" ]
then
  smiley=$(echo $@ | cut -d' ' -f1)
  echo -n "$smiley" | xsel -bi
  exit 0
fi

cat $EMOJI $JP $KAOMOJI $MATH
