-- Install Plugins
vim.pack.add({
	"https://github.com/ellisonleao/gruvbox.nvim",
	"https://github.com/mason-org/mason.nvim",
	"https://github.com/nvim-treesitter/nvim-treesitter",
	"https://github.com/nvim-lualine/lualine.nvim",
 	"https://github.com/jiaoshijie/undotree",
	"https://github.com/NeogitOrg/neogit",
	"https://github.com/nvim-lua/plenary.nvim", -- neogit
	"https://github.com/sindrets/diffview.nvim", -- neogit     
	"https://github.com/ibhagwan/fzf-lua", -- neogit
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

vim.keymap.set("n", "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", { desc = 'Undotree' })
vim.keymap.set("n", "<leader>gg", "<cmd>Neogit<cr>", { desc = "Open Neogit UI" })
