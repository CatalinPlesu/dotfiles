-- ============================================================================
-- LADER KEYS
-- ============================================================================
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================================
-- GENERAL SETTINGS
-- ============================================================================
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.mouse = "a"
vim.o.showmode = false
vim.o.fileformats = "dos,unix"
vim.o.breakindent = true
vim.o.undofile = true
vim.o.swapfile = false
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = "yes"
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.inccommand = "split"
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.confirm = true
vim.o.termguicolors = true

-- ============================================================================
-- CLIPBOARD
-- ============================================================================
vim.o.clipboard = "unnamedplus"

-- ============================================================================
-- VISUAL SETTINGS
-- ============================================================================
vim.o.list = false
vim.opt.listchars = "eol:¶,tab:<->,space:°,trail:#,extends:>,precedes:<"
vim.opt.cursorcolumn = true
vim.opt.colorcolumn = "80"
vim.wo.wrap = false
vim.wo.linebreak = true

-- ============================================================================
-- TAB AND INDENTATION
-- ============================================================================
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- ============================================================================
-- FOLDING
-- ============================================================================
vim.o.foldmethod = "expr"
vim.o.foldexpr = "v:lua.vim.lsp.foldexpr()"
vim.o.foldenable = true
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- ============================================================================
-- AUTOCOMMANDS
-- ============================================================================
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- ============================================================================
-- USER COMMANDS
-- ============================================================================
vim.api.nvim_create_user_command("CloseOtherBuffers", "1,bufdo %bd|e#|bd#", {})

-- ============================================================================
-- HELPER FUNCTIONS
-- ============================================================================
local function toggle_listchars()
	vim.o.list = not vim.o.list
	-- Gruvbox-compatible colors for listchars
	vim.cmd([[
	  highlight NonText guifg=#928374
	  highlight Whitespace guifg=#504945
	  highlight SpecialKey guifg=#fe8019
	]])
end

-- ============================================================================
-- KEYMAPS
-- ============================================================================

-- General
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Diagnostic navigation
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })

-- Window navigation
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Toggles
vim.keymap.set("n", "<leader>tl", toggle_listchars, { desc = "[T]oggle [L]istchars" })
vim.keymap.set("n", "<leader>tw", "<cmd>set invwrap<CR>", { desc = "[T]oggle [W]rap" })

-- File navigation
vim.keymap.set("n", "<leader>n", ":Neotree<cr>", { desc = "Open Navigator" })
vim.keymap.set("n", "<C-n>", ":Neotree<cr>", { desc = "Open Navigator" })

-- Buffer management
vim.keymap.set("n", "<C-q>", ":CloseOtherBuffers<cr>", { desc = "Close other buffers" })

-- Directory management
vim.keymap.set(
	"n",
	"<leader>cd",
	"<cmd>cd %:h<CR>",
	{ noremap = true, silent = true, desc = "Change CWD to current file directory" }
)

-- Git (Neogit)
vim.keymap.set("n", "<leader>g", function()
	require("neogit").open({ kind = "replace" })
end, { desc = "Open Neogit (replace)" })

-- ============================================================================
-- LAZY.NVIM SETUP
-- ============================================================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end

