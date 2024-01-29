# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
bind 'set completion-ignore-case on'

set -o vi

source ~/.config/shell/env
source ~/.config/shell/alias

source ~/.config/shell/tty

eval "$(starship init bash)"

bind -x '"\C-l": clear'

alias cd='cdenv_func() { cd "$@" && if [ -f .env ]; then source .env; fi; }; cdenv_func'
