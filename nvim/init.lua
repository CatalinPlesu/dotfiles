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
vim.opt.wrap = false
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
-- Native 0.10+: vim.diagnostic.jump; on 0.12+ use on_jump (float=true is deprecated)
local function diagnostic_jump(count)
	vim.diagnostic.jump({
		count = count,
		on_jump = function(_, bufnr)
			vim.diagnostic.open_float({ bufnr = bufnr, scope = "cursor", focus = false })
		end,
	})
end
vim.keymap.set("n", "[d", function()
	diagnostic_jump(-1)
end, { desc = "Diagnostic: Jump to previous error/warning" })
vim.keymap.set("n", "]d", function()
	diagnostic_jump(1)
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

-- Directory management
vim.keymap.set("n", "<leader>cd", "<cmd>cd %:h<CR><cmd>pwd<CR>", { desc = "Dir: Change to current file's directory" })

-- File explorer
vim.keymap.set("n", "<Leader>n", function()
	vim.cmd("Neotree toggle left filesystem")
end, { desc = "Explorer: Toggle file tree (neo-tree)" })
vim.keymap.set("n", "<C-n>", function()
	vim.cmd("Neotree toggle left filesystem")
end, { desc = "Explorer: Toggle file tree (neo-tree)" })
vim.keymap.set("n", "<Leader>E", function()
	vim.cmd("Neotree reveal left filesystem")
end, { desc = "Explorer: Reveal current file in tree" })

-- Save and quit shortcuts
vim.keymap.set({ "n", "i", "v" }, "<C-s>", "<cmd>w<CR>", { desc = "Save: Write current buffer" })
vim.keymap.set({ "n", "i", "v" }, "<C-S-s>", "<cmd>wa<CR>", { desc = "Save: Write all buffers" })

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
				lualine_x = { "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		},
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
			timeout = 3000,
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

	-- Instant visual jumps (replaces hop/leap)
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash: Select treesitter node",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Flash: Remote operator-pending jump",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Flash: Treesitter search",
			},
			{
				"<c-s>",
				mode = { "c" },
				function()
					require("flash").toggle()
				end,
				desc = "Flash: Toggle search jump",
			},
		},
	},

	-- Live diagnostics / references panel (replaces plain quickfix)
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", desc = "Trouble: Workspace diagnostics" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", desc = "Trouble: Buffer diagnostics" },
			{ "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", desc = "Trouble: Document symbols" },
			{ "<leader>xS", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", desc = "Trouble: LSP view" },
			{ "<leader>xL", "<cmd>Trouble loclist toggle<CR>", desc = "Trouble: Location list" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", desc = "Trouble: Quickfix list" },
			{ "gR", "<cmd>Trouble lsp_references toggle<CR>", desc = "Trouble: LSP references" },
		},
		opts = {},
	},

	-- ========================================================================
	-- FILE NAVIGATION
	-- ========================================================================

	-- File tree (Zed-like sidebar)
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		config = function()
			require("neo-tree").setup({
				close_if_last_window = true,
				popup_border_style = "rounded",
				sources = { "filesystem" },
				filesystem = {
					bind_to_cwd = false,
					cwd_target = "current",
					follow_current_file = {
						enabled = true,
						leave_dirs_open = false,
					},
					use_libuv_file_watcher = true,
					filtered_items = {
						visible = false,
						hide_dotfiles = false,
						hide_gitignored = true,
					},
				},
				default_component_configs = {
					indent = {
						with_markers = true,
						indent_size = 2,
					},
					name = {
						trailing_slash = false,
						use_git_status_colors = true,
					},
				},
				window = {
					position = "left",
					width = 32,
					mappings = {
						["<cr>"] = "open",
						["o"] = "open",
						["s"] = "open_split",
						["v"] = "open_vsplit",
						["t"] = "open_tabnew",
						["/"] = "fuzzy_finder",
						["f"] = "filter_on_submit",
						["F"] = "clear_filter",
						["R"] = "reveal_in_tree",
					},
				},
			})
		end,
	},

	-- Filesystem as buffer (edit files with vim motions + :w)
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		cmd = "Oil",
		keys = {
			{ "-", "<cmd>Oil<CR>", desc = "Explorer: Open parent directory in oil buffer" },
			{ "<leader>O", "<cmd>Oil --float<CR>", desc = "Explorer: Open oil floating window" },
		},
		opts = {
			default_file_explorer = true,
			view_options = { show_hidden = true },
			float = { max_width = 90, max_height = 30 },
		},
	},

	-- Fuzzy finder (fzf-lua is faster than telescope)
	-- Helix Space-mode: one key after <leader>, each key fires instantly.
	-- NOTE: <leader>f must stay the ONLY <leader>f* mapping, otherwise vim
	-- waits timeoutlen to disambiguate ff/fg/... - that was the lag.
	-- Ex-ff/fg/... actions live on non-f keys now; help/keymaps via :FzfLua.
	{
		"ibhagwan/fzf-lua",
		cmd = "FzfLua",
		keys = {
			{ "<leader>f", "<cmd>FzfLua files<CR>", desc = "Find: Files by name in project" },
			{ "<leader>b", "<cmd>FzfLua buffers<CR>", desc = "Find: Open buffers list" },
			{ "<leader>/", "<cmd>FzfLua live_grep<CR>", desc = "Find: Grep text across all files (live)" },
			{ "<leader>l", "<cmd>FzfLua blines<CR>", desc = "Find: Lines in current buffer" },
			{ "<leader>o", "<cmd>FzfLua oldfiles<CR>", desc = "Find: Recently opened files" },
			{ "<leader>*", "<cmd>FzfLua grep_cword<CR>", desc = "Find: Word under cursor in all files" },
			{ "<leader>d", "<cmd>FzfLua diagnostics_document<CR>", desc = "Find: Diagnostics in current file" },
			{ "<leader>D", "<cmd>FzfLua diagnostics_workspace<CR>", desc = "Find: Diagnostics across workspace" },
			{ "<leader>p", "<cmd>FzfLua commands<CR>", desc = "Find: Command palette" },
			{ "<leader>?", "<cmd>FzfLua keymaps<CR>", desc = "Find: All keybindings (search by desc)" },
			{ "<leader>'", "<cmd>FzfLua resume<CR>", desc = "Find: Last picker" },
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

	-- Which-key
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "modern",
			delay = 300,
			spec = {
				{ "<leader>c", group = "code" },
				{ "<leader>g", group = "git" },
				{ "<leader>h", group = "hunks" },
				{ "<leader>t", group = "transpose/swap" },
				{ "<leader>u", group = "ui/undo" },
				{ "<leader>w", group = "window" },
				{ "<leader>x", group = "trouble" },
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
				local gs = require("gitsigns")
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
				opts = {},
			},
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					-- NOTE: <cmd>FzfLua ...> strings (not require) so lazy.nvim
					-- loads fzf-lua on first use; eager require here would
					-- error when LSP attaches before fzf-lua ever loaded,
					-- aborting the whole callback and losing every LSP map.
					map("gd", "<cmd>FzfLua lsp_definitions<CR>", "Go to definition of symbol under cursor")
					map("gr", "<cmd>FzfLua lsp_references<CR>", "Find all references of symbol under cursor")
					map("gI", "<cmd>FzfLua lsp_implementations<CR>", "Go to implementation of interface/abstract")
					map("gy", "<cmd>FzfLua lsp_typedefs<CR>", "Go to type definition of symbol")
					map(
						"<leader>cs",
						"<cmd>FzfLua lsp_document_symbols<CR>",
						"Code: Search document symbols (functions, classes)"
					)
					map(
						"<leader>cS",
						"<cmd>FzfLua lsp_live_workspace_symbols<CR>",
						"Code: Search workspace symbols across all files"
					)
					map("<leader>cr", vim.lsp.buf.rename, "Code: Rename symbol across project")
					map("<leader>ca", vim.lsp.buf.code_action, "Code: Show available code actions (fixes, refactors)")
					map("K", vim.lsp.buf.hover, "Show hover documentation for symbol under cursor")
					map("gD", vim.lsp.buf.declaration, "Go to declaration (header/forward decl)")

					-- Helix Space-mode flat aliases (single key, same targets as above)
					map("<leader>r", vim.lsp.buf.rename, "Code: Rename symbol (Helix Space+r)")
					map("<leader>a", vim.lsp.buf.code_action, "Code: Code action (Helix Space+a)")
					map("<leader>k", vim.lsp.buf.hover, "Hover docs (Helix Space+k)")
					map("<leader>s", "<cmd>FzfLua lsp_document_symbols<CR>", "Code: Document symbols (Helix Space+s)")
					map(
						"<leader>S",
						"<cmd>FzfLua lsp_live_workspace_symbols<CR>",
						"Code: Workspace symbols (Helix Space+S)"
					)

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

					if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
						map("<leader>uh", function()
							local bufnr = event.buf
							vim.lsp.inlay_hint.enable(
								not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
								{ bufnr = bufnr }
							)
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
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
					},
				},
			})

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							-- runtime/workspace.library resolved dynamically by lazydev.nvim
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
			format_on_save = function()
				return {
					timeout_ms = 500,
					lsp_format = "fallback",
				}
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
		build = "cargo build --release",
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
				default = { "lsp", "path", "buffer", "lazydev" },
				providers = {
					lazydev = { module = "lazydev.integrations.blink", score_offset = 100 },
				},
			},
			-- Rust fuzzy matcher (prebuilt binary, no `implementation = "lua"` fallback)
			fuzzy = { implementation = "prefer_rust_with_warning" },
			signature = { enabled = true },
		},
	},

	-- ========================================================================
	-- .NET DEBUGGING
	-- ========================================================================
	-- .NET LANGUAGE SERVER (roslyn.nvim replaces vim.lsp.enable("roslyn_ls"))
	-- ========================================================================
	{
		"seblj/roslyn.nvim",
		ft = { "cs", "razor", "cshtml" },
		config = function()
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("blink.cmp").get_lsp_capabilities())

			vim.lsp.config("roslyn", {
				capabilities = capabilities,
				settings = {
					["csharp"] = {
						format = {
							enable = true,
						},
					},
				},
			})

			require("roslyn").setup({})
		end,
	},
	{
		"tris203/rzls.nvim",
		ft = { "razor", "cshtml" },
		config = function()
			require("rzls").setup({})
		end,
	},

	-- ========================================================================
	-- TREESITTER (main branch rewrite: no ensure_installed / configs.setup)
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		branch = "main",
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")
			local parsers = {
				"c_sharp",
				"html",
				"lua",
				"markdown",
				"markdown_inline",
				"vim",
				"vimdoc",
				"query",
				"regex",
			}
			ts.install(parsers)

			-- Replaces old `auto_install = true`: install parser on demand, then enable.
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					-- Try to enable treesitter highlighting + indent.
					local ok = pcall(vim.treesitter.start, args.buf)
					if ok then
						vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					else
						-- Parser missing: map filetype -> parser name and install async.
						local lang = vim.treesitter.language.get_lang(args.match)
						if lang then
							ts.install({ lang })
						end
					end
				end,
			})
		end,
	},

	-- AST-aware textobjects (af/if/ac/ic) + move/swap
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		branch = "main",
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		event = { "BufReadPost", "BufNewFile" },
		init = function()
			vim.g.no_plugin_maps = true
		end,
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
					selection_modes = {
						["@parameter.outer"] = "v",
						["@function.outer"] = "V",
						["@class.outer"] = "V",
					},
					include_surrounding_whitespace = false,
				},
				move = { set_jumps = true },
			})

			local select = require("nvim-treesitter-textobjects.select")
			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end, { desc = "Function: around (outer)" })
			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end, { desc = "Function: inside" })
			vim.keymap.set({ "x", "o" }, "ac", function()
				select.select_textobject("@class.outer", "textobjects")
			end, { desc = "Class: around (outer)" })
			vim.keymap.set({ "x", "o" }, "ic", function()
				select.select_textobject("@class.inner", "textobjects")
			end, { desc = "Class: inside" })
			vim.keymap.set({ "x", "o" }, "aa", function()
				select.select_textobject("@parameter.outer", "textobjects")
			end, { desc = "Param: around" })
			vim.keymap.set({ "x", "o" }, "ia", function()
				select.select_textobject("@parameter.inner", "textobjects")
			end, { desc = "Param: inside" })

			local move = require("nvim-treesitter-textobjects.move")
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function start" })
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function start" })
			vim.keymap.set({ "n", "x", "o" }, "]]", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class start" })
			vim.keymap.set({ "n", "x", "o" }, "[[", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Prev class start" })

			-- Helix unimpaired aliases: ]f function, ]t class, ]a param
			vim.keymap.set({ "n", "x", "o" }, "]f", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, { desc = "Next function (Helix ]f)" })
			vim.keymap.set({ "n", "x", "o" }, "[f", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, { desc = "Prev function (Helix [f)" })
			vim.keymap.set({ "n", "x", "o" }, "]t", function()
				move.goto_next_start("@class.outer", "textobjects")
			end, { desc = "Next class (Helix ]t)" })
			vim.keymap.set({ "n", "x", "o" }, "[t", function()
				move.goto_previous_start("@class.outer", "textobjects")
			end, { desc = "Prev class (Helix [t)" })
			vim.keymap.set({ "n", "x", "o" }, "]a", function()
				move.goto_next_start("@parameter.inner", "textobjects")
			end, { desc = "Next param (Helix ]a)" })
			vim.keymap.set({ "n", "x", "o" }, "[a", function()
				move.goto_previous_start("@parameter.inner", "textobjects")
			end, { desc = "Prev param (Helix [a)" })

			local swap = require("nvim-treesitter-textobjects.swap")
			vim.keymap.set("n", "<leader>ta", function()
				swap.swap_next("@parameter.inner")
			end, { desc = "Swap: next parameter" })
			vim.keymap.set("n", "<leader>tA", function()
				swap.swap_previous("@parameter.outer")
			end, { desc = "Swap: previous parameter" })
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

	-- Offline docs via Zeal GUI (Fedora: sudo dnf install zeal).
	-- Docsets are installed/managed in Zeal itself (File > Docset Library);
	-- filetype->docset is auto-detected, no manual table. NOTE: <leader>Z
	-- (not <leader>zk) so <leader>z stays prefix-free and fires instantly.
	{
		"KabbAmine/zeavim.vim",
		cmd = { "Zeavim", "ZeavimV", "Docset", "ZvV" },
		keys = {
			{ "<leader>z", "<Plug>Zeavim", mode = "n", desc = "Zeal: docs for word under cursor" },
			{ "<leader>z", "<Plug>ZVVisSelection", mode = "x", desc = "Zeal: docs for visual selection" },
			{ "gz", "<Plug>ZVOperator", mode = "n", desc = "Zeal: docs with motion (e.g. gziw)" },
			{ "<leader>Z", "<Plug>ZVKeyDocset", mode = "n", desc = "Zeal: pick docset manually" },
		},
	},
})
