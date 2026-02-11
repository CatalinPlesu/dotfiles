#!/bin/bash

git config --global alias.nuke '!git reset --hard && git clean -fd'

git config --global alias.nuke-all '!git reset --hard && git clean -idx'

git config --global alias.prune-local "!git fetch --prune && git branch -vv | grep ': gone]' | grep -v '*' | awk '{print \$1}' | xargs -r git branch -d"
