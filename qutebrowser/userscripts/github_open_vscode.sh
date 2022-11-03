#!/bin/sh

url=$(echo "$QUTE_URL" | sed 's/github/github1s/')
echo "open $url" >> "$QUTE_FIFO"
