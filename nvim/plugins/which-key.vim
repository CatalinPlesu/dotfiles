Plug 'folke/which-key.nvim'

function WhichKeySetup()
lua << EOF
require("which-key").setup {}
EOF
endfunction

augroup WhichKeySetup
    autocmd!
    autocmd User When_PlugLoaded call WhichKeySetup()
augroup END
