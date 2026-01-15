# Debugging Configuration for C# Development

This guide explains how to use the integrated debugger in your Neovim configuration for C# development.

## Installation

The debugging plugins are automatically installed when you open Neovim:
- `nvim-dap` - Debug Adapter Protocol client
- `nvim-dap-ui` - Beautiful debugger UI
- `nvim-dap-virtual-text` - Virtual text for variables
- `nvim-dotnet` - C# project integration
- `mason-nvim-dap` - Debug adapter installer

## Debugging Keymaps

### Primary Debug Controls
- `<F5>` - Start/Continue debugging
- `<F1>` - Step Into
- `<F2>` - Step Over  
- `<F3>` - Step Out
- `<F4>` - Terminate debugging

### Breakpoints
- `<leader>b` - Toggle breakpoint
- `<leader>B` - Set conditional breakpoint
- `<leader>lp` - Set log point

### Debug UI
- `<leader>du` - Toggle debugger UI
- `<leader>dr` - Toggle REPL
- `<leader>dl` - Run last debug session

### Variable Inspection
- `<leader>dh` - Hover over variable
- `<leader>dp` - Preview variable
- `<leader>de` - Centered float (frames/variables)
- `<leader>df` - Show frames
- `<leader>dv` - Show variables

### C# Specific
- `<leader>ds` - Start C# debugging (C# files only)
- `<leader>dt` - Run C# test (C# files only)

## Debugging C# Projects

### First Time Setup

1. Install the .NET debugger:
   ```bash
   dotnet tool install --global netcoredbg
   ```

2. Ensure `netcoredbg` is in your PATH

### Launching C# Debugging

#### Method 1: Launch Current File
1. Open a C# file
2. Press `<F5>` to start debugging
3. When prompted, enter the path to your DLL (e.g., `bin/Debug/YourProject.dll`)

#### Method 2: Attach to Running Process
1. Start your application with `dotnet run`
2. Press `<leader>B` and select "Attach to running process"
3. Choose your running .NET process

#### Method 3: Using nvim-dotnet (Recommended)
The `nvim-dotnet` plugin provides automatic project detection:
1. Open any C# file in your project
2. Use `<leader>ds` to start debugging automatically

### Debug Configurations

The debugger supports multiple configurations:

```lua
-- Current file launch
{
  type = 'netcoredbg',
  request = 'launch',
  name = 'Launch - Current File',
  program = 'path/to/your/dll',
  cwd = '${workspaceFolder}',
  stopAtEntry = false,
}

-- Attach to process
{
  type = 'netcoredbg',
  request = 'attach',
  name = 'Attach to running process',
  processId = process_id,
  cwd = '${workspaceFolder}',
}
```

## Debug UI Layout

The debugger UI shows:
- **Scopes** - Variable scopes (local, arguments, etc.)
- **Breakpoints** - List of breakpoints
- **Stacks** - Call stack
- **Watches** - Watch expressions
- **REPL** - Debug console
- **Console** - Application output

## Common Workflows

### Setting Breakpoints
1. Place cursor on the line where you want to pause
2. Press `<leader>b` to set a breakpoint
3. For conditional breakpoints, press `<leader>B` and enter condition

### Debugging a Console App
1. Open your Program.cs
2. Press `<F5>` to start debugging
3. Use step keys to navigate through execution
4. View variables with `<leader>dh`

### Debugging with Launch Settings
1. Create a `.vscode/launch.json` file:
```json
{
  "version": "0.2.0",
  "configurations": [
    {
      "name": ".NET Core Launch (console)",
      "type": "coreclr",
      "request": "launch",
      "preLaunchTask": "build",
      "program": "${workspaceFolder}/bin/Debug/YourApp.dll",
      "args": [],
      "cwd": "${workspaceFolder}",
      "stopAtEntry": false,
      "console": "integratedTerminal"
    }
  ]
}
```

### Debugging ASP.NET Core
1. Open a controller or view file
2. Set breakpoints
3. Use the "Attach to process" configuration to debug the running web server

## Tips and Tricks

1. **Virtual Text**: Variables are shown directly in the code
2. **REPL**: Use the debug console to evaluate expressions while debugging
3. **Watches**: Add variables to watch list to monitor their values
4. **Conditional Breakpoints**: Set breakpoints that only trigger when conditions are met
5. **Log Points**: Set breakpoints that log messages without stopping execution

## Troubleshooting

### Common Issues

1. **netcoredbg not found**: Install with `dotnet tool install --global netcoredbg`
2. **No debugging config available**: Ensure you're in a .NET project directory
3. **Breakpoints not hitting**: Check that you're building in Debug configuration
4. **Attach fails**: Make sure the process is running and you have permission to attach

### Debug Adapter Configuration

If you need to configure debug adapters manually, edit the dap configuration in `lua/custom/plugins/init.lua`.

## Integration with Existing Plugins

The debugger integrates with:
- **LSP**: Works with roslyn.nvim for C# support
- **fzf-lua**: Use `<leader>fD` to find workspace diagnostics
- **gitsigns**: Debug with git blame integration

## Next Steps

- Explore the DAP documentation with `:help dap`
- Check `:help nvim-dap-ui` for UI customization
- Learn more about C# debugging with .NET CLI