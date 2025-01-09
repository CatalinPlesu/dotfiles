-- Basic settings
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.wo.wrap = false
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
	-- Automatic indentation
	"tpope/vim-sleuth",

	-- Create directories if they are missing when saving files
	"jghauser/mkdir.nvim",

	"eandrju/cellular-automaton.nvim",

	-- Zen mode, distraction free
	{
		"folke/zen-mode.nvim",
		init = function()
			vim.keymap.set("n", "<leader>Z", ":ZenMode<CR>")
		end,
		opts = {
			window = {
				backdrop = 0.95, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
				-- height and width can be:
				-- * an absolute number of cells when > 1
				-- * a percentage of the width / height of the editor when <= 1
				-- * a function that returns the width or the height
				width = 80, -- width of the Zen window
				height = 1, -- height of the Zen window
				-- by default, no options are changed for the Zen window
				-- uncomment any of the options below, or add other vim.wo options you want to apply
				options = {
					signcolumn = "no", -- disable signcolumn
					number = false, -- disable number column
					relativenumber = false, -- disable relative numbers
					cursorline = false, -- disable cursorline
					cursorcolumn = false, -- disable cursor column
					foldcolumn = "0", -- disable fold column
					list = false, -- disable whitespace characters
				},
			},
			plugins = {
				-- disable some global vim options (vim.o...)
				-- comment the lines to not apply the options
				options = {
					enabled = true,
					ruler = false, -- disables the ruler text in the cmd line area
					showcmd = false, -- disables the command in the last line of the screen
					-- you may turn on/off statusline in zen mode by setting 'laststatus'
					-- statusline will be shown only if 'laststatus' == 3
					laststatus = 0, -- turn off the statusline in zen mode
				},
				twilight = { enabled = true }, -- enable to start Twilight when zen mode opens
				gitsigns = { enabled = false }, -- disables git signs
				tmux = { enabled = true }, -- disables the tmux statusline
				-- this will change the font size on kitty when in zen mode
				-- to make this work, you need to set the following kitty options:
				-- - allow_remote_control socket-only
			},
			-- callback where you can add custom code when the Zen window opens
			on_open = function(win) end,
			-- callback where you can add custom code when the Zen window closes
			on_close = function() end,
		},
	},

	-- Twilight, fade unfocused text
	{
		"folke/twilight.nvim",
		opts = {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		},
	},

	-- Mini plugins
	{
		"echasnovski/mini.nvim",
		version = "*",
		init = function()
			-- Move lines
			require("mini.move").setup()
		end,
	},

	-- Git & GitHub plugins
	"tpope/vim-rhubarb",
	{
		"tpope/vim-fugitive",
		init = function()
			vim.keymap.set("n", "<leader>G", ":Git<CR>")
		end,
	},

	-- Better quickfix lists
	"kevinhwang91/nvim-bqf",

	-- Autoclose HTML-style tags
	"windwp/nvim-ts-autotag",

	-- Easy commenting in normal & visual mode
	{ "numToStr/Comment.nvim", lazy = false },

	-- LSP
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "williamboman/mason.nvim", config = true },
			"williamboman/mason-lspconfig.nvim",
		},
	},

	-- Autocompletion
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
		},
	},

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
				ensure_installed = "all",
				highlight = { enable = true },
				indent = {
					enable = true,
					disable = {
						"dart",
					}
				},
				autotag = { enable = true, enable_close_on_slash = false },
			})
		end,
	},

	-- Rascal MPL syntax
	"olistrik/vim-rascal-syntax",

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

	-- Will use wakapi as alternative, selfhosted
	{
		"wakatime/vim-wakatime",
	},

	-- Quick navigate through files
	{
		"ggandor/leap.nvim",
		config = function()
			vim.keymap.set({ "n" }, "f", "<Plug>(leap-forward)")
			vim.keymap.set({ "n" }, "F", "<Plug>(leap-backward)")
		end,
	},

	-- Tree file explorer
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		config = function()
			require("nvim-tree").setup({
				update_focused_file = { enable = true },
				vim.keymap.set("n", "<leader>n", ":NvimTreeToggle<CR>"),
			})
		end,
	},

	-- Align text
	{
		"Vonr/align.nvim",
		branch = "v2",
		lazy = true,
		init = function()
			local NS = { noremap = true, silent = true }

			-- Aligns to 1 character
			vim.keymap.set("x", "aa", function()
				require("align").align_to_char({
					length = 1,
				})
			end, NS)

			-- Aligns to 2 characters with previews
			vim.keymap.set("x", "ad", function()
				require("align").align_to_char({
					preview = true,
					length = 2,
				})
			end, NS)

			-- Aligns to a string with previews
			vim.keymap.set("x", "aw", function()
				require("align").align_to_string({
					preview = true,
					regex = false,
				})
			end, NS)

			-- Aligns to a Vim regex with previews
			vim.keymap.set("x", "ar", function()
				require("align").align_to_string({
					preview = true,
					regex = true,
				})
			end, NS)
		end,
	},

	-- Surround words with characters in normal mode
	{
		"kylechui/nvim-surround",
		event = "VeryLazy",
		opts = {},
	},

	-- For formatting code
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		opts = {
			formatters_by_ft = {
				javascript = { "prettierd" },
				json = { "prettierd" },
				css = { "prettierd" },
				lua = { "stylua" },
				cs = { "omnisharp" },
				css = { "prettier" },
				dart = { "dart_format" }, -- this is a script, which passes arguments to dart format
			},
			format_on_save = {},
		},
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
		end,
	},

	-- Pair matching characters
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		opts = {
			disable_filetype = { "TelescopePrompt", "vim" },
		},
	},

	-- Gitsigns
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				on_attach = function(bufnr)
					local gs = package.loaded.gitsigns

					local function map(mode, l, r, opts)
						opts = opts or {}
						opts.buffer = bufnr
						vim.keymap.set(mode, l, r, opts)
					end

					-- Navigation
					map("n", "]c", function()
						if vim.wo.diff then
							return "]c"
						end
						vim.schedule(function()
							gs.next_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					map("n", "[c", function()
						if vim.wo.diff then
							return "[c"
						end
						vim.schedule(function()
							gs.prev_hunk()
						end)
						return "<Ignore>"
					end, { expr = true })

					-- Actions
					map("n", "<leader>hs", gs.stage_hunk)
					map("n", "<leader>hr", gs.reset_hunk)
					map("v", "<leader>hs", function()
						gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("v", "<leader>hr", function()
						gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
					end)
					map("n", "<leader>hS", gs.stage_buffer)
					map("n", "<leader>hu", gs.undo_stage_hunk)
					map("n", "<leader>hR", gs.reset_buffer)
					map("n", "<leader>hp", gs.preview_hunk)
					map("n", "<leader>hb", function()
						gs.blame_line({ full = true })
					end)
					map("n", "<leader>tb", gs.toggle_current_line_blame)
					map("n", "<leader>hd", gs.diffthis)
					map("n", "<leader>hD", function()
						gs.diffthis("~")
					end)
					map("n", "<leader>td", gs.toggle_deleted)

					-- Text object
					map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>")
				end,
			})
		end,
	},

	-- Acerial outline
	{
		'stevearc/aerial.nvim',
		opts = {},
		-- Optional dependencies
		dependencies = {
			"nvim-treesitter/nvim-treesitter",
			"nvim-tree/nvim-web-devicons"
		},
		init = function()
			require("aerial").setup({
				on_attach = function(bufnr)
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
			vim.keymap.set("n", "<leader>a", "<cmd>AerialToggle!<CR>")
		end,
	}
})
-- Set up Comment.nvim
require("Comment").setup()

