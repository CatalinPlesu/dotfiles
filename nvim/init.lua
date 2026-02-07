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
vim.keymap.set("i", "jk", "<Esc>")

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

-- Diagnostics - navigate and view errors/warnings
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1 })
end, { desc = "Diagnostic: Jump to previous error/warning" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1 })
end, { desc = "Diagnostic: Jump to next error/warning" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Diagnostic: Show error details in float" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic: Send all to quickfix list" })

-- Terminal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Terminal: Exit terminal mode back to normal" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Window: Move focus left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Window: Move focus down" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Window: Move focus up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Window: Move focus right" })

-- Resize windows
vim.keymap.set("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Window: Increase height" })
vim.keymap.set("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Window: Decrease height" })
vim.keymap.set("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Window: Decrease width" })
vim.keymap.set("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Window: Increase width" })

-- UI Toggles
vim.keymap.set("n", "<leader>ul", toggle_listchars, { desc = "UI: Toggle listchars visibility" })
vim.keymap.set("n", "<leader>uw", "<cmd>set wrap!<CR>", { desc = "UI: Toggle line wrapping" })
vim.keymap.set("n", "<leader>un", "<cmd>set relativenumber!<CR>", { desc = "UI: Toggle relative line numbers" })

-- Buffer management
vim.keymap.set("n", "<leader>bd", "<cmd>bd<CR>", { desc = "Buffer: Delete current buffer" })
vim.keymap.set("n", "<leader>bD", "<cmd>bd!<CR>", { desc = "Buffer: Force delete current (discard changes)" })
vim.keymap.set("n", "<leader>bo", "<cmd>CloseOtherBuffers<CR>", { desc = "Buffer: Close all other buffers" })

-- Directory management
vim.keymap.set("n", "<leader>cd", "<cmd>cd %:h<CR><cmd>pwd<CR>", { desc = "Dir: Change to current file's directory" })

-- File explorer
vim.keymap.set("n", "<Leader>n", function()
	require("mini.files").open()
end, { desc = "Explorer: Open mini.files file browser" })
vim.keymap.set("n", "<C-n>", function()
	require("mini.files").open()
end, { desc = "Explorer: Open mini.files file browser" })

-- Save and quit shortcuts
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save: Write current buffer" })
vim.keymap.set({ "n", "i", "v" }, "<C-S-s>", "<cmd>wa<CR>", { desc = "Save: Write all buffers" })
vim.keymap.set({ "n", "i", "v" }, "<C-z>", "<Esc>:wa!<CR>:qall<CR>", { desc = "Quit: Force save all and exit nvim" })

