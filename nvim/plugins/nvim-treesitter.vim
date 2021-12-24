Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

function TreeSitterSetup()
    lua require'nvim-treesitter.configs'.setup { highlight = { enable = true }, incremental_selection = { enable = true }, textobjects = { enable = true }}
endfunction

augroup TreeSitterSetup
    autocmd!
    autocmd User When_PlugLoaded call TreeSitterSetup()
augroup END
