Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

function TreeSitterSetup()

    lua << END
    require'nvim-treesitter.configs'.setup {
        highlight = {
        enable = true
        },
    incremental_selection = { enable = true },
    textobjects = { enable = true }
    }
END
endfunction

augroup TreeSitterSetup
    autocmd!
    autocmd User When_PlugLoaded call TreeSitterSetup()
augroup END
