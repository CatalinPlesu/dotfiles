# Lines configured by zsh-newuser-install

# ✅ Ensure Zinit is installed and initialized correctly
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

if [[ ! -d $ZINIT_HOME ]]; then
  echo "Installing Zinit..."
  if bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"; then
    echo "Running initial Zinit self-update..."
    zsh -ic 'zinit self-update'
  else
    echo "❌ Zinit installation failed" >&2
  fi
fi

# Load Zinit
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  source "${ZINIT_HOME}/zinit.zsh"
else
  echo "❌ Zinit not found in $ZINIT_HOME" >&2
  return 1
fi

# Quick sanity check
if ! command -v zinit &>/dev/null; then
  echo "❌ zinit command not available after sourcing" >&2
  return 1
fi

# Run self-update to finalize installation
zinit self-update &>/dev/null || echo "⚠️ zinit self-update failed, proceed with caution"


setopt AUTO_CD
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -d /home/linuxbrew/.linuxbrew ] && eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

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

# eval "$(starship init zsh)"
PROMPT='%F{cyan}%3~%f > '

# . "$HOME/.cargo/env"

# eval "$(goenv init -)"

# . "$HOME/.atuin/bin/env"
eval "$(atuin init zsh)"
# eval "$(pyenv init --path)"

. "$HOME/.local/share/../bin/env"



zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-syntax-highlighting
