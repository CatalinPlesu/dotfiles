fn = vim.fn
api = vim.api
cmd = vim.cmd
opt = vim.opt
g = vim.g

local modules = {
  -- 'options',
  'mappings',
  'plugins',
}

for i, a in ipairs(modules) do
  local ok, err = pcall(require, a)
  if not ok then 
    error("Error calling " .. a .. err)
  end
end

-- Auto commands
cmd [[
  au TermOpen term://* setlocal nonumber norelativenumber signcolumn=no | setfiletype terminal
]]
