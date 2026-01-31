-- lua/utils/require_all.lua
local M = {}

--- Require every module under `lua/<dir>/*.lua` across the whole runtimepath.
--- If a module returns a function, call it with the provided args.
--- Example: require_all("custom-mappings", map, opts)
---@param dir string  -- e.g. "custom-mappings"
---@param ... any     -- args passed to a function that the module returns
function M.require_all(dir, ...)
  local args = { ... }

  -- Find files on the whole runtimepath (works for config + plugins)
  local pattern = "lua/" .. dir .. "/*.lua"
  local files = vim.api.nvim_get_runtime_file(pattern, true)

  -- Keep a stable load order
  table.sort(files)

  local function to_modname(path)
    -- turn ".../lua/custom-mappings/mappings-lsp.lua" -> "custom-mappings.mappings-lsp"
    local m = path:match("[/\\]lua[/\\](.*)%.lua$")
    if not m then return nil end
    return (m:gsub("[/\\]", "."))
  end

  for _, file in ipairs(files) do
    local mod = to_modname(file)
    if mod then
      local ok, loaded = pcall(require, mod)
      if not ok then
        vim.notify(("require('%s') failed: %s"):format(mod, loaded), vim.log.levels.ERROR)
      elseif type(loaded) == "function" then
        local ok2, err = pcall(loaded, table.unpack(args))
        if not ok2 then
          vim.notify(("Module '%s' init failed: %s"):format(mod, err), vim.log.levels.ERROR)
        end
      end
    end
  end
end

return M
