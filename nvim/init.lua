-- ============================================================================
-- LEADER KEYS
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = "a"
vim.opt.showmode = false
vim.opt.fileformats = "unix,dos"
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 200
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.inccommand = "split"
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.confirm = true
vim.opt.termguicolors = true
vim.opt.pumheight = 10

-- ============================================================================
-- CLIPBOARD
-- ============================================================================
vim.opt.clipboard = "unnamedplus"

-- ============================================================================
-- VISUAL SETTINGS
-- ============================================================================
vim.opt.list = false
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣", eol = "¶", extends = ">", precedes = "<" }
vim.opt.cursorcolumn = false
vim.opt.colorcolumn = "100"
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.smoothscroll = true

-- ============================================================================
-- TAB AND INDENTATION
-- ============================================================================
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.smartindent = true

-- ============================================================================
-- FOLDING (using UFO later)
-- ============================================================================
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 99
vim.opt.foldenable = true

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Highlight on yank
autocmd("TextYankPost", {
	desc = "Highlight when yanking text",
	group = augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Resize splits on window resize
autocmd("VimResized", {
	desc = "Resize splits on window resize",
	group = augroup("resize-splits", { clear = true }),
	callback = function()
		vim.cmd("tabdo wincmd =")
	end,
})

-- Close certain filetypes with q
autocmd("FileType", {
	pattern = { "qf", "help", "man", "notify", "lspinfo", "startuptime" },
	group = augroup("close-with-q", { clear = true }),
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
	end,
})

-- ============================================================================
-- USER COMMANDS
-- ============================================================================
vim.api.nvim_create_user_command("CloseOtherBuffers", function()
	vim.cmd("silent! %bd|e#|bd#")
end, { desc = "Close all buffers except current" })

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================
local function toggle_listchars()
	vim.opt.list = not vim.opt.list:get()
end

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- Better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Better navigation
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

-- Move text up and down
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")

-- Better paste
vim.keymap.set("v", "p", '"_dP')

-- Diagnostics
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic error" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic quickfix" })

-- Terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- Toggles
vim.keymap.set("n", "<leader>tl", toggle_listchars, { desc = "Toggle listchars" })
vim.keymap.set("n", "<leader>tw", "<cmd>set wrap!<CR>", { desc = "Toggle wrap" })
vim.keymap.set("n", "<leader>tn", "<cmd>set relativenumber!<CR>", { desc = "Toggle relative number" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Delete buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>bd!<CR>", { desc = "Delete buffer (force)" })
vim.keymap.set("n", "<leader>bo", "<cmd>CloseOtherBuffers<CR>", { desc = "Close other buffers" })

-- Directory management
vim.keymap.set("n", "<leader>cd", "<cmd>cd %:h<CR><cmd>pwd<CR>", { desc = "Change to file directory" })

-- ============================================================================
-- LAZY.NVIM SETUP
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

-- ============================================================================
-- PLUGINS
-- ============================================================================
require("lazy").setup({
	-- ========================================================================
	-- UI AND COLORSCHEMES
	-- ========================================================================
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			require("gruvbox").setup({
				contrast = "hard",
				transparent_mode = false,
			})
			vim.cmd.colorscheme("gruvbox")
		end,
	},

	-- Better statusline
	{
		"nvim-lualine/lualine.nvim",
		event = "VeryLazy",
		opts = {
			options = {
				theme = "gruvbox",
				globalstatus = true,
				component_separators = { left = "|", right = "|" },
				section_separators = { left = "", right = "" },
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
	},

	-- Better UI components
	{
		"stevearc/dressing.nvim",
		event = "VeryLazy",
		opts = {},
	},

	-- Indent guides
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "│" },
			scope = { enabled = false },
		},
	},

	-- Color highlighter
	{
		"brenoprata10/nvim-highlight-colors",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			render = "background",
			enable_tailwind = true,
		},
	},

	-- Notifications
	{
		"rcarriga/nvim-notify",
		event = "VeryLazy",
		opts = {
			timeout = 2000,
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			background_colour = "#000000",
		},
		config = function(_, opts)
			require("notify").setup(opts)
			vim.notify = require("notify")
		end,
	},

	-- ========================================================================
	-- EDITING ENHANCEMENTS
	-- ========================================================================
	{
		"echasnovski/mini.nvim",
		event = "VeryLazy",
		config = function()
			require("mini.ai").setup({ n_lines = 500 })
			require("mini.surround").setup()
			require("mini.files").setup()
			require("mini.comment").setup()
			require("mini.bufremove").setup()
		end,
	},

	-- Better folding
	{
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			provider_selector = function()
				return { "treesitter", "indent" }
			end,
		},
		config = function(_, opts)
			vim.opt.foldmethod = "expr"
			vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
			require("ufo").setup(opts)

			vim.keymap.set("n", "zR", require("ufo").openAllFolds, { desc = "Open all folds" })
			vim.keymap.set("n", "zM", require("ufo").closeAllFolds, { desc = "Close all folds" })
		end,
	},

	-- Undo tree
	{
		"mbbill/undotree",
		cmd = "UndotreeToggle",
		keys = {
			{ "<leader>u", "<cmd>UndotreeToggle<CR>", desc = "Undo tree" },
		},
	},

	-- Zen mode
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<CR>", desc = "Zen mode" },
		},
		opts = {
			window = {
				backdrop = 0.95,
				width = 120,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					cursorline = false,
					cursorcolumn = false,
				},
			},
		},
	},

	-- ========================================================================
	-- FILE NAVIGATION
	-- ========================================================================

	-- Fuzzy finder (fzf-lua is faster than telescope)
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		keys = {
			{ "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find files" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Live grep" },
			{ "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find buffers" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Help tags" },
			{ "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "Recent files" },
			{ "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Find word" },
			{ "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Commands" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Keymaps" },
			{ "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Document diagnostics" },
			{ "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Workspace diagnostics" },
			{ "<leader>/", "<cmd>FzfLua blines<CR>", desc = "Buffer lines" },
			{ "<leader><leader>", "<cmd>FzfLua buffers<CR>", desc = "Buffers" },
		},
		opts = {
			winopts = {
				height = 0.85,
				width = 0.80,
				preview = {
					scrollbar = "float",
				},
			},
			fzf_opts = {
				["--no-scrollbar"] = true,
			},
		},
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			require("harpoon"):setup({})
		end,
		keys = {
			{
				"<leader>ha",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Harpoon: Add file",
			},
			{
				"<leader>hm",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Harpoon: Toggle menu",
			},
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Harpoon: Go to file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Harpoon: Go to file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Harpoon: Go to file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Harpoon: Go to file 4",
			},
			{
				"<leader>5",
				function()
					require("harpoon"):list():select(5)
				end,
				desc = "Harpoon: Go to file 5",
			},
			{
				"<C-S-P>",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "Harpoon: Previous file",
			},
			{
				"<C-S-N>",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Harpoon: Next file",
			},
		},
	},

	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 300,
			spec = {
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>s", group = "search" },
				{ "<leader>t", group = "toggle" },
				{ "<leader>w", group = "wiki" },
				{ "<leader>x", group = "diagnostics" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
			},
		},
	},

	-- ========================================================================
	-- GIT INTEGRATION
	-- ========================================================================
	{
		"lewis6991/gitsigns.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			signs = {
				add = { text = "│" },
				change = { text = "│" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
				untracked = { text = "┆" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns
				local map = function(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = bufnr, desc = desc })
				end

				-- Navigation
				map("n", "]c", gs.next_hunk, "Next hunk")
				map("n", "[c", gs.prev_hunk, "Previous hunk")

				-- Actions
				map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
				map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Stage hunk")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Reset hunk")
				map("n", "<leader>hS", gs.stage_buffer, "Stage buffer")
				map("n", "<leader>hu", gs.undo_stage_hunk, "Undo stage hunk")
				map("n", "<leader>hR", gs.reset_buffer, "Reset buffer")
				map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Blame line")
				map("n", "<leader>hd", gs.diffthis, "Diff this")
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, "Diff this ~")

				-- Text object
				map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns select hunk")
			end,
		},
	},

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
	-- LSP AND COMPLETION
	-- ========================================================================
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			{ "williamboman/mason.nvim", opts = {} },
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("gd", require("fzf-lua").lsp_definitions, "Goto definition")
					map("gr", require("fzf-lua").lsp_references, "Goto references")
					map("gI", require("fzf-lua").lsp_implementations, "Goto implementation")
					map("gy", require("fzf-lua").lsp_typedefs, "Goto type definition")
					map("<leader>ds", require("fzf-lua").lsp_document_symbols, "Document symbols")
					map("<leader>ws", require("fzf-lua").lsp_live_workspace_symbols, "Workspace symbols")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("gD", vim.lsp.buf.declaration, "Goto declaration")

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
						local highlight_augroup = vim.api.nvim_create_augroup("lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})
						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})
					end

					if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "Toggle inlay hints")
					end
				end,
			})

			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = {
					spacing = 4,
					source = "if_many",
					prefix = "●",
				},
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							workspace = {
								checkThirdParty = false,
								library = {
									"${3rd}/luv/library",
									unpack(vim.api.nvim_get_runtime_file("", true)),
								},
							},
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			require("mason").setup()
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, { "stylua" })
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},

	-- C# LSP
	{
		"seblj/roslyn.nvim",
		ft = "cs",
		opts = {
			config = {
				settings = {
					["csharp|inlay_hints"] = {},
				},
			},
		},
	},

	-- Formatting
	{
		"stevearc/conform.nvim",
		event = { "BufWritePre" },
		cmd = { "ConformInfo" },
		keys = {
			{
				"<leader>f",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "[F]ormat buffer",
			},
		},
		opts = {
			notify_on_error = false,
			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				if disable_filetypes[vim.bo[bufnr].filetype] then
					return nil
				else
					return {
						timeout_ms = 500,
						lsp_format = "fallback",
					}
				end
			end,
			formatters_by_ft = {
				lua = { "stylua" },
			},
		},
	},
	{
		"saghen/blink.cmp",
		event = "VimEnter",
		version = "1.*",
		dependencies = {
			{
				"L3MON4D3/LuaSnip",
				version = "2.*",
				build = (function()
					if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
						return
					end
					return "make install_jsregexp"
				end)(),
				dependencies = {
					"rafamadriz/friendly-snippets",
				},
				config = function()
					require("luasnip.loaders.from_vscode").lazy_load()
					require("luasnip.loaders.from_lua").lazy_load({
						paths = vim.fn.stdpath("config") .. "/snippets",
					})

					local ls = require("luasnip")
					vim.keymap.set({ "i", "s" }, "<C-l>", function()
						ls.jump(1)
					end, { silent = true })
					vim.keymap.set({ "i", "s" }, "<C-h>", function()
						ls.jump(-1)
					end, { silent = true })
				end,
			},
			"folke/lazydev.nvim",
		},
		--- @module 'blink.cmp'
		--- @type blink.cmp.Config
		opts = {
			keymap = {
				preset = "default",
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				documentation = { auto_show = false, auto_show_delay_ms = 500 },
			},
			sources = {
				default = { "lsp", "path", "snippets", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			snippets = { preset = "luasnip" },
			fuzzy = { implementation = "lua" },
			signature = { enabled = true },
		},
	},

	-- ========================================================================
	-- ROBUST MULTI-PROJECT .NET DEBUGGING
	-- ========================================================================
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
			"williamboman/mason.nvim",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()

			-- UI Triggers
			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close()
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close()
			end

			-- Helper: Check if a .csproj is likely an executable project
			local function is_executable_project(csproj_path)
				local file = io.open(csproj_path, "r")
				if not file then
					return false
				end
				local content = file:read("*a")
				file:close()

				-- Explicit executable check
				if content:match("Exe") then
					return true
				end

				-- For SDK-style projects, check if it's NOT a library
				local has_sdk = content:match("Library")

				if has_sdk and not is_library then
					if
						content:match("Exe")
						or content:match("Microsoft%.NET%.Sdk%.Web")
						or content:match("Microsoft%.NET%.Sdk%.Worker")
						or content:match("")
					then
						return true
					end
				end

				return false
			end

			-- Helper: Extract project name from .csproj path
			local function get_project_name(csproj_path)
				return vim.fn.fnamemodify(csproj_path, ":t:r")
			end

			-- Helper: Find DLL path for a given .csproj and verify it's executable
			local function find_dll_for_project(csproj_path, config_type)
				config_type = config_type or "Debug"
				local project_dir = vim.fn.fnamemodify(csproj_path, ":h")
				local project_name = get_project_name(csproj_path)

				local bin_base = project_dir .. "/bin/" .. config_type
				local search_cmd = string.format("find '%s' -name '%s.dll' 2>/dev/null", bin_base, project_name)
				local handle = io.popen(search_cmd)
				if not handle then
					return nil
				end
				local result = handle:read("*a")
				handle:close()

				for dll in result:gmatch("[^\r\n]+") do
					local runtimeconfig = dll:gsub("%.dll$", ".runtimeconfig.json")
					if vim.loop.fs_stat(runtimeconfig) then
						return dll
					end
				end

				return nil
			end

			-- Main function: Find executable projects and let user choose
			local function get_dll_path()
				local current_file_dir = vim.fn.expand("%:p:h")
				local home_dir = vim.fn.expand("~")
				local search_root = current_file_dir
				local solution_root = nil

				while search_root ~= home_dir and search_root ~= "/" do
					local sln_files = vim.fn.glob(search_root .. "/*.sln", false, true)
					local slnx_files = vim.fn.glob(search_root .. "/*.slnx", false, true)
					local git_dir = vim.fn.glob(search_root .. "/.git", false, true)

					if #sln_files > 0 or #slnx_files > 0 or #git_dir > 0 then
						solution_root = search_root
						break
					end

					search_root = vim.fn.fnamemodify(search_root, ":h")
				end

				if not solution_root then
					local csproj_path = vim.fs.find(function(name)
						return name:match("%.csproj$")
					end, { upward = true, path = current_file_dir })[1]

					if csproj_path then
						solution_root = vim.fn.fnamemodify(csproj_path, ":h")
						local dll_path = find_dll_for_project(csproj_path)
						if dll_path then
							print("Debugging: " .. get_project_name(csproj_path))
							return dll_path
						end
					end
					return vim.fn.input("Could not find project DLL. Path: ", vim.fn.getcwd() .. "/", "file")
				end

				local csproj_files = vim.fn.globpath(solution_root, "**/*.csproj", false, true)
				local executable_projects = {}

				for _, csproj in ipairs(csproj_files) do
					if is_executable_project(csproj) then
						local dll_path = find_dll_for_project(csproj)
						if dll_path then
							table.insert(executable_projects, {
								name = get_project_name(csproj),
								csproj = csproj,
								dll = dll_path,
							})
						end
					else
						local dll_path = find_dll_for_project(csproj)
						if dll_path then
							table.insert(executable_projects, {
								name = get_project_name(csproj),
								csproj = csproj,
								dll = dll_path,
							})
						end
					end
				end

				if #executable_projects == 0 then
					return vim.fn.input("No executable DLLs found. Path: ", solution_root .. "/", "file")
				elseif #executable_projects == 1 then
					print("Debugging: " .. executable_projects[1].name)
					return executable_projects[1].dll
				else
					local choice = nil
					vim.ui.select(executable_projects, {
						prompt = "Select project to debug (" .. #executable_projects .. " found):",
						format_item = function(item)
							return item.name
						end,
					}, function(selected)
						choice = selected
					end)

					if choice then
						print("Debugging: " .. choice.name)
						return choice.dll
					else
						return executable_projects[1].dll
					end
				end
			end

			-- Helper: Get project root for the selected DLL
			local function get_project_root()
				local current_file_dir = vim.fn.expand("%:p:h")
				local project_root = vim.fs.dirname(vim.fs.find(function(name)
					return name:match("%.csproj$")
				end, { upward = true, path = current_file_dir })[1])
				return project_root or vim.fn.getcwd()
			end

			-- DAP Adapter Configuration
			dap.adapters.coreclr = {
				type = "executable",
				command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
				args = { "--interpreter=vscode" },
			}

			-- DAP Launch Configuration
			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "Launch Project",
					request = "launch",
					program = function()
						return get_dll_path()
					end,
					cwd = function()
						return get_project_root()
					end,
				},
			}

			-- ========================================================================
			-- ENHANCED VISUAL STUDIO-STYLE KEYMAPS
			-- ========================================================================

			-- Basic debugging controls (VS-style F-keys)
			vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
			vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
			vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
			vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
			vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Debug: Stop" })
			vim.keymap.set("n", "<C-S-F5>", dap.restart, { desc = "Debug: Restart" })

			-- Breakpoint controls
			vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
			vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })

			-- Conditional Breakpoint
			vim.keymap.set("n", "<leader>dB", function()
				dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end, { desc = "Conditional Breakpoint" })

			-- Log Point (breakpoint that logs a message instead of stopping)
			vim.keymap.set("n", "<leader>dl", function()
				dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
			end, { desc = "Log Point" })

			-- Hit Count Breakpoint
			vim.keymap.set("n", "<leader>dh", function()
				local condition = vim.fn.input("Hit count condition (e.g., >5, ==3): ")
				if condition ~= "" then
					dap.set_breakpoint(condition)
				end
			end, { desc = "Hit Count Breakpoint" })

			-- Clear all breakpoints
			vim.keymap.set("n", "<leader>dC", function()
				dap.clear_breakpoints()
				print("All breakpoints cleared")
			end, { desc = "Clear All Breakpoints" })

			-- List all breakpoints
			vim.keymap.set("n", "<leader>dL", function()
				dap.list_breakpoints()
			end, { desc = "List Breakpoints" })

			-- Run to Cursor (like Ctrl+F10 in VS)
			vim.keymap.set("n", "<C-F10>", dap.run_to_cursor, { desc = "Run to Cursor" })
			vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to Cursor" })

			-- Session controls
			vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
			vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debug UI" })

			-- Evaluate expression under cursor
			vim.keymap.set({ "n", "v" }, "<leader>de", function()
				dapui.eval()
			end, { desc = "Evaluate Expression" })

			-- Hover (Quick Watch in VS)
			vim.keymap.set("n", "<leader>dh", function()
				require("dap.ui.widgets").hover()
			end, { desc = "Debug Hover/Quick Watch" })

			-- Scopes (view local variables)
			vim.keymap.set("n", "<leader>ds", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.scopes)
			end, { desc = "View Scopes" })

			-- Frames (call stack)
			vim.keymap.set("n", "<leader>df", function()
				local widgets = require("dap.ui.widgets")
				widgets.centered_float(widgets.frames)
			end, { desc = "View Frames/Call Stack" })

			-- Go to line without executing
			vim.keymap.set("n", "<leader>dj", function()
				dap.set_breakpoint()
				dap.continue()
			end, { desc = "Jump to Line" })

			-- Step back (if debugger supports it)
			vim.keymap.set("n", "<leader>dk", dap.step_back, { desc = "Step Back" })

			-- Pause execution
			vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })

			-- Up/Down in call stack
			vim.keymap.set("n", "<leader>d<Up>", dap.up, { desc = "Stack Frame Up" })
			vim.keymap.set("n", "<leader>d<Down>", dap.down, { desc = "Stack Frame Down" })

			-- ========================================================================
			-- BREAKPOINT SIGNS (Visual indicators)
			-- ========================================================================

			vim.fn.sign_define("DapBreakpoint", {
				text = "🔴",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "DapBreakpoint",
			})

			vim.fn.sign_define("DapBreakpointCondition", {
				text = "🟡",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "DapBreakpoint",
			})

			vim.fn.sign_define("DapBreakpointRejected", {
				text = "⭕",
				texthl = "DapBreakpoint",
				linehl = "",
				numhl = "DapBreakpoint",
			})

			vim.fn.sign_define("DapLogPoint", {
				text = "📝",
				texthl = "DapLogPoint",
				linehl = "",
				numhl = "DapLogPoint",
			})

			vim.fn.sign_define("DapStopped", {
				text = "▶️",
				texthl = "DapStopped",
				linehl = "DapStoppedLine",
				numhl = "DapStopped",
			})

			-- ========================================================================
			-- WHICH-KEY INTEGRATION (Optional - shows available commands)
			-- ========================================================================

			-- If you have which-key installed, this creates a nice menu
			local ok, wk = pcall(require, "which-key")
			if ok then
				wk.add({
					{ "<leader>d", group = "Debug" },
					{ "<leader>db", desc = "Toggle Breakpoint" },
					{ "<leader>dB", desc = "Conditional Breakpoint" },
					{ "<leader>dl", desc = "Log Point" },
					{ "<leader>dh", desc = "Hit Count Breakpoint" },
					{ "<leader>dC", desc = "Clear All Breakpoints" },
					{ "<leader>dL", desc = "List Breakpoints" },
					{ "<leader>dc", desc = "Run to Cursor" },
					{ "<leader>dr", desc = "Open REPL" },
					{ "<leader>du", desc = "Toggle Debug UI" },
					{ "<leader>de", desc = "Evaluate Expression" },
					{ "<leader>ds", desc = "View Scopes" },
					{ "<leader>df", desc = "View Frames" },
					{ "<leader>dp", desc = "Pause" },
				})
			end
		end,
	},
	-- ========================================================================
	-- TESTING (.NET SPECIFIC) - IMPROVED VERSION
	-- ========================================================================
	{
		"nvim-neotest/neotest",
		dependencies = {
			"nvim-neotest/nvim-nio",
			"nvim-lua/plenary.nvim",
			"antoinemadec/FixCursorHold.nvim",
			"nvim-treesitter/nvim-treesitter",
			"Issafalcon/neotest-dotnet",
			"mfussenegger/nvim-dap", -- For test debugging
		},
		config = function()
			local neotest = require("neotest")

			-- Helper: Find solution/project root
			local function find_solution_root()
				local current_file_dir = vim.fn.expand("%:p:h")
				local home_dir = vim.fn.expand("~")
				local search_root = current_file_dir

				while search_root ~= home_dir and search_root ~= "/" do
					local sln_files = vim.fn.glob(search_root .. "/*.sln", false, true)
					local slnx_files = vim.fn.glob(search_root .. "/*.slnx", false, true)
					local git_dir = vim.fn.glob(search_root .. "/.git", false, true)

					if #sln_files > 0 or #slnx_files > 0 or #git_dir > 0 then
						return search_root
					end

					search_root = vim.fn.fnamemodify(search_root, ":h")
				end

				-- Fallback to finding any .csproj
				local csproj_path = vim.fs.find(function(name)
					return name:match("%.csproj$")
				end, { upward = true, path = current_file_dir })[1]

				if csproj_path then
					return vim.fn.fnamemodify(csproj_path, ":h")
				end

				return vim.fn.getcwd()
			end

			neotest.setup({
				adapters = {
					require("neotest-dotnet")({
						-- Use solution as discovery root for multi-project support
						discovery_root = "solution",

						-- Additional dotnet test arguments
						dotnet_additional_args = {
							"--verbosity=normal",
							"--logger=console;verbosity=detailed",
						},

						-- Enable this to see test output immediately
						say_test_success = true,
					}),
				},

				-- Discovery settings
				discovery = {
					enabled = true,
					concurrent = 5, -- Discover multiple test files in parallel
				},

				-- UI settings
				status = {
					enabled = true,
					virtual_text = true,
					signs = true,
				},

				output = {
					enabled = true,
					open_on_run = "short", -- "short" | "long" | true | false
				},

				-- Show test output in floating window
				output_panel = {
					enabled = true,
					open = "botright split | resize 15",
				},

				-- Quick fix list for failed tests
				quickfix = {
					enabled = true,
					open = false,
				},

				-- Summary window settings
				summary = {
					enabled = true,
					expand_errors = true,
					follow = true,
					mappings = {
						attach = "a",
						clear_marked = "M",
						clear_target = "T",
						debug = "d",
						debug_marked = "D",
						expand = { "<CR>", "<2-LeftMouse>" },
						expand_all = "e",
						jumpto = "i",
						mark = "m",
						next_failed = "J",
						output = "o",
						prev_failed = "K",
						run = "r",
						run_marked = "R",
						short = "O",
						stop = "u",
						target = "t",
						watch = "w",
					},
				},

				-- Diagnostic settings
				diagnostic = {
					enabled = true,
					severity = vim.diagnostic.severity.ERROR,
				},

				-- Floating window settings
				floating = {
					border = "rounded",
					max_height = 0.8,
					max_width = 0.8,
					options = {},
				},

				-- Icons
				icons = {
					passed = "✓",
					running = "⟳",
					failed = "✗",
					skipped = "⊘",
					unknown = "?",
					running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
				},

				-- Highlights
				highlights = {
					passed = "NeotestPassed",
					running = "NeotestRunning",
					failed = "NeotestFailed",
					skipped = "NeotestSkipped",
				},
			})

			-- ========================================================================
			-- ENHANCED TEST KEYMAPS
			-- ========================================================================

			-- Run nearest test (at cursor)
			vim.keymap.set("n", "<C-t>t", function()
				neotest.run.run()
			end, { desc = "Run Nearest Test" })

			-- Run current file's tests
			vim.keymap.set("n", "<C-t>f", function()
				neotest.run.run(vim.fn.expand("%"))
			end, { desc = "Run Current File Tests" })

			-- Run all tests in solution
			vim.keymap.set("n", "<C-t>a", function()
				local root = find_solution_root()
				neotest.run.run(root)
			end, { desc = "Run All Tests in Solution" })

			-- Run last test
			vim.keymap.set("n", "<C-t>l", function()
				neotest.run.run_last()
			end, { desc = "Run Last Test" })

			-- Run all tests in current project directory
			vim.keymap.set("n", "<C-t>p", function()
				local csproj = vim.fs.find(function(name)
					return name:match("%.csproj$")
				end, { upward = true, path = vim.fn.expand("%:p:h") })[1]

				if csproj then
					local project_dir = vim.fn.fnamemodify(csproj, ":h")
					neotest.run.run(project_dir)
				else
					print("No .csproj found")
				end
			end, { desc = "Run Current Project Tests" })

			-- ========================================================================
			-- DEBUG TEST SUPPORT
			-- ========================================================================

			-- Debug nearest test
			vim.keymap.set("n", "<leader>td", function()
				neotest.run.run({ strategy = "dap" })
			end, { desc = "Debug Nearest Test" })

			-- Debug current file's tests
			vim.keymap.set("n", "<leader>tD", function()
				neotest.run.run({ vim.fn.expand("%"), strategy = "dap" })
			end, { desc = "Debug Current File Tests" })

			-- Debug last test
			vim.keymap.set("n", "<leader>tl", function()
				neotest.run.run_last({ strategy = "dap" })
			end, { desc = "Debug Last Test" })

			-- ========================================================================
			-- UI KEYMAPS
			-- ========================================================================

			-- Toggle test summary (explorer)
			vim.keymap.set("n", "<leader>ts", function()
				neotest.summary.toggle()
			end, { desc = "Toggle Test Summary" })

			-- Show test output
			vim.keymap.set("n", "<leader>to", function()
				neotest.output.open({ enter = true, auto_close = true })
			end, { desc = "Show Test Output" })

			-- Toggle output panel
			vim.keymap.set("n", "<leader>tp", function()
				neotest.output_panel.toggle()
			end, { desc = "Toggle Test Output Panel" })

			-- Stop running tests
			vim.keymap.set("n", "<leader>tS", function()
				neotest.run.stop()
			end, { desc = "Stop Running Tests" })

			-- Jump to next failed test
			vim.keymap.set("n", "]t", function()
				neotest.jump.next({ status = "failed" })
			end, { desc = "Next Failed Test" })

			-- Jump to previous failed test
			vim.keymap.set("n", "[t", function()
				neotest.jump.prev({ status = "failed" })
			end, { desc = "Previous Failed Test" })

			-- Attach to nearest test (for debugging running tests)
			vim.keymap.set("n", "<leader>ta", function()
				neotest.run.attach()
			end, { desc = "Attach to Nearest Test" })

			-- Watch file (auto-run tests on save)
			vim.keymap.set("n", "<leader>tw", function()
				neotest.watch.toggle(vim.fn.expand("%"))
			end, { desc = "Watch Current File" })

			-- Mark test for batch operations
			vim.keymap.set("n", "<leader>tm", function()
				neotest.summary.mark()
			end, { desc = "Mark Test" })

			-- Clear all marks
			vim.keymap.set("n", "<leader>tM", function()
				neotest.summary.clear_marked()
			end, { desc = "Clear Marked Tests" })

			-- Run marked tests
			vim.keymap.set("n", "<leader>tR", function()
				neotest.summary.run_marked()
			end, { desc = "Run Marked Tests" })

			-- ========================================================================
			-- WHICH-KEY INTEGRATION
			-- ========================================================================

			local ok, wk = pcall(require, "which-key")
			if ok then
				wk.add({
					{ "<leader>t", group = "Test" },
					{ "<leader>td", desc = "Debug Nearest Test" },
					{ "<leader>tD", desc = "Debug Current File" },
					{ "<leader>tl", desc = "Debug Last Test" },
					{ "<leader>ts", desc = "Toggle Summary" },
					{ "<leader>to", desc = "Show Output" },
					{ "<leader>tp", desc = "Toggle Output Panel" },
					{ "<leader>tS", desc = "Stop Tests" },
					{ "<leader>ta", desc = "Attach to Test" },
					{ "<leader>tw", desc = "Watch File" },
					{ "<leader>tm", desc = "Mark Test" },
					{ "<leader>tM", desc = "Clear Marks" },
					{ "<leader>tR", desc = "Run Marked" },
					{ "<C-t>", group = "Run Test" },
					{ "<C-t>t", desc = "Run Nearest" },
					{ "<C-t>f", desc = "Run File" },
					{ "<C-t>a", desc = "Run All" },
					{ "<C-t>l", desc = "Run Last" },
					{ "<C-t>p", desc = "Run Project" },
				})
			end

			-- ========================================================================
			-- AUTO-COMMANDS
			-- ========================================================================

			-- Auto-open summary when running tests (optional)
			vim.api.nvim_create_autocmd("User", {
				pattern = "NeotestRunStarted",
				callback = function()
					-- Uncomment if you want summary to auto-open
					-- neotest.summary.open()
				end,
			})

			-- Show notification when all tests complete
			vim.api.nvim_create_autocmd("User", {
				pattern = "NeotestRunComplete",
				callback = function()
					local stats = neotest.state.positions()
					if stats then
						print(string.format("Tests complete - Check summary for results"))
					end
				end,
			})
		end,
	}, -- ========================================================================
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local status_ok, configs = pcall(require, "nvim-treesitter.configs")
			if not status_ok then
				return
			end

			configs.setup({
				ensure_installed = {
					"html",
				},
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
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
})

-- ============================================================================
-- MASON SETUP (Must be after lazy.setup)
-- ============================================================================
require("mason").setup({
	registries = {
		"github:mason-org/mason-registry",
		"github:Crashdummyy/mason-registry",
	},
})

vim.keymap.set("n", "<Leader>n", function()
	require("mini.files").open()
end, { desc = "Open MiniFiles" })

vim.keymap.set("n", "<C-n>", function()
	require("mini.files").open()
end, { desc = "Open MiniFiles" })

-- Ctrl + S: Save current buffer
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<Esc>:w<CR>", { desc = "Save current buffer" })
-- Ctrl + Shift + S: Save all buffers
-- Note: Terminal support for Ctrl+Shift combinations varies
vim.keymap.set({ "n", "i", "v" }, "<C-S-s>", "<Esc>:wa<CR>", { desc = "Save all buffers" })
-- Ctrl + Z: Save all (forced) and quit Neovim
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<Esc>:wa!<CR>:qall<CR>", { desc = "Force save all and quit" })
