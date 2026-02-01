return {
  {"ellisonleao/gruvbox.nvim"},
	{
		"ramboe/ramboe-dotnet-utils",
		dependencies = { "mfussenegger/nvim-dap" },
	},
	{
		"seblyng/roslyn.nvim",
		---@module 'roslyn.config'
		---@type RoslynNvimConfig
		ft = { "cs", "razor" },
	},
	{
		"ibhagwan/fzf-lua",
		-- optional for icon support
		dependencies = { "nvim-tree/nvim-web-devicons" },
		-- or if using mini.icons/mini.nvim
		-- dependencies = { "echasnovski/mini.icons" },
		opts = {},
	},
	{
		"stevearc/conform.nvim",
		event = "BufWritePre", -- uncomment for format on save
		config = function()
			require("configs.conform")
		end,
	},

	-- These are some examples, uncomment them if you want to see them work!
	{ "akinsho/git-conflict.nvim", version = "*", config = true },
	{
		"neovim/nvim-lspconfig",
		config = function()
			require("nvchad.configs.lspconfig").defaults()
			require("configs.lspconfig")
		end,
	},
	{
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "VeryLazy", -- Or `LspAttach`
		priority = 1000, -- needs to be loaded in first
		config = function()
			require("configs.tiny-inline-diagnostic")
		end,
	},
	{
		"williamboman/mason.nvim",
		opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:crashdummyy/mason-registry",
			},
			ensure_installed = {
				"lua-language-server",
				"xmlformatter",
				"stylua",
				"bicep-lsp",
				"html-lsp",
				"css-lsp",
				"eslint-lsp",
				"typescript-language-server",
				"csharpier",
				"prettier",
				"json-lsp",
				"yaml-language-server",
				"markdown-oxide",

				-- for some reason those have to be installed explicitely with MasonInstall
				"roslyn",
				"netcoredbg",
			},
		},
	},

	{
		"nvim-treesitter/nvim-treesitter",
		opts = {
			ensure_installed = {
				"hyprlang",
				"vim",
				"lua",
				"vimdoc",
				"html",
				"css",
				"c_sharp",
				"bicep",
				"razor",
				"yaml",
				"caddy",
			},
		},
	},
	{
		"numToStr/Comment.nvim",
		lazy = false,
		opts = {
			toggler = {
				---Line-comment toggle keymap
				line = "gcc",
				---Block-comment toggle keymap
				block = "gbc",
			},
		},
	},
	{
		-- Debug Framework
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
		},
		-- config = function()
		--   require "custom-config.nvim-dap"
		-- end,
		event = "VeryLazy",
	},
	{ "nvim-neotest/nvim-nio" },
	{
		-- UI for debugging
		"rcarriga/nvim-dap-ui",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		-- config = function()
		--   require "custom-config.nvim-dap-ui"
		-- end,
	},
	{
		"stevearc/oil.nvim",
		opts = {},
		-- Optional dependencies
		dependencies = { { "echasnovski/mini.icons", opts = {} } },
		-- dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
	},

	{
		"L3MON4D3/LuaSnip",
		lazy = false,
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",
		dependencies = { "rafamadriz/friendly-snippets" },
	},
	{
		"nvim-neotest/neotest",
		requires = {
			{
				"Issafalcon/neotest-dotnet",
			},
		},
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
		},
	},
	{
		"Issafalcon/neotest-dotnet",
		lazy = false,
		dependencies = {
			"nvim-neotest/neotest",
		},
	},
	{ "smithbm2316/centerpad.nvim" },
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"ibhagwan/fzf-lua",
		},
		cmd = "Neogit",
		keys = {
			{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Neogit" },
			{ "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Commit" },
			{ "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Pull" },
			{ "<leader>gP", "<cmd>Neogit push<CR>", desc = "Push" },
		},
		opts = {
			integrations = {
				fzf_lua = true,
				diffview = true,
			},
		},
	},



	-- ========================================================================
	-- UTILITIES
	-- ========================================================================
	{
		"folke/todo-comments.nvim",
		event = "VimEnter",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
	{
		"echaya/neowiki.nvim",
		opts = {
			wiki_dirs = {
				{ name = "Echo", path = "~/Documents/wiki/echo/" },
				{ name = "Vault", path = "~/Documents/Notes/" },
			},
		},
		keys = {
			{ "<leader>ww", "<cmd>lua require('neowiki').open_wiki('Echo')<cr>", desc = "Open Wiki" },
			{ "<leader>ws", "<cmd>lua require('neowiki').open_wiki()<cr>", desc = "Open Wiki" },
		},
	},
	{
		"HakonHarnes/img-clip.nvim",
		event = "VeryLazy",
		opts = {
			-- add options here
			-- or leave it empty to use the default settings
		},
		keys = {
			-- suggested keymap
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Paste image from system clipboard" },
		},
	},
	{
		"3rd/image.nvim",
		build = false, -- so that it doesn't build the rock https://github.com/3rd/image.nvim/issues/91#issuecomment-2453430239
    ft = { "md", "markdown" },
		opts = {
			backend = "kitty",
			processor = "magick_cli",
			tmux_show_only_in_active_window = true,
		},
	},
	{ "wakatime/vim-wakatime", lazy = false },
	{
		"OXY2DEV/markview.nvim",
		lazy = false, -- Recommended by the author for stable rendering
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons", -- or "echasnovski/mini.icons"
		},
		opts = {
			-- This section makes it behave like render-markdown
			modes = { "n", "i", "no", "c" }, -- Modes where the plugin is active
			hybrid_modes = { "i" }, -- Enable "unconceal under cursor" in Insert mode

			-- Optional: Match the "look" of render-markdown
			callbacks = {
				on_enable = function(_, win)
					vim.wo[win].conceallevel = 2
				end,
			},
		},
	},
}
