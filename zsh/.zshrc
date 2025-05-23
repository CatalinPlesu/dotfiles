# Lines configured by zsh-newuser-install

setopt AUTO_CD
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -d /home/linuxbrew/.linuxbrew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

# Source plugins
for f in ~/.config/zsh/plugins/*; do source "$f"; done

autoload -U compinit && compinit -u
zstyle ':completion:*' menu select
# Auto complete with case insenstivity
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

zmodload zsh/complist
compinit
_comp_options+=(globdots)		# Include hidden files.

unsetopt BEEP
# vi mode
bindkey -v

# Enable searching through history
bindkey '^R' history-incremental-pattern-search-backward

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
# Fix backspace bug when switching modes
bindkey "^?" backward-delete-char

bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey -s '^e' 'nvim "$(fzf)"\n'

bindkey -s '^t' '\nthunar &\n'

# Yank to the system clipboard
function vi-yank-xclip {
   zle vi-yank
   echo "$CUTBUFFER" | xclip -sel clip
}
zle -N vi-yank-xclip

# Paste from the system clipboard
function vi-put-xclip {
   RBUFFER=$(xclip -sel clip -o)
   zle vi-put-before
}
zle -N vi-put-xclip

bindkey -M vicmd 'p' vi-put-xclip
bindkey -M vicmd 'y' vi-yank-xclip

# Source configs
source ~/.config/shell/alias
source ~/.config/shell/env
#sh ~/.config/shell/tty # zsh if is different ;(

source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# eval "$(starship init zsh)"
PROMPT='%F{cyan}%3~%f > '

# . "$HOME/.cargo/env"

# eval "$(goenv init -)"

# . "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
eval "$(pyenv init --path)"
