require "nvchad.mappings"

-- add yours here

-- override nvchad.mappings here
require("custom-mappings.mappings-fzflua")
require("custom-mappings.mappings-lsp")

map("n", ";", ":",  "CMD enter command mode" )
map("i", "jk", "<ESC>", "Go normal mode")

-- map('v', '<leader>as', ':Gen Summarize_Function<CR>')

map("n", ";", ":", { desc = "CMD enter command mode" })
map('i', '<C-h>', '<C-w>') -- CTRL+backspace

-- Add a keymap for Shift+Tab to switch to the previous buffer
map("n", "<S-Tab>", ":b#<CR>", opts)

-- PLUGIN MAPPINGS


-- Show File in Tree
map("n", "<leader>e", "<cmd>ShowFileInTree<CR>", opts)
