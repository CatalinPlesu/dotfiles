if status is-interactive
    # -------------------------------------------------------------------------
    # 1. Environment Variables
    # -------------------------------------------------------------------------
    set -gx EDITOR nvim
    set -gx TERMINAL ghostty
    set -gx BROWSER qutebrowser
    set -gx SUDO_EDITOR nvim

    # -------------------------------------------------------------------------
    # 2. PATH Additions
    # -------------------------------------------------------------------------
    fish_add_path ~/scripts
    fish_add_path ~/.atuin/bin
    fish_add_path ~/.local/bin

    # -------------------------------------------------------------------------
    # 3. Vi Mode & Bindings
    # -------------------------------------------------------------------------
    fish_vi_key_bindings
    
    bind -M default y 'fish_clipboard_copy'
    bind -M default p 'fish_clipboard_paste'
    bind -M insert \cy accept-autosuggestion
    bind -M default \cy accept-autosuggestion
    bind -M insert \cv edit_command_buffer
    bind -M default \cv edit_command_buffer

    # FZF / Utility Shortcuts
    bind -M insert \cf 'cd (dirname (fzf)); commandline -f repaint'
    bind -M insert \ce 'nvim (fzf); commandline -f repaint'
    bind -M insert \cz 'cd (cat ~/.z | cut -d "|" -f 1 | fzf); commandline -f repaint'
    bind -M insert \ct 'nautilus . >/dev/null 2>&1 &; commandline -f repaint'

    # -------------------------------------------------------------------------
    # 4. Aliases
    # -------------------------------------------------------------------------
    # System & Core
    alias ls='eza'
    alias l='ls -l'
    alias la='ls -a'
    alias lx='ls -lbhHigUmuSa@'
    alias lah='ls -lah'
    alias tree='eza -l --tree --level=2 --git-ignore --long --icons --git'
    alias grep='grep --color=auto'
    alias diff='diff --color'
    alias ip='ip --color=auto'

    alias cp="cp -iv"
    alias mv="mv -iv"
    alias rm="rm -iv"

    # Terminal & Editors
    alias b="btop"
    alias t='tmux new-session -A -s main'
    alias vi='nvim -u NONE'
    alias v='nvim'
    alias V='sudoedit'

    # Package Manager Shortcuts (Paru / Pacman)
    alias ss='paru -Ss'
    alias s='paru -S'
    alias syu='paru -Syu'

    # Git
    alias gst='git status'
    alias glt='git log --oneline --decorate --graph'
    alias glta='git log --graph --pretty=\'%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset\' --all'

    # -------------------------------------------------------------------------
    # 5. Tool Integrations
    # -------------------------------------------------------------------------
    type -q atuin; and atuin init fish | source
    type -q starship; and starship init fish | source
    type -q mise; and mise activate fish | source
    type -q zoxide; and zoxide init fish | source
end
