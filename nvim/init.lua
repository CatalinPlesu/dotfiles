vim.g.base46_cache = vim.fn.stdpath("data") .. "/nvchad/base46/"
vim.g.mapleader = " "

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	local repo = "https://github.com/folke/lazy.nvim.git"
	vim.fn.system({ "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath })
end

vim.opt.rtp:prepend(lazypath)

local lazy_config = require("configs.lazy")

-- load plugins
require("lazy").setup({
	{
		"NvChad/NvChad",
		lazy = false,
		branch = "v2.5",
		import = "nvchad.plugins",
	},
	{ import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require("options")
require("autocmds")

require("custom-config.ramboe-utils")

vim.schedule(function()
	require("mappings")
end)

-- require("custom-config.gen-nvim")
-- require("custom-plugins.clemens-tree")
-- require("custom-plugins.gen.init")

require("custom-config.oil-config")
require("custom-config.folding")
require("custom-config.luasnip")
require("custom-config.centerpad")
require("custom-config.neotest")
-- require("custom-config.tiny-inline-diagnostic") -- loaded via lazy
require("custom-config.fzf-lua")
require("custom-config.comment")
require("custom-config.nvim-dap")
require("custom-config.nvim-dap-ui")

require("git-conflict")

vim.cmd.colorscheme("gruvbox")
