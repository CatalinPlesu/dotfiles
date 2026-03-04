#!/bin/bash

git config --global alias.nuke '!git reset --hard && git clean -fd'

git config --global alias.nuke-all '!git reset --hard && git clean -idx'

git config --global alias.prune-local "!git fetch --prune && git branch -vv | grep ': gone]' | grep -v '*' | awk '{print \$1}' | xargs -r git branch -d"

git config --global alias.sync-dev '!f() { DEV=${1:-develop}; git fetch --prune && git checkout -B "$DEV" "origin/$DEV" && git reset --hard "origin/$DEV" && git branch | grep -v "$DEV" | xargs -r git branch -D; }; f'
