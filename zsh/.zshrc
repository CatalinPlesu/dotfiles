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

### Added by Zinit's installer
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33} %F{220}Installing %F{33}ZDHARMA-CONTINUUM%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33} %F{34}Installation successful.%f%b" || \
        print -P "%F{160} The clone has failed.%f%b"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
