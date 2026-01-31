-- {
-- "background": "#262626",
-- "black": "#262626",
-- "blue": "#6C95EB",
-- "brightBlack": "#323232",
-- "brightBlue": "#0000FF",
-- "brightCyan": "#00FFFF",
-- "brightGreen": "#39CC8F",
-- "brightPurple": "#ED94C0",
-- "brightRed": "#F44747",
-- "brightWhite": "#FFFFFF",
-- "brightYellow": "#FFFF00",
-- "cursorColor": "#D8D8DD",
-- "cyan": "#008080",
-- "foreground": "#A5A5AA",
-- "green": "#85C46C",
-- "name": "Rider Dark",
-- "purple": "#C191FF",
-- "red": "#800000",
-- "selectionBackground": "#08335E",
-- "white": "#FFFFFF",
-- "yellow": "#C9A26D"
-- }

-- credits to original theme https://rosepinetheme.com/
-- this is a modified version of it

local M = {}

M.base_30 = {
  black = "#262626", --  nvim bg
  darker_black = "#13111e",
  white = "#FFFFFF",
  black2 = "#1f1d2a",
  one_bg = "#262626", -- real bg of onedark
  one_bg2 = "#262626",
  one_bg3 = "#262626",
  grey = "#3f3d4a",
  grey_fg = "#474552",
  grey_fg2 = "#514f5c",
  light_grey = "#5d5b68",
  red = "#800000",
  baby_pink = "#f5799c",
  pink = "#ff83a6",
  line = "#2e2c39", -- for lines like vertsplit
  green = "#85C46C",
  vibrant_green = "#39CC8F",
  nord_blue = "#6C95EB",
  blue = "#6C95EB",
  yellow = "#C9A26D",
  sun = "#fec97f",
  purple = "#ED94C0",
  dark_purple = "#C191FF",
  teal = "#6aadc8",
  orange = "#f6c177",
  cyan = "#008080",
  statusline_bg = "#201e2b",
  lightbg = "#2d2b38",
  pmenu_bg = "#c4a7e7",
  folder_bg = "#6aadc8",
}

M.base_16 = {
  base00 = "#191724",
  base01 = "#1f1d2e",
  base02 = "#26233a",
  base03 = "#6e6a86",
  base04 = "#908caa",
  base05 = "#e0def4",
  base06 = "#e0def4",
  base07 = "#524f67",
  base08 = "#eb6f92",
  base09 = "#f6c177",
  base0A = "#ebbcba",
  base0B = "#31748f",
  base0C = "#9ccfd8",
  base0D = "#c4a7e7",
  base0E = "#f6c177",
  base0F = "#524f67",
}

M.polish_hl = {
  treesitter = {
    ["@function"] = { bold = true },
    ["@function.builtin"] = { bold = true },
    ["@function.call"] = { bold = true, fg = M.base_30.dark_purple },
    ["@constructor"] = { fg = M.base_30.purple },
    ["@variable.parameter"] = { fg = M.base_30.white },
    ["@module"] = { fg = M.base_30.deep_black },
    ["@symbol"] = { fg = M.base_30.purple },
    ["@keyword"] = { fg = M.base_30.purple },
    ["@function.method.call"] = { bold = true },
  },

  telescope = {
    TelescopeMatching = { fg = M.base_30.purple, bg = M.base_30.one_bg2 },
  },

  nvdash = {
    NvDashAscii = { fg = M.base_30.gray_fg, bg = M.base_30.purple },
  },
}

-- M = require("base46").override_theme(M, "rosepine")
M = require("base46").override_theme(M, "mountain")

M.type = "dark"

return M
