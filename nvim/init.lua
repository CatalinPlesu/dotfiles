-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.wo.wrap = false
vim.wo.linebreak = true
vim.opt.cursorline = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hlsearch = false
vim.opt.showmode = false
vim.opt.swapfile = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.hidden = true
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false
vim.opt.list = true
vim.opt.laststatus = 3
vim.opt.pumheight = 10
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.clipboard = "unnamed,unnamedplus"
if os.getenv("WAYLAND_DISPLAY") then
	vim.g.clipboard = {
		name = "wl-copy",
		copy = {
			["+"] = "wl-copy",
			["*"] = "wl-copy",
		},
		paste = {
			["+"] = { "wl-paste", "--no-newline" },
			["*"] = { "wl-paste", "--no-newline" },
		},
		cache_enabled = 0,
	}
end
vim.opt.colorcolumn = "90,120,160"
vim.opt.cursorline = true
vim.opt.cursorcolumn = true
vim.opt.undofile = true
local home = vim.fn.expand("$HOME") -- Retrieve the home directory
local undoDir = home .. "/.local/share/nvim/undodir"
vim.opt.undodir = undoDir
-- vim.opt.virtualedit = "all"
vim.opt.list = false
vim.opt.listchars = "eol:¶,tab:<->,space:°,trail:°,extends:>,precedes:<"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- Basic mappings
vim.keymap.set("n", "<C-H>", "<C-W><C-H>")
vim.keymap.set("n", "<C-J>", "<C-W><C-J>")
vim.keymap.set("n", "<C-K>", "<C-W><C-K>")
vim.keymap.set("n", "<C-L>", "<C-W><C-L>")
vim.keymap.set("n", "<C-S>", ":%s/")
vim.keymap.set("n", "sp", ":sp<CR>")
vim.keymap.set("n", "tj", ":tabprev<CR>")
vim.keymap.set("n", "tk", ":tabnext<CR>")
vim.keymap.set("n", "tn", ":tabnew<CR>")
vim.keymap.set("n", "to", ":tabo<CR>")
vim.keymap.set("n", "td", ":diffthis<CR>")
vim.keymap.set("n", "vs", ":vs<CR>")
vim.keymap.set("n", "CC", ":ClipboardCompare<CR>")
vim.keymap.set("n", "j", "gj")
vim.keymap.set("n", "k", "gk")
vim.keymap.set("n", "<leader>j", ":cnext<CR>", { silent = true })
vim.keymap.set("n", "<leader>k", ":cprevious<CR>", { silent = true })
-- Remap '<' in visual mode to reselect the last visual selection
vim.api.nvim_set_keymap("x", "<", "<gv", { noremap = true, silent = true })
-- Remap '>' in visual mode to reselect the last visual selection
vim.api.nvim_set_keymap("x", ">", ">gv", { noremap = true, silent = true })

-- Setup lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
	-- Create directories if they are missing when saving files
	"jghauser/mkdir.nvim",

	-- Mini plugins
	{
		"echasnovski/mini.nvim",
		version = "*",
		init = function()
			-- Move lines
			require("mini.ai").setup()
			require("mini.move").setup()
		end,
	},

	-- Easy commenting in normal & visual mode
	{ "numToStr/Comment.nvim", lazy = false },


	-- Fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>w", "<cmd>Telescope grep_string<cr>", desc = "Grep string" },
			{ "<leader>b", "<cmd>Telescope buffers<cr>",     desc = "Buffers" },
			{ "<leader>f", "<cmd>Telescope find_files<cr>",  desc = "Find files" },
			{ "<leader>s", "<cmd>Telescope live_grep<cr>",   desc = "Live grep" },
			{ "<leader>r", "<cmd>Telescope resume<cr>",      desc = "Resume search" },
		},
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},

	-- Better syntax highlighting & much more
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local configs = require("nvim-treesitter.configs")

			configs.setup({
				ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				indent = {
					enable = true,
				},
			})
		end,
	},

	-- Colorscheme Gruvbox
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme gruvbox]])
		end,
		opts = ...,
	},

	-- Lualine
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Undotree
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},

	-- Quick navigate through files
	{
		"ggandor/leap.nvim",
		config = function()
			vim.keymap.set({ "n" }, "f", "<Plug>(leap-forward)")
			vim.keymap.set({ "n" }, "F", "<Plug>(leap-backward)")
		end,
	},

	-- Surround words with characters in normal mode
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	}
})
-- Set up Comment.nvim
require("Comment").setup()

-- Set up Lualine
require("lualine").setup({
	options = { theme = "gruvbox" },
})

-- Global LSP mappings
vim.keymap.set("n", "<space>e", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- More LSP mappings
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>.", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "gf", vim.lsp.buf.format, opts)
		vim.keymap.set("n", "ge", vim.diagnostic.open_float, opts)
	end,
})

-- Define a custom command in your `init.lua` or a plugin
vim.api.nvim_create_user_command('ClipboardCompare', function()
  vim.cmd('diffthis')
  vim.cmd('vsplit')
  vim.cmd('e clipboard')  -- Open the clipboard as a file
  vim.cmd('normal! P')  -- Paste clipboard contents
  vim.cmd('diffthis')
end, { desc = 'Compare clipboard contents in a vertical split with the current buffer' })

-- Open Telescope on start
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argv(0) == "" then
			require("telescope.builtin").find_files()
		end
	end,
})

