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
	"https://github.com/wakatime/vim-wakatime",
	"https://github.com/HakonHarnes/img-clip.nvim",
	"https://github.com/3rd/image.nvim",
    "https://github.com/echaya/neowiki.nvim",
    "https://github.com/folke/todo-comments.nvim",
    "https://github.com/OXY2DEV/markview.nvim",
    "https://github.com/nvim-treesitter/nvim-treesitter", -- markview
    "https://github.com/nvim-tree/nvim-web-devicons", -- markview
    "https://github.com/folke/which-key.nvim",
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
vim.opt.tabstop = 4       -- A tab character looks like 4 spaces
vim.opt.shiftwidth = 4    -- Size of an indent
vim.opt.softtabstop = 4   -- Number of spaces tabs count for in insert mode
vim.opt.expandtab = true  -- Use spaces instead of tabs
vim.opt.autoindent = true -- Copy indent from current line when starting new line

-- Setup
vim.cmd([[colorscheme gruvbox]])

require("mason").setup()

require'nvim-treesitter'.setup {
  install_dir = vim.fn.stdpath('data') .. '/site'
}

-- Expand the path ONCE at startup (outside the timer context)
local waka_bin = vim.fn.expand("~/.wakatime/wakatime-cli")
local waka_time = ""

local function update_waka()
    local stdout = vim.uv.new_pipe(false)
    local handle
    
    -- Now we use the pre-expanded 'waka_bin' string
    handle, _ = vim.uv.spawn(waka_bin, {
        args = { "--today" },
        stdio = { nil, stdout, nil },
    }, function(code)
        if handle then handle:close() end
    end)

    if not handle then
        -- This usually means the file doesn't exist at the expanded path
        waka_time = "bin error"
        return
    end

    vim.uv.read_start(stdout, function(err, data)
        if data then
            vim.schedule(function()
                local h = data:match("(%d+)%s*hrs") or "0"
                local m = data:match("(%d+)%s*mins") or "0"
                waka_time = h .. "h " .. m .. "m"
            end)
        end
        vim.uv.read_stop(stdout)
    end)
end

-- Update every 5 minutes
local timer = vim.uv.new_timer()
timer:start(0, 300000, function()
    update_waka()
end)

require('lualine').setup {
sections = {
    lualine_a = {'mode',},
    lualine_b = {'branch', 'diff', 'diagnostics',},
    lualine_c = { 'filename' },
    lualine_x = {'encoding', 'fileformat', 'filetype',
    {
      function()
        return waka_time ~= "" and ("󱑎 " .. waka_time) or ""
      end,
      color = { fg = '#9ece6a' },
    },
},
    lualine_y = {'progress',},
    lualine_z = {'location',},
  },
}

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
vim.keymap.set("n", "<leader>p", "<cmd>PasteImage<cr>", { desc = "Paste image from system clipboard" })


require("image").setup({
  backend = "kitty", 
  processor = "magick_cli", 
  tmux_show_only_in_active_window = true, 
})


require("neowiki").setup({
    wiki_dirs = {
        { name = "Echo", path = "~/Documents/wiki/echo/" },
        { name = "Vault", path = "~/Documents/Notes/" },
    },
})

vim.keymap.set("n", "<leader>ww", function() require('neowiki').open_wiki('Echo') end, { desc = "Open Wiki - Echo" })
vim.keymap.set("n", "<leader>ws", function() require('neowiki').open_wiki() end, { desc = "Open Wiki - All" })


require("fzf-lua").setup {
  winopts = { 
	height = 0.85,
				width = 0.80,
				preview = {
					scrollbar = "float",
				},
        },     
}
vim.keymap.set("n", "<leader>ff", "<cmd>FzfLua files<CR>", {desc = "Find files" })
vim.keymap.set("n", "<leader>fg", "<cmd>FzfLua live_grep<CR>", {desc = "Live grep" })
vim.keymap.set("n", "<leader>fb", "<cmd>FzfLua buffers<CR>", {desc = "Find buffers" })
vim.keymap.set("n", "<leader>fh", "<cmd>FzfLua help_tags<CR>", {desc = "Help tags" })
vim.keymap.set("n", "<leader>fo", "<cmd>FzfLua oldfiles<CR>", {desc = "Recent files" })
vim.keymap.set("n", "<leader>fw", "<cmd>FzfLua grep_cword<CR>", {desc = "Find word" })
vim.keymap.set("n", "<leader>fc", "<cmd>FzfLua commands<CR>", {desc = "Commands" })
vim.keymap.set("n", "<leader>fk", "<cmd>FzfLua keymaps<CR>", {desc = "Keymaps" })
vim.keymap.set("n", "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", {desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>", {desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>/", "<cmd>FzfLua blines<CR>", {desc = "Buffer lines" })
vim.keymap.set("n", "<leader><leader>", "<cmd>FzfLua buffers<CR>", {desc = "Buffers" })
