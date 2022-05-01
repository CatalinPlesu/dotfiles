local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function(use)
     use 'gruvbox-community/gruvbox'; require('plugin.gruvbox')
     use 'tpope/vim-surround' 
     use 'tpope/vim-commentary'
     use 'lilydjwg/colorizer'
     use 'farmergreg/vim-lastplace'
     use 'wakatime/vim-wakatime' 
     use 'mbbill/undotree'; require('plugin.undotree')
     use 'preservim/nerdtree'; require('plugin.nerdtree')
    use 'iamcco/markdown-preview.nvim'
    use 'Chiel92/vim-autoformat'
    use 'jbyuki/instant.nvim'
    use 'vim-airline/vim-airline'
    use 'vim-airline/vim-airline-themes'
    use 'edkolev/tmuxline.vim'
    use 'tpope/vim-fugitive'
    use 'neovim/nvim-lspconfig'
    use 'skywind3000/asyncrun.vim'
    use 'folke/which-key.nvim'
    use 'nvim-treesitter/nvim-treesitter'
    use 'nvim-treesitter/nvim-treesitter'
    use 'DingDean/wgsl.vim'
    use 'gcollura/vim-masm'
    use 'https://github.com/adelarsq/vim-matchit'
    use 'vim-python/python-syntax'
    use 'junegunn/fzf'
    use 'junegunn/fzf.vim'
    use 'stsewd/fzf-checkout.vim'
    use 'farmergreg/vim-lastplace'
    use 'vimwiki/vimwiki' 

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