-- Set up Lualine
require("lualine").setup({
	options = { theme = "gruvbox" },
})

-- Open Telescope on start
vim.api.nvim_create_autocmd("VimEnter", {
	callback = function()
		if vim.fn.argv(0) == "" then
			require("telescope.builtin").find_files()
		end
	end,
})

-- Set up Mason and install set up language servers
require("mason").setup()
require("mason-lspconfig").setup()

local capabilities = require("cmp_nvim_lsp").default_capabilities()

require("mason-lspconfig").setup_handlers({
	function(server_name)
		require("lspconfig")[server_name].setup({
			capabilities = capabilities,
		})
	end,
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

-- Set up nvim-cmp
local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local luasnip = require("luasnip")
local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			luasnip.lsp_expand(args.body)
		end,
	},
	mapping = cmp.mapping.preset.insert({
		["<C-Space>"] = cmp.mapping.complete(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Replace,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			else
				fallback()
			end
		end, { "i", "s" }),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
			else
				fallback()
			end
		end, { "i", "s" }),
	}),
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
	},
})

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-- cellular-automaton custom animation
local slide = {
	fps = 40,
	name = "slide",
}

-- init function is invoked only once at the start
-- config.init = function (grid)
--
-- end

-- update function
slide.update = function(grid)
	for i = 1, #grid do
		local prev = grid[i][#grid[i]]
		for j = 1, #grid[i] do
			grid[i][j], prev = prev, grid[i][j]
		end
	end
	return true
end

require("cellular-automaton").register_animation(slide)
