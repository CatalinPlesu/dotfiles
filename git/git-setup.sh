#!/bin/bash

git config --global alias.nuke '!git reset --hard && git clean -fd'

git config --global alias.nuke-all '!git reset --hard && git clean -idx'
