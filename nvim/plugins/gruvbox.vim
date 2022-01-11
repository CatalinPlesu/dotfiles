Plug 'gruvbox-community/gruvbox'

augroup GruvboxAutogroup
    autocmd!
    autocmd User When_PlugLoaded ++nested colorscheme gruvbox
    " autocmd User When_PlugLoaded :source "$HOME/.local/share/nvim/plugged/gruvbox/gruvbox_256palette.sh"
augroup end
