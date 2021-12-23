Plug 'gruvbox-community/gruvbox'

augroup GruvboxAutogroup
    autocmd!
    autocmd User When_PlugLoaded ++nested colorscheme gruvbox
augroup end
