require("Comment").setup()

-- Comment.nvim
function ToggleComment()
  require('Comment.api').toggle.linewise.current()
end

-- -- Create a command for it
vim.api.nvim_create_user_command('ToggleComment', ToggleComment, {})

-- Map Ctrl-k followed by c to toggle comments
map("n", "<C-k>c", function() vim.cmd("ToggleComment") end, "Toggle comment")
map("n", "<C-k><C-c>", function() vim.cmd("ToggleComment") end, "Toggle comment")
