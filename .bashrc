# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
bind 'set completion-ignore-case on'

export PATH=/home/catalin/scripts:$PATH

set -o vi

RESET='\[\033[00m\]'
LRED='\[\033[01;31m\]'
LYELLOW='\[\033[01;33m\]'
LGREEN='\[\033[01;32m\]'
LBLUE='\[\033[01;34m\]'
LPURPLE='\[\033[01;35m\]'
PS1="${RESET}${LRED}[${LYELLOW}c${LGREEN}a${LBLUE}t${LPURPLE}a${LRED}l${LYELLOW}i${LGREEN}n${LPURPLE} \W${LRED}]${RESET} "

source ~/.config/sh/alias

pfetch
