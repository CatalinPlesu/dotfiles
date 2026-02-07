local M = {}

local function get_wiki_root()
	local is_work = vim.env.WORK_MACHINE == "1"
	return is_work and vim.fn.expand("~/Documents/wiki/delta") or vim.fn.expand("~/Documents/wiki/echo")
end

local function change_to_dir(path)
	vim.cmd("cd " .. vim.fn.fnamemodify(path, ":h"))
	vim.cmd("pwd")
end

function M.daily()
	local root = get_wiki_root()
	local date = os.date("%Y-%m-%d")
	local path = root .. "/Daily/" .. date .. ".md"
	vim.fn.mkdir(root .. "/Daily", "p")
	vim.cmd("edit " .. path)
	change_to_dir(path)
end

function M.weekly()
	local root = get_wiki_root()
	local week = os.date("%Y-W%V")
	local path = root .. "/Weekly/" .. week .. ".md"
	vim.fn.mkdir(root .. "/Weekly", "p")
	vim.cmd("edit " .. path)
	change_to_dir(path)
end

function M.quarterly()
	local root = get_wiki_root()
	local month = tonumber(os.date("%m"))
	local quarter = math.ceil(month / 3)
	local year = os.date("%Y")
	local path = root .. "/Quarterly/" .. year .. "-Q" .. quarter .. ".md"
	vim.fn.mkdir(root .. "/Quarterly", "p")
	vim.cmd("edit " .. path)
	change_to_dir(path)
end

function M.yearly()
	local root = get_wiki_root()
	local year = os.date("%Y")
	local path = root .. "/Yearly/" .. year .. ".md"
	vim.fn.mkdir(root .. "/Yearly", "p")
	vim.cmd("edit " .. path)
	change_to_dir(path)
end

function M.find_notes()
	local root = get_wiki_root()
	require("fzf-lua").files({ cwd = root })
end

function M.search_notes()
	local root = get_wiki_root()
	require("fzf-lua").live_grep({ cwd = root })
end

function M.open_wiki()
	local root = get_wiki_root()
	vim.cmd("cd " .. root)
	vim.cmd("pwd")
end

return M
