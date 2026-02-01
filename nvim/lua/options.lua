require "nvchad.options"

-- add yours here!

vim.opt.relativenumber = true

-- Number of lines to keep above and below the cursor
vim.opt.scrolloff = 10

-- Set the width of the line number column
vim.opt.numberwidth = 5

vim.o.scroll = 15

-- configer make
vim.g.dotnet_errors_only = true
vim.g.dotnet_show_project_file = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undofile = true                          -- persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/nvim/undo"
