#!/usr/bin/env zsh
# ============================================================================
# ZSH Configuration - Optimized for Speed
# ============================================================================

# ----------------------------------------------------------------------------
# Performance Profiling (Comment out after optimization)
# ----------------------------------------------------------------------------
# zmodload zsh/zprof

# ----------------------------------------------------------------------------
# Zinit Plugin Manager Setup
# ----------------------------------------------------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Install Zinit if not present
if [[ ! -d $ZINIT_HOME ]]; then
  echo "📦 Installing Zinit..."
  if bash -c "$(curl --fail --silent --show-error --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"; then
    echo "✅ Running initial Zinit self-update..."
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

# Verify Zinit is available
if ! command -v zinit &>/dev/null; then
  echo "❌ zinit command not available after sourcing" >&2
  return 1
fi

# One-time self-update check
ZINIT_UPDATE_FILE="${TMPDIR:-/tmp}/zinit_last_update"
if [[ ! -f "$ZINIT_UPDATE_FILE" ]]; then
  zinit self-update &>/dev/null || echo "⚠️  zinit self-update failed"
  touch "$ZINIT_UPDATE_FILE"
fi

# ----------------------------------------------------------------------------
# Shell Options
# ----------------------------------------------------------------------------
setopt AUTO_CD              # Auto cd when typing directory name
unsetopt BEEP              # Disable beep on errors

# Early exit for non-interactive shells
[[ $- != *i* ]] && return

# ----------------------------------------------------------------------------
# Vi Mode Configuration
# ----------------------------------------------------------------------------
bindkey -v

# Enhance vi mode with useful shortcuts
bindkey '^R' history-incremental-pattern-search-backward
bindkey "^?" backward-delete-char

# Edit command line in vim
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey '^v' edit-command-line
bindkey -M vicmd '^v' edit-command-line

# ----------------------------------------------------------------------------
# FZF Integration Shortcuts
# ----------------------------------------------------------------------------
bindkey -s '^f' 'cd "$(dirname "$(fzf)")"\n'
bindkey -s '^e' 'nvim "$(fzf)"\n'
bindkey -s '^z' 'cd "$(cat ~/.z | cut -d "|" -f 1 | fzf)"\n'
bindkey -s '^t' '\nnautilus . &\n'

# ----------------------------------------------------------------------------
# System Clipboard Integration (Vi Mode)
# ----------------------------------------------------------------------------
function vi-yank-xclip {
   zle vi-yank
   echo "$CUTBUFFER" | xclip -sel clip
}
zle -N vi-yank-xclip

function vi-put-xclip {
   RBUFFER=$(xclip -sel clip -o)
   zle vi-put-before
}
zle -N vi-put-xclip

bindkey -M vicmd 'y' vi-yank-xclip
bindkey -M vicmd 'p' vi-put-xclip

# ----------------------------------------------------------------------------
# External Configurations
# ----------------------------------------------------------------------------
. /home/catalin/.nix-profile/etc/profile.d/nix.sh
source ~/.config/shell/alias
source ~/.config/shell/env

# ----------------------------------------------------------------------------
# Zinit Plugins - Optimized Loading
# ----------------------------------------------------------------------------

# Base completions (must load before compinit)
zinit ice lucid
zinit light zsh-users/zsh-completions

# Asynchronous plugins (load after prompt)
zinit ice wait'0' lucid
zinit light zsh-users/zsh-autosuggestions

zinit ice wait'0' lucid
zinit light zsh-users/zsh-syntax-highlighting

# Bind autosuggestion accept key
bindkey '^y' autosuggest-accept

# Simple plugins (no wait needed)
zinit light agkozak/zsh-z
zinit light fdellwing/zsh-bat

# ----------------------------------------------------------------------------
# Completion System - Optimized with Time-Based Caching
# ----------------------------------------------------------------------------
autoload -Uz compinit

ZSH_COMPDUMP="${XDG_CACHE_HOME:-${HOME}/.cache}/zsh/zcompdump"
mkdir -p "$(dirname "$ZSH_COMPDUMP")"

# Rebuild completions only once per day
# This is the key optimization - avoids expensive compaudit checks
if [[ -f "$ZSH_COMPDUMP" && -n "$ZSH_COMPDUMP"(#qNmh-24) ]]; then
    # Cache is less than 24 hours old, skip security audit
    compinit -C -d "$ZSH_COMPDUMP"
else
    # Cache is stale or missing, rebuild with audit
    compinit -d "$ZSH_COMPDUMP"
fi

# Completion styles
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
_comp_options+=(globdots)  # Include hidden files

# ----------------------------------------------------------------------------
# Tool Integrations
# ----------------------------------------------------------------------------

# Atuin - shell history
eval "$(atuin init zsh)"

# Starship prompt (load at end for fastest prompt appearance)
eval "$(starship init zsh)"

# ----------------------------------------------------------------------------
# Performance Profiling Output (Comment out after optimization)
# ----------------------------------------------------------------------------
# zprof

# ============================================================================
# End of Configuration
# ============================================================================
# 
# To force rebuild completions: rm ~/.cache/zsh/zcompdump
# To profile startup time: uncomment zprof lines at top and bottom
# ============================================================================

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk
eval "$(/home/catalin/.local/bin/mise activate zsh)"
