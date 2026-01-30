-- Install Plugins
vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-lualine/lualine.nvim"
})


-- Vim Options
vim.g.mapleader = " "
vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.relativenumber = true
vim.opt.smoothscroll = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false 
vim.opt.undofile = true

-- Setup
vim.cmd([[colorscheme gruvbox]])

require("mason").setup()

require'nvim-treesitter'.setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}

require('lualine').setup {}

-- Set the directory where undo history is stored
-- This creates a 'undo' folder in your Neovim data directory
local undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.undodir = undodir

-- Create the directory if it doesn't exist
if vim.fn.isdirectory(undodir) == 0 then
    vim.fn.mkdir(undodir, "p")
end
