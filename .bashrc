# ~/.bashrc
# If not running interactively, don't do anything
[[ $- != *i* ]] && return
bind 'set completion-ignore-case on'
if [ $TERM = 'linux' ]
then
bind -x '"\C-x":startx'
fi

bind -x '"\C-l":clear'
RESET='\[\033[00m\]'
LRED='\[\033[01;31m\]'
LYELLOW='\[\033[01;33m\]'
LGREEN='\[\033[01;32m\]'
LBLUE='\[\033[01;34m\]'
LPURPLE='\[\033[01;35m\]'
PS1="${RESET}${LRED}[${LYELLOW}c${LGREEN}a${LBLUE}t${LPURPLE}a${LRED}l${LYELLOW}i${LGREEN}n${LPURPLE} \W${LRED}]${RESET} "

alias ls='lsd'
alias la='lsd -a'
alias grep='grep --color=auto'
alias s='sudo pacman -S' 
alias ss='pacman -Ss'
alias i='pacman -Si'
alias r='sudo pacman -Rsn'
alias y='yay -S'
alias ar='sudo pacman -Rcns $(pacman -Qdtq)'
alias ad='git add'
alias st='git status'

pfetch
