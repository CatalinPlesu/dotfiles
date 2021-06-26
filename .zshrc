# Lines configured by zsh-newuser-install
HISTFILE=~/.cache/zsh/histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -v
# End of lines configured by zsh-newuser-install

pfetch

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Enable colors and change prompt:
autoload -U colors && colors

# Source configs
for f in ~/.config/sh/*; do source "$f"; done

# Source plugins
for f in ~/.config/zsh/*; do source "$f"; done

autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

EDITOR='nvim'
# vi mode
bindkey -v

# Edit line in vim buffer ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line
# Enter vim buffer from normal mode
autoload -U edit-command-line && zle -N edit-command-line && bindkey -M vicmd "^v" edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'left' vi-backward-char
bindkey -M menuselect 'down' vi-down-line-or-history
bindkey -M menuselect 'up' vi-up-line-or-history
bindkey -M menuselect 'right' vi-forward-char
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select


export STARSHIP_CONFIG=~/.config/starship/config.toml
if [ $TERM != "linux" ]
then
eval "$(starship init zsh)"
fi
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
