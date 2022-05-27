#!/bin/bash
# Create cover images from e-books in sub-directories
# This shell script is not recursive

# maximum width and height of the output image
maxsize="200x200"

mkdir -p "covers"
for directory in */;do
  if [ -d "$directory" ]; then
    echo "Processing sub-directory: "${directory%%/}
    for ebook in "${directory}"*.pdf; do
      ebook="$(basename "$ebook")"
      if [ ! -f "covers/${ebook%%.pdf}.png" -a -f "${directory}${ebook}" ]; then
        echo "  Processing e-book: $ebook"
        convert "${directory}${ebook}"[0] -resize $maxsize "covers/${ebook%%.pdf}.png" 2>/dev/null
      fi
    done
  fi
done
