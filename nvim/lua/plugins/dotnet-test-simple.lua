local M = {}

function M.find_csproj(file_path)
	local file_dir = vim.fn.fnamemodify(file_path, ":h")
	local home_dir = vim.fn.expand("~")
	local search_dir = file_dir

	while search_dir ~= home_dir and search_dir ~= "/" do
		local csproj_files = vim.fn.glob(search_dir .. "/*.csproj", false, true)
		if #csproj_files > 0 then
			return csproj_files[1]
		end
		search_dir = vim.fn.fnamemodify(search_dir, ":h")
	end

	return nil
end

function M.find_solution_root()
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

	return vim.fn.getcwd()
end

function M.run_nearest_test()
	local line = vim.api.nvim_win_get_cursor(0)[1]
	local current_file = vim.fn.expand("%:p")
	local csproj = M.find_csproj(current_file)

	if not csproj then
		vim.notify("No .csproj found for current file", vim.log.levels.ERROR)
		return
	end

	vim.notify("Running test at line " .. line .. " in " .. csproj, vim.log.levels.INFO)

	vim.cmd("term dotnet test \"" .. csproj .. "\" --filter \"FullyQualifiedName~" .. line .. "\" --verbosity normal")
end

function M.run_file_tests()
	local current_file = vim.fn.expand("%:p")
	local csproj = M.find_csproj(current_file)

	if not csproj then
		vim.notify("No .csproj found for current file", vim.log.levels.ERROR)
		return
	end

	vim.notify("Running tests in " .. current_file, vim.log.levels.INFO)

	vim.cmd("term dotnet test \"" .. csproj .. "\" --filter \"FullyQualifiedName~" .. vim.fn.fnamemodify(current_file, ":t:r") .. "\" --verbosity normal")
end

function M.run_all_tests()
	local root = M.find_solution_root()
	local sln = vim.fn.glob(root .. "/*.sln", false, true)[1] or vim.fn.glob(root .. "/*.slnx", false, true)[1]

	if sln then
		vim.notify("Running all tests in " .. sln, vim.log.levels.INFO)
		vim.cmd("term dotnet test \"" .. sln .. "\" --verbosity normal")
	else
		vim.notify("No solution file found", vim.log.levels.ERROR)
	end
end

function M.run_project_tests()
	local current_file = vim.fn.expand("%:p")
	local csproj = M.find_csproj(current_file)

	if not csproj then
		vim.notify("No .csproj found for current file", vim.log.levels.ERROR)
		return
	end

	vim.notify("Running all tests in " .. csproj, vim.log.levels.INFO)
	vim.cmd("term dotnet test \"" .. csproj .. "\" --verbosity normal")
end

function M.diagnose()
	local current_file = vim.fn.expand("%:p")
	local csproj = M.find_csproj(current_file)

	vim.notify("=== Test Runner Diagnostic ===", vim.log.levels.INFO)
	vim.notify("Current file: " .. current_file, vim.log.levels.INFO)

	if csproj then
		vim.notify("Found .csproj: " .. csproj, vim.log.levels.INFO)
	else
		vim.notify("No .csproj found!", vim.log.levels.WARN)

		local search_dir = vim.fn.fnamemodify(current_file, ":h")
		local depth = 0
		while depth < 10 do
			local projs = vim.fn.glob(search_dir .. "/*.csproj", false, true)
			if #projs > 0 then
				vim.notify("Found " .. #projs .. " project(s) in: " .. search_dir, vim.log.levels.INFO)
				for _, p in ipairs(projs) do
					vim.notify("  - " .. vim.fn.fnamemodify(p, ":t"), vim.log.levels.INFO)
				end
				break
			end
			search_dir = vim.fn.fnamemodify(search_dir, ":h")
			depth = depth + 1
		end
	end
end

function M.setup()
	vim.keymap.set("n", "<C-t>t", M.run_nearest_test, { desc = "Run Nearest Test (dotnet)" })
	vim.keymap.set("n", "<C-t>f", M.run_file_tests, { desc = "Run File Tests (dotnet)" })
	vim.keymap.set("n", "<C-t>a", M.run_all_tests, { desc = "Run All Tests (dotnet)" })
	vim.keymap.set("n", "<C-t>p", M.run_project_tests, { desc = "Run Project Tests (dotnet)" })
	vim.keymap.set("n", "<leader>tr", M.diagnose, { desc = "Diagnose Test Discovery" })

	vim.api.nvim_create_user_command("TestRunNearest", M.run_nearest_test, { desc = "Run nearest test" })
	vim.api.nvim_create_user_command("TestRunFile", M.run_file_tests, { desc = "Run tests in current file" })
	vim.api.nvim_create_user_command("TestRunAll", M.run_all_tests, { desc = "Run all tests" })
	vim.api.nvim_create_user_command("TestRunProject", M.run_project_tests, { desc = "Run all tests in project" })
	vim.api.nvim_create_user_command("TestDiagnose", M.diagnose, { desc = "Diagnose test setup" })
end

return M