---@type vim.Option
local rtp = vim.opt.rtp
rtp:prepend(lazypath)

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
			-- vim.cmd.colorscheme("gruvbox")
		end,
	},

	-- ========================================================================
	-- EDITING ENHANCEMENTS
	-- ========================================================================
	{
		"echasnovski/mini.nvim",
		config = function()
			-- Text objects (around/inside)
			-- USAGE: 'vaf' = select around function, 'dib' = delete inside brackets
			require("mini.ai").setup({ n_lines = 500 })

			-- Statusline (minimal, old-school)
			local statusline = require("mini.statusline")
			statusline.setup({ use_icons = vim.g.have_nerd_font })
			---@diagnostic disable-next-line: duplicate-set-field
			statusline.section_location = function()
				return "%2l:%-2v"
			end

			-- Navigate with []/next-prev style keybinds
			-- USAGE: ]b/[b = buffers, ]d/[d = diagnostics, ]f/[f = files, etc.
			-- Full list: buffer, comment, conflict, diagnostic, file, indent, jump,
			-- location, oldfile, quickfix, treesitter, undo, window, yank
			require("mini.bracketed").setup()

			-- Comment code easily
			-- USAGE: 'gc' in visual or 'gcc' for line, 'gcip' for paragraph
			require("mini.comment").setup()

			-- Move lines and selections
			-- USAGE: Alt+h/j/k/l to move selection/lines in any direction
			require("mini.move").setup({
				mappings = {
					left = "<M-h>",
					right = "<M-l>",
					down = "<M-j>",
					up = "<M-k>",
					line_left = "<M-h>",
					line_right = "<M-l>",
					line_down = "<M-j>",
					line_up = "<M-k>",
				},
			})
		end,
	},
	{
		-- Vim-like surround operations
		-- USAGE:
		--   ys{motion}{char} - Add surround (e.g., ysiw" adds quotes around word)
		--   ds{char}         - Delete surround (e.g., ds" deletes quotes)
		--   cs{old}{new}     - Change surround (e.g., cs"' changes " to ')
		--   yss{char}        - Surround entire line
		-- Visual mode: S{char} - Surround selection
		"kylechui/nvim-surround",
		version = "*",
		event = "VeryLazy",
		config = function()
			require("nvim-surround").setup({})
		end,
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = true,
		keys = {
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
			{ "<C-u>", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
	{
		"folke/zen-mode.nvim",
		opts = {
			window = {
				backdrop = 0.95,
				width = 100,
				height = 1,
				options = {
					signcolumn = "no",
					number = false,
					relativenumber = false,
					cursorline = false,
					cursorcolumn = false,
					foldcolumn = "0",
					list = false,
				},
			},
			plugins = {
				options = {
					enabled = true,
					ruler = false,
					showcmd = false,
					laststatus = 0,
				},
				twilight = { enabled = true },
				gitsigns = { enabled = false },
				tmux = { enabled = true },
			},
			on_open = function(win) end,
			on_close = function() end,
		},
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({})
		end,
	},

	-- ========================================================================
	-- MOVEMENT & NAVIGATION
	-- ========================================================================
	{
		-- Enhanced f/t/search motions with labels
		-- USAGE: Press 's' then type chars to see labeled jump points
		-- 'S' for backwards, works in operator-pending too (e.g., 'ds{char}')
		-- f/t/F/T work normally, press them again or ; to repeat
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = {
			-- Don't hijack f/t motions, keep them vanilla vim
			modes = {
				char = {
					enabled = false, -- Disable flash for f/t/F/T
				},
			},
		},
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash jump",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash Treesitter",
			},
		},
	},

	-- ========================================================================
	-- FILE NAVIGATION
	-- ========================================================================
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"MunifTanjim/nui.nvim",
			"nvim-tree/nvim-web-devicons",
		},
		lazy = false,
	},
	{
		"nvim-telescope/telescope.nvim",
		event = "VimEnter",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = function()
					return vim.fn.executable("make") == 1
				end,
			},
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
		},
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown(),
					},
				},
			})

			pcall(require("telescope").load_extension, "fzf")
			pcall(require("telescope").load_extension, "ui-select")

			local builtin = require("telescope.builtin")
			vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
			vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
			vim.keymap.set("n", "<leader>sf", builtin.find_files, { desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
			vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
			vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
			vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
			vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

			vim.keymap.set("n", "<leader>/", function()
				builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
					winblend = 10,
					previewer = false,
				}))
			end, { desc = "[/] Fuzzily search in current buffer" })

			vim.keymap.set("n", "<leader>s/", function()
				builtin.live_grep({
					grep_open_files = true,
					prompt_title = "Live Grep in Open Files",
				})
			end, { desc = "[S]earch [/] in Open Files" })

			vim.keymap.set("n", "<leader>sn", function()
				builtin.find_files({ cwd = vim.fn.stdpath("config") })
			end, { desc = "[S]earch [N]eovim files" })
		end,
	},
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			delay = 0,
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-…> ",
					M = "<M-…> ",
					D = "<D-…> ",
					S = "<S-…> ",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			spec = {
				{ "<leader>s", group = "[S]earch/Sort" },
				{ "<leader>t", group = "[T]oggle" },
				{ "<leader>h", group = "Git [H]unk", mode = { "n", "v" } },
			},
		},
	},

	-- ========================================================================
	-- SEARCH & REPLACE
	-- ========================================================================
	{
		-- Project-wide search and replace with live preview
		-- USAGE: <leader>S to open, then search/replace, <leader>rc to replace all
		"nvim-pack/nvim-spectre",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		keys = {
			{
				"<leader>S",
				function()
					require("spectre").open()
				end,
				desc = "Open Spectre (search/replace)",
			},
			{
				"<leader>sw",
				function()
					require("spectre").open_visual({ select_word = true })
				end,
				desc = "Search current word",
			},
			{
				"<leader>sp",
				function()
					require("spectre").open_file_search()
				end,
				desc = "Search in current file",
			},
		},
		config = function()
			require("spectre").setup()
		end,
	},

	-- ========================================================================
	-- GIT INTEGRATION
	-- ========================================================================
	{
		"lewis6991/gitsigns.nvim",
		opts = {
			signs = {
				add = { text = "+" },
				change = { text = "~" },
				delete = { text = "_" },
				topdelete = { text = "‾" },
				changedelete = { text = "~" },
			},
			on_attach = function(bufnr)
				local gs = package.loaded.gitsigns

				local function map(mode, l, r, opts)
					opts = opts or {}
					opts.buffer = bufnr
					vim.keymap.set(mode, l, r, opts)
				end

				-- Navigation between hunks
				map("n", "]h", function()
					if vim.wo.diff then
						return "]h"
					end
					vim.schedule(function()
						gs.next_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Next git hunk" })

				map("n", "[h", function()
					if vim.wo.diff then
						return "[h"
					end
					vim.schedule(function()
						gs.prev_hunk()
					end)
					return "<Ignore>"
				end, { expr = true, desc = "Previous git hunk" })

				-- Hunk actions
				map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
				map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
				map("v", "<leader>hs", function()
					gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Stage hunk" })
				map("v", "<leader>hr", function()
					gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
				end, { desc = "Reset hunk" })
				map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage buffer" })
				map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
				map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset buffer" })
				map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
				map("n", "<leader>hb", function()
					gs.blame_line({ full = true })
				end, { desc = "Blame line" })
				map("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
			end,
		},
	},
	{
		"NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"sindrets/diffview.nvim",
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			local neogit = require("neogit")
			neogit.setup({
				kind = "replace",
				integrations = {
					telescope = true,
					diffview = true,
				},
			})
			require("diffview").setup({
				view = {
					diff_panel = {
						win_options = {
							wrap = true,
							list = false,
						},
					},
				},
			})

			-- Enhanced keybinds
			vim.keymap.set("n", "<leader>gg", function()
				neogit.open({ kind = "replace" })
			end, { desc = "Open Neogit" })
			vim.keymap.set("n", "<leader>gc", function()
				neogit.open({ "commit" })
			end, { desc = "Git commit" })
			vim.keymap.set("n", "<leader>gp", function()
				neogit.open({ "pull" })
			end, { desc = "Git pull" })
			vim.keymap.set("n", "<leader>gP", function()
				neogit.open({ "push" })
			end, { desc = "Git push" })
			vim.keymap.set("n", "<leader>gb", function()
				neogit.open({ "branch" })
			end, { desc = "Git branch" })
			vim.keymap.set("n", "<leader>gl", function()
				neogit.open({ "log" })
			end, { desc = "Git log" })
		end,
		cmd = "Neogit",
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
		"seblyng/roslyn.nvim",
		ft = "cs",
		opts = {
			config = {
				env = {
					DOTNET_ROLL_FORWARD = "LatestMajor",
				},
				settings = {
					["csharp|background_analysis"] = {
						dotnet_analyzer_diagnostics_scope = "fullSolution",
						dotnet_compiler_diagnostics_scope = "fullSolution",
					},
					["csharp|inlay_hints"] = {
						csharp_enable_inlay_hints_for_implicit_object_creation = true,
						csharp_enable_inlay_hints_for_implicit_variable_types = true,
						csharp_enable_inlay_hints_for_lambda_parameter_types = true,
						csharp_enable_inlay_hints_for_types = true,
						dotnet_enable_inlay_hints_for_indexer_parameters = true,
						dotnet_enable_inlay_hints_for_literal_parameters = true,
						dotnet_enable_inlay_hints_for_object_creation_parameters = true,
						dotnet_enable_inlay_hints_for_other_parameters = true,
						dotnet_enable_inlay_hints_for_parameters = true,
						dotnet_suppress_inlay_hints_for_parameters_that_differ_only_by_suffix = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_argument_name = true,
						dotnet_suppress_inlay_hints_for_parameters_that_match_method_intent = true,
					},
				},
			},
			choose_target = true,
			ignore_target = function(target)
				return string.find(target, "Test") ~= nil
			end,
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")
					map("K", vim.lsp.buf.hover, "Hover Documentation")

					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
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

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = false, -- Disabled in favor of tiny-inline-diagnostic
			})

			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local servers = {
				lua_ls = {
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			-- Manual installation - no ensure_installed
			require("mason-tool-installer").setup({ ensure_installed = {} })

			require("mason-lspconfig").setup({
				ensure_installed = {},
				automatic_installation = false,
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
	{
		-- Better inline diagnostics (1.5k stars, actively maintained)
		-- USAGE: Diagnostics appear as clean inline text, less cluttered than virtual_text
		"rachartier/tiny-inline-diagnostic.nvim",
		event = "LspAttach",
		config = function()
			require("tiny-inline-diagnostic").setup({
				preset = "ghost", -- ghost, classic, minimal, powerline, modern
			})
		end,
	},
	{
		-- Better code action preview
		-- USAGE: Code actions show in a prettier Telescope picker
		"aznhe21/actions-preview.nvim",
		config = function()
			vim.keymap.set({ "v", "n" }, "gra", require("actions-preview").code_actions, {
				desc = "LSP: Code Actions (preview)",
			})
		end,
	},
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
		-- nvim-cmp: Completion engine
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			-- Snippet engine
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
						paths = vim.fn.stdpath("config") .. "/snippets/",
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
			-- Completion sources
			"saadparwaiz1/cmp_luasnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-cmdline",
			"folke/lazydev.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				-- Keymaps modeled after blink.cmp "default" preset
				mapping = cmp.mapping.preset.insert({
					-- Navigate completion menu
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),

					-- Scroll documentation window
					["<C-b>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),

					-- Accept completion
					["<CR>"] = cmp.mapping.confirm({ select = true }),
					["<Tab>"] = cmp.mapping.confirm({ select = true }),

					-- Manually trigger completion
					["<C-Space>"] = cmp.mapping.complete({}),

					-- Super-Tab like behavior (navigate snippets or fallback to completion)
					["<C-l>"] = cmp.mapping(function()
						if luasnip.expand_or_locally_jumpable() then
							luasnip.expand_or_jump()
						end
					end, { "i", "s" }),
					["<C-h>"] = cmp.mapping(function()
						if luasnip.locally_jumpable(-1) then
							luasnip.jump(-1)
						end
					end, { "i", "s" }),
				}),

				sources = {
					{
						name = "lazydev",
						group_index = 0, -- set group index to 0 to skip loading LuaLS completions
					},
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "path" },
					{ name = "buffer", keyword_length = 3 },
				},

				formatting = {
					format = function(entry, vim_item)
						-- Simple icons if nerd font available
						if vim.g.have_nerd_font then
							local icons = {
								nvim_lsp = "󰘧",
								luasnip = "󰩫",
								buffer = "󰈙",
								path = "󰉋",
								cmdline = "",
							}
							vim_item.kind = string.format("%s %s", icons[entry.source.name] or "", vim_item.kind)
						end
						return vim_item
					end,
				},

				window = {
					completion = cmp.config.window.bordered(),
					documentation = cmp.config.window.bordered(),
				},

				experimental = {
					ghost_text = true,
				},
			})

			-- Command-line completion
			cmp.setup.cmdline(":", {
				mapping = cmp.mapping.preset.cmdline(),
				sources = cmp.config.sources({
					{ name = "path" },
				}, {
					{ name = "cmdline" },
				}),
			})

			-- Search completion
			cmp.setup.cmdline({ "/", "?" }, {
				mapping = cmp.mapping.preset.cmdline(),
				sources = {
					{ name = "buffer" },
				},
			})
		end,
	},

	-- ========================================================================
	-- SYNTAX AND PARSING
	-- ========================================================================
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		dependencies = {
			-- Text objects based on treesitter
			"nvim-treesitter/nvim-treesitter-textobjects",
		},
		init = function()
			vim.g.treesitter_install_compilers = { "cl", "gcc", "clang" }
		end,
		config = function()
			local status_ok, configs = pcall(require, "nvim-treesitter.configs")
			if not status_ok then
				return
			end

			-- MANUAL INSTALLATION - Install languages yourself with :TSInstall <language>
			configs.setup({
				ensure_installed = {}, -- Empty, you install manually
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },

				-- Incremental selection based on treesitter
				-- USAGE: Ctrl-space to init, Ctrl-space to grow, Backspace to shrink, Ctrl-Backspace to scope
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},

				-- Text objects for functions, classes, etc.
				-- USAGE: 'vaf' = select around function, 'dif' = delete inside function
				-- 'vac' = around class, 'vic' = inside class
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["af"] = "@function.outer",
							["if"] = "@function.inner",
							["ac"] = "@class.outer",
							["ic"] = "@class.inner",
							["aa"] = "@parameter.outer",
							["ia"] = "@parameter.inner",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = "@function.outer",
							["]c"] = "@class.outer",
						},
						goto_next_end = {
							["]F"] = "@function.outer",
							["]C"] = "@class.outer",
						},
						goto_previous_start = {
							["[f"] = "@function.outer",
							["[c"] = "@class.outer",
						},
						goto_previous_end = {
							["[F"] = "@function.outer",
							["[C"] = "@class.outer",
						},
					},
				},
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
	{ "wakatime/vim-wakatime", lazy = false },

	-- Auto pairs for brackets, quotes, etc.
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			local npairs = require("nvim-autopairs")
			npairs.setup({
				check_ts = true, -- Use treesitter
				ts_config = {
					lua = { "string" }, -- Don't add pairs in lua string treesitter nodes
					javascript = { "template_string" },
				},
			})

			-- Integration with nvim-cmp
			local cmp_autopairs = require("nvim-autopairs.completion.cmp")
			local cmp = require("cmp")
			cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
		end,
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

-- ============================================================================
-- COLORSCHEME
-- ============================================================================
vim.cmd.colorscheme("gruvbox")
