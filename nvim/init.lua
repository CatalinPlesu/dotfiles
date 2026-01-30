-- Install Plugins
vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim"
})


-- Vim Options
vim.opt.clipboard = 'unnamedplus'
vim.g.mapleader = " "
vim.opt.number = true
vim.opt.relativenumber = true

-- Setup
vim.cmd([[colorscheme gruvbox]])
