-- This file needs to have same structure as nvconfig.lua 
-- https://github.com/NvChad/ui/blob/v3.0/lua/nvconfig.lua
-- Please read that file to know all available options :( 

---@type ChadrcConfig
local M = {}

M.base46 = {

  theme = "gruvbox",

  hl_override = {
    Type = { bold = true, italic = false },
    ["@comment"] = { italic = true },

    --- https://neovim.io/doc/user/treesitter.html#treesitter-highlight-groups
    ["@keyword"] = { italic = true },
    ["@function.method"] = { italic = true },
    ["@function.method.call"] = { bold = true },
  }
}

M.ui = {
  statusline = {
    order = { "mode", "file", "git", "%=", "lsp_msg", "%=", "diagnostics", "lsp", "wakatime", "cwd", "cursor" },
    modules = {
      wakatime = function()
        local wt = require("custom-config.wakatime-status")
        return wt.get_status()
      end,
    },
  },
}

return M