-- Wiki keybindings
vim.keymap.set("n", "<leader>wd", function()
	require("wiki").daily()
end, { desc = "Daily: Daily note" })
vim.keymap.set("n", "<leader>wW", function()
	require("wiki").weekly()
end, { desc = "Daily: Weekly note" })
vim.keymap.set("n", "<leader>wq", function()
	require("wiki").quarterly()
end, { desc = "Daily: Quarterly note" })
vim.keymap.set("n", "<leader>wy", function()
	require("wiki").yearly()
end, { desc = "Daily: Yearly note" })
vim.keymap.set("n", "<leader>wf", function()
	require("wiki").find_notes()
end, { desc = "Daily: Find notes" })
vim.keymap.set("n", "<leader>wS", function()
	require("wiki").search_notes()
end, { desc = "Daily: Search notes" })
vim.keymap.set("n", "<leader>wo", function()
	require("wiki").open_wiki()
end, { desc = "Daily: Open wiki root" })

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
			max_height = function()
				return math.floor(vim.o.lines * 0.75)
			end,
			max_width = function()
				return math.floor(vim.o.columns * 0.75)
			end,
			background_colour = "#000000",
			render = "default",
			stages = "fade",
			timeout = 3000,
			minimum_width = 10,
		},
		config = function(_, opts)
			local notify = require("notify")
			notify.setup(opts)
			vim.notify = notify
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
			{ "<leader>uu", "<cmd>UndotreeToggle<CR>", desc = "Undo: Toggle undo tree visualizer" },
		},
	},

	-- Zen mode
	{
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>z", "<cmd>ZenMode<CR>", desc = "UI: Toggle zen mode (distraction-free editing)" },
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
			{ "<leader>ff", "<cmd>FzfLua files<CR>", desc = "Find: Files by name in project" },
			{ "<leader>fg", "<cmd>FzfLua live_grep<CR>", desc = "Find: Grep text across all files (live)" },
			{ "<leader>fb", "<cmd>FzfLua buffers<CR>", desc = "Find: Open buffers list" },
			{ "<leader>fh", "<cmd>FzfLua help_tags<CR>", desc = "Find: Neovim help tags" },
			{ "<leader>fo", "<cmd>FzfLua oldfiles<CR>", desc = "Find: Recently opened files" },
			{ "<leader>fw", "<cmd>FzfLua grep_cword<CR>", desc = "Find: Word under cursor in all files" },
			{ "<leader>fc", "<cmd>FzfLua commands<CR>", desc = "Find: Available commands" },
			{ "<leader>fk", "<cmd>FzfLua keymaps<CR>", desc = "Find: All keybindings (search by desc)" },
			{ "<leader>fd", "<cmd>FzfLua diagnostics_document<CR>", desc = "Find: Diagnostics in current file" },
			{ "<leader>fD", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Find: Diagnostics across workspace" },
			{ "<leader>/", "<cmd>FzfLua blines<CR>", desc = "Find: Lines in current buffer" },
			{ "<leader><leader>", "<cmd>FzfLua buffers<CR>", desc = "Find: Switch between open buffers" },
		},
		opts = {
			winopts = {
				fullscreen = true,
				preview = {
					layout = "vertical",
					vertical = "up:70%",
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
				"<leader>ma",
				function()
					require("harpoon"):list():add()
				end,
				desc = "Marks: Add current file to harpoon list",
			},
			{
				"<leader>mm",
				function()
					require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
				end,
				desc = "Marks: Open harpoon quick menu to reorder/remove",
			},
			{
				"<leader>1",
				function()
					require("harpoon"):list():select(1)
				end,
				desc = "Marks: Jump to harpoon file 1",
			},
			{
				"<leader>2",
				function()
					require("harpoon"):list():select(2)
				end,
				desc = "Marks: Jump to harpoon file 2",
			},
			{
				"<leader>3",
				function()
					require("harpoon"):list():select(3)
				end,
				desc = "Marks: Jump to harpoon file 3",
			},
			{
				"<leader>4",
				function()
					require("harpoon"):list():select(4)
				end,
				desc = "Marks: Jump to harpoon file 4",
			},
			{
				"<leader>5",
				function()
					require("harpoon"):list():select(5)
				end,
				desc = "Marks: Jump to harpoon file 5",
			},
			{
				"[m",
				function()
					require("harpoon"):list():prev()
				end,
				desc = "Marks: Previous harpoon file",
			},
			{
				"]m",
				function()
					require("harpoon"):list():next()
				end,
				desc = "Marks: Next harpoon file",
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
				{ "<leader>d", group = "debug" },
				{ "<leader>f", group = "find" },
				{ "<leader>g", group = "git" },
				{ "<leader>h", group = "hunks" },
				{ "<leader>m", group = "marks" },
				{ "<leader>t", group = "test" },
				{ "<leader>u", group = "ui/undo" },
				{ "<leader>w", group = "wiki" },
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

				-- Navigation between git hunks (changed blocks)
				map("n", "]c", gs.next_hunk, "Hunk: Jump to next changed block")
				map("n", "[c", gs.prev_hunk, "Hunk: Jump to previous changed block")

				-- Hunk actions - stage/reset individual changed blocks
				map("n", "<leader>hs", gs.stage_hunk, "Hunk: Stage current hunk (git add this change)")
				map("n", "<leader>hr", gs.reset_hunk, "Hunk: Reset current hunk (discard this change)")
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Hunk: Stage selected lines")
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, "Hunk: Reset selected lines")
				map("n", "<leader>hS", gs.stage_buffer, "Hunk: Stage entire buffer (git add file)")
				map("n", "<leader>hu", gs.undo_stage_hunk, "Hunk: Undo last stage (unstage hunk)")
				map("n", "<leader>hR", gs.reset_buffer, "Hunk: Reset entire buffer (discard all changes)")
				map("n", "<leader>hp", gs.preview_hunk, "Hunk: Preview change in floating window")
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, "Hunk: Show git blame for current line")
				map("n", "<leader>hd", gs.diffthis, "Hunk: Diff buffer against index (staged)")
				map("n", "<leader>hD", function()
					gs.diffthis("~")
				end, "Hunk: Diff buffer against last commit")

				-- Text object - use 'ih' in visual/operator mode to select a hunk
				map(
					{ "o", "x" },
					"ih",
					":<C-U>Gitsigns select_hunk<CR>",
					"Hunk: Select hunk as text object (e.g. dih, vih)"
				)
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
			{ "<leader>gg", "<cmd>Neogit<CR>", desc = "Git: Open Neogit status panel" },
			{ "<leader>gc", "<cmd>Neogit commit<CR>", desc = "Git: Commit staged changes" },
			{ "<leader>gp", "<cmd>Neogit pull<CR>", desc = "Git: Pull from remote" },
			{ "<leader>gP", "<cmd>Neogit push<CR>", desc = "Git: Push to remote" },
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
			{
				"williamboman/mason.nvim",
				opts = {
					registries = {
						"github:mason-org/mason-registry",
						"github:Crashdummyy/mason-registry",
					},
				},
			},
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

					map("gd", require("fzf-lua").lsp_definitions, "Go to definition of symbol under cursor")
					map("gr", require("fzf-lua").lsp_references, "Find all references of symbol under cursor")
					map("gI", require("fzf-lua").lsp_implementations, "Go to implementation of interface/abstract")
					map("gy", require("fzf-lua").lsp_typedefs, "Go to type definition of symbol")
					map(
						"<leader>cs",
						require("fzf-lua").lsp_document_symbols,
						"Code: Search document symbols (functions, classes)"
					)
					map(
						"<leader>cS",
						require("fzf-lua").lsp_live_workspace_symbols,
						"Code: Search workspace symbols across all files"
					)
					map("<leader>cr", vim.lsp.buf.rename, "Code: Rename symbol across project")
					map("<leader>ca", vim.lsp.buf.code_action, "Code: Show available code actions (fixes, refactors)")
					map("K", vim.lsp.buf.hover, "Show hover documentation for symbol under cursor")
					map("gD", vim.lsp.buf.declaration, "Go to declaration (header/forward decl)")

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
						map("<leader>uh", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "UI: Toggle inlay type hints in code")
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
				"<leader>cf",
				function()
					require("conform").format({ async = true, lsp_format = "fallback" })
				end,
				mode = "",
				desc = "Code: Format buffer with conform/LSP",
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
	-- .NET DEBUGGING
	-- ========================================================================
	require("plugins.dotnet-debug"),
	-- ========================================================================
	-- .NET TESTING
	-- ========================================================================
	require("plugins.dotnet-test"),

	-- ========================================================================
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
					"c_sharp",
					"html",
					"lua",
					"markdown",
					"markdown_inline",
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
				{ name = "Delta", path = "~/Documents/wiki/delta/" },
				{ name = "Vault", path = "~/Documents/Notes/" },
			},
			keymaps = {
				delete_page = "", -- Disable delete keybinding
			},
		},
		keys = function()
			local is_work = vim.env.WORK_MACHINE == "1"
			local default_wiki = is_work and "Delta" or "Echo"
			return {
				{
					"<leader>ww",
					string.format("<cmd>lua require('neowiki').open_wiki('%s')<cr>", default_wiki),
					desc = "Wiki: Open default wiki",
				},
				{ "<leader>ws", "<cmd>lua require('neowiki').open_wiki()<cr>", desc = "Wiki: Select and open a wiki" },
			}
		end,
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
			{ "<leader>p", "<cmd>PasteImage<cr>", desc = "Image: Paste image from system clipboard into file" },
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
