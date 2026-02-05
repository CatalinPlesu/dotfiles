return {
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

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end

		local function is_executable_project(csproj_path)
			local file = io.open(csproj_path, "r")
			if not file then
				return false
			end
			local content = file:read("*a")
			file:close()

			if content:match("Exe") then
				return true
			end

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

		local function get_project_name(csproj_path)
			return vim.fn.fnamemodify(csproj_path, ":t:r")
		end

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

		local function get_project_root()
			local current_file_dir = vim.fn.expand("%:p:h")
			local project_root = vim.fs.dirname(vim.fs.find(function(name)
				return name:match("%.csproj$")
			end, { upward = true, path = current_file_dir })[1])
			return project_root or vim.fn.getcwd()
		end

		dap.adapters.coreclr = {
			type = "executable",
			command = vim.fn.stdpath("data") .. "/mason/bin/netcoredbg",
			args = { "--interpreter=vscode" },
		}

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

		vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Start/Continue" })
		vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
		vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
		vim.keymap.set("n", "<S-F11>", dap.step_out, { desc = "Debug: Step Out" })
		vim.keymap.set("n", "<S-F5>", dap.terminate, { desc = "Debug: Stop" })
		vim.keymap.set("n", "<C-S-F5>", dap.restart, { desc = "Debug: Restart" })

		vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })
		vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle Breakpoint" })

		vim.keymap.set("n", "<leader>dB", function()
			dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
		end, { desc = "Conditional Breakpoint" })

		vim.keymap.set("n", "<leader>dl", function()
			dap.set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
		end, { desc = "Log Point" })

		vim.keymap.set("n", "<leader>dh", function()
			local condition = vim.fn.input("Hit count condition (e.g., >5, ==3): ")
			if condition ~= "" then
				dap.set_breakpoint(condition)
			end
		end, { desc = "Hit Count Breakpoint" })

		vim.keymap.set("n", "<leader>dC", function()
			dap.clear_breakpoints()
			print("All breakpoints cleared")
		end, { desc = "Clear All Breakpoints" })

		vim.keymap.set("n", "<leader>dL", function()
			dap.list_breakpoints()
		end, { desc = "List Breakpoints" })

		vim.keymap.set("n", "<C-F10>", dap.run_to_cursor, { desc = "Run to Cursor" })
		vim.keymap.set("n", "<leader>dc", dap.run_to_cursor, { desc = "Run to Cursor" })

		vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Open REPL" })
		vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Toggle Debug UI" })

		vim.keymap.set({ "n", "v" }, "<leader>de", function()
			dapui.eval()
		end, { desc = "Evaluate Expression" })

		vim.keymap.set("n", "<leader>dH", function()
			require("dap.ui.widgets").hover()
		end, { desc = "Debug Hover/Quick Watch" })

		vim.keymap.set("n", "<leader>ds", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.scopes)
		end, { desc = "View Scopes" })

		vim.keymap.set("n", "<leader>df", function()
			local widgets = require("dap.ui.widgets")
			widgets.centered_float(widgets.frames)
		end, { desc = "View Frames/Call Stack" })

		vim.keymap.set("n", "<leader>dj", function()
			dap.set_breakpoint()
			dap.continue()
		end, { desc = "Jump to Line" })

		vim.keymap.set("n", "<leader>dk", dap.step_back, { desc = "Step Back" })

		vim.keymap.set("n", "<leader>dp", dap.pause, { desc = "Pause" })

		vim.keymap.set("n", "<leader>d<Up>", dap.up, { desc = "Stack Frame Up" })
		vim.keymap.set("n", "<leader>d<Down>", dap.down, { desc = "Stack Frame Down" })

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

		local ok, wk = pcall(require, "which-key")
		if ok then
			wk.add({
				{ "<leader>d", group = "Debug" },
				{ "<leader>db", desc = "Toggle Breakpoint" },
				{ "<leader>dB", desc = "Conditional Breakpoint" },
				{ "<leader>dl", desc = "Log Point" },
				{ "<leader>dH", desc = "Hit Count Breakpoint" },
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
}
