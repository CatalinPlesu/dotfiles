return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"Issafalcon/neotest-dotnet",
		"mfussenegger/nvim-dap",
	},
	config = function()
		local neotest = require("neotest")

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

			local file_dir = vim.fn.expand("%:p:h")
			local csproj_files = vim.fn.glob(file_dir .. "/*.csproj", false, true)
			while #csproj_files == 0 and file_dir ~= home_dir and file_dir ~= "/" do
				file_dir = vim.fn.fnamemodify(file_dir, ":h")
				csproj_files = vim.fn.glob(file_dir .. "/*.csproj", false, true)
			end

			if #csproj_files > 0 then
				return vim.fn.fnamemodify(csproj_files[1], ":h")
			end

			return vim.fn.getcwd()
		end

		local function find_csproj_for_file(file_path)
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

		local function diagnose_test_discovery()
			local current_file = vim.fn.expand("%:p")
			local csproj_path = find_csproj_for_file(current_file)

			if not csproj_path then
				print("Test Discovery Diagnostic:")
				print("  Current file: " .. current_file)
				print("  No .csproj found!")
				print("  Searching parent directories...")
				local search_dir = vim.fn.fnamemodify(current_file, ":h")
				local depth = 0
				while depth < 10 do
					local projs = vim.fn.glob(search_dir .. "/*.csproj", false, true)
					if #projs > 0 then
						print("  Found " .. #projs .. " project(s) in: " .. search_dir)
						for _, p in ipairs(projs) do
							print("    - " .. vim.fn.fnamemodify(p, ":t"))
						end
						return
					end
					search_dir = vim.fn.fnamemodify(search_dir, ":h")
					depth = depth + 1
				end
				return
			end

			print("Test Discovery Diagnostic:")
			print("  Current file: " .. current_file)
			print("  Project file: " .. csproj_path)

			local project_dir = vim.fn.fnamemodify(csproj_path, ":h")
			local project_name = vim.fn.fnamemodify(csproj_path, ":t:r")

			local bin_paths = {
				project_dir .. "/bin/Debug",
				project_dir .. "/bin/Release",
			}

			for _, bin_path in ipairs(bin_paths) do
				if vim.fn.isdirectory(bin_path) then
					print("  Bin directory found: " .. bin_path)

					local dll_pattern = bin_path .. "/**/" .. project_name .. ".dll"
					local dlls = vim.fn.glob(dll_pattern, false, true)
					if #dlls > 0 then
						print("  Test DLLs found:")
						for _, dll in ipairs(dlls) do
							print("    - " .. dll)
						end
					else
						print("  No test DLLs found (may need to build)")
					end
				end
			end
		end

		neotest.setup({
			adapters = {
				require("neotest-dotnet")({
					custom_params = function()
						return {
							ExtraArguments = { "--verbosity=normal" },
						}
					end,
					prompt_for_arguments = false,
					prioritise_error_names = true,
					projects = function()
						local solution_root = find_solution_root()
						local projects = {}

						local csproj_files = vim.fn.globpath(solution_root, "**/*.Test.csproj", false, true)
						vim.list_extend(csproj_files, vim.fn.globpath(solution_root, "**/*.Tests.csproj", false, true))

						for _, csproj in ipairs(csproj_files) do
							table.insert(projects, csproj)
						end

						if #projects == 0 then
							print("No test projects found in: " .. solution_root)
						end

						return projects
					end,
				}),
			},
			discovery = {
				enabled = true,
				concurrent = 5,
			},
			status = {
				enabled = true,
				virtual_text = true,
				signs = true,
			},
			output = {
				enabled = true,
				open_on_run = "short",
			},
			output_panel = {
				enabled = true,
				open = "botright split | resize 15",
			},
			quickfix = {
				enabled = true,
				open = false,
			},
			summary = {
				enabled = true,
				expand_errors = true,
				follow = true,
				animated = true,
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
			diagnostic = {
				enabled = true,
				severity = vim.diagnostic.severity.ERROR,
			},
			floating = {
				border = "rounded",
				max_height = 0.8,
				max_width = 0.8,
				options = {},
			},
			icons = {
				passed = "✓",
				running = "⟳",
				failed = "✗",
				skipped = "⊘",
				unknown = "?",
				running_animated = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" },
			},
			highlights = {
				passed = "NeotestPassed",
				running = "NeotestRunning",
				failed = "NeotestFailed",
				skipped = "NeotestSkipped",
			},
		})

		vim.keymap.set("n", "<C-t>t", function()
			neotest.run.run()
		end, { desc = "Test: Run nearest test to cursor" })

		vim.keymap.set("n", "<C-t>f", function()
			neotest.run.run(vim.fn.expand("%"))
		end, { desc = "Test: Run all tests in current file" })

		vim.keymap.set("n", "<C-t>a", function()
			local root = find_solution_root()
			neotest.run.run(root)
		end, { desc = "Test: Run all tests in entire solution" })

		vim.keymap.set("n", "<C-t>l", function()
			neotest.run.run_last()
		end, { desc = "Test: Re-run last executed test" })

		vim.keymap.set("n", "<C-t>p", function()
			local csproj = find_csproj_for_file(vim.fn.expand("%:p"))

			if csproj then
				local project_dir = vim.fn.fnamemodify(csproj, ":h")
				neotest.run.run(project_dir)
			else
				print("No .csproj found")
			end
		end, { desc = "Test: Run all tests in current .csproj project" })

		vim.keymap.set("n", "<leader>td", function()
			neotest.run.run({ strategy = "dap" })
		end, { desc = "Test: Debug nearest test with DAP debugger" })

		vim.keymap.set("n", "<leader>tD", function()
			neotest.run.run({ vim.fn.expand("%"), strategy = "dap" })
		end, { desc = "Test: Debug all tests in current file" })

		vim.keymap.set("n", "<leader>tl", function()
			neotest.run.run_last({ strategy = "dap" })
		end, { desc = "Test: Debug last executed test again" })

		vim.keymap.set("n", "<leader>ts", function()
			neotest.summary.toggle()
		end, { desc = "Test: Toggle test summary sidebar" })

		vim.keymap.set("n", "<leader>to", function()
			neotest.output.open({ enter = true, auto_close = true })
		end, { desc = "Test: Show output of nearest test in float" })

		vim.keymap.set("n", "<leader>tp", function()
			neotest.output_panel.toggle()
		end, { desc = "Test: Toggle test output panel at bottom" })

		vim.keymap.set("n", "<leader>tS", function()
			neotest.run.stop()
		end, { desc = "Test: Stop currently running tests" })

		vim.keymap.set("n", "]t", function()
			neotest.jump.next({ status = "failed" })
		end, { desc = "Test: Jump to next failed test" })

		vim.keymap.set("n", "[t", function()
			neotest.jump.prev({ status = "failed" })
		end, { desc = "Test: Jump to previous failed test" })

		vim.keymap.set("n", "<leader>ta", function()
			neotest.run.attach()
		end, { desc = "Test: Attach to nearest running test process" })

		vim.keymap.set("n", "<leader>tw", function()
			neotest.watch.toggle(vim.fn.expand("%"))
		end, { desc = "Test: Toggle auto-run on file save (watch mode)" })

		vim.keymap.set("n", "<leader>tm", function()
			neotest.summary.mark()
		end, { desc = "Test: Mark test in summary for batch run" })

		vim.keymap.set("n", "<leader>tM", function()
			neotest.summary.clear_marked()
		end, { desc = "Test: Clear all marked tests" })

		vim.keymap.set("n", "<leader>tR", function()
			neotest.summary.run_marked()
		end, { desc = "Test: Run all marked tests at once" })

		vim.keymap.set("n", "<leader>tr", function()
			diagnose_test_discovery()
		end, { desc = "Test: Diagnose test discovery issues" })


		vim.keymap.set("n", "<leader>tF", function()
			local neotest = require("neotest")
			neotest.run.run({ vim.fn.expand("%") })
			print("Refreshing test discovery...")
		end, { desc = "Force refresh test discovery" })

		vim.api.nvim_create_autocmd("User", {
			pattern = "NeotestRunComplete",
			callback = function()
				local stats = neotest.state.positions()
				if stats then
					print(string.format("Tests complete - Check summary for results"))
				end
			end,
		})

		vim.api.nvim_create_autocmd("User", {
			pattern = "NeotestFailed",
			callback = function()
				vim.notify("Test discovery or run failed - Check diagnostics", vim.log.levels.WARN)
			end,
		})

		vim.api.nvim_create_user_command("TestDiagnose", function()
			diagnose_test_discovery()
		end, { desc = "Diagnose test discovery issues" })

		vim.api.nvim_create_user_command("TestBuild", function()
			local csproj = find_csproj_for_file(vim.fn.expand("%:p"))

			if csproj then
				print("Building: " .. csproj)
				vim.fn.jobstart({ "dotnet", "build", csproj }, {
					stdout_buffered = true,
					on_exit = function(_, code, _)
						if code == 0 then
							print("Build successful!")
						else
							print("Build failed with code: " .. code)
						end
					end,
				})
			else
				print("No .csproj found")
			end
		end, { desc = "Build current test project" })

		vim.api.nvim_create_user_command("TestDotnet", function(opts)
			local csproj = find_csproj_for_file(vim.fn.expand("%:p"))
			if not csproj then
				print("No .csproj found")
				return
			end

			local args = opts.fargs or {}
			table.insert(args, 1, "test")
			table.insert(args, 2, csproj)

			print("Running: dotnet " .. table.concat(args, " "))
			vim.fn.jobstart({ "dotnet", unpack(args) }, {
				stdout_buffered = true,
				stderr_buffered = true,
				on_exit = function(_, code, _)
					print("Test run completed with code: " .. code)
				end,
			})
		end, { nargs = "*", desc = "Run dotnet test with custom args" })

		vim.api.nvim_create_user_command("TestRefresh", function()
			local neotest = require("neotest")
			neotest.run.run({ vim.fn.expand("%") })
			print("Refreshing test discovery...")
		end, { desc = "Force refresh test discovery" })

	end,
}
