-- Credits to https://github.com/fenetikm/falcon as its the orignal theme
-- This is a modified version of original theme
---@type Base46Table
local M = {}

M.base_30 = {
  white = "#F8F8FF",
  -- white2 = "#DFDFE5",
  -- white2 = "#ff00f0",
  tan = "#CFC1B2",

  -- darker_black = "#0c0c2d",
  -- darker_black = "#2E32C1",

  -- black = "#020222", --  nvim bg
  -- black = "#0e1147", --  nvim bg 

  -- black = "#161636", --  nvim bg
  -- black2 = "#1A1A3A",
  -- black2 = "#475AFF",
  -- one_bg = "#0e1147",

  -- one_bg2 = "#202040",
  -- one_bg3 = "#2a2a4a",

  -- one_bg2 = "#0e1147",
  -- one_bg3 = "#0e1147",




  darker_black = "#0c0c2d",
  black = "#020222", --  nvim bg
  black2 = "#1A1A3A",
  one_bg = "#161636",
  one_bg2 = "#202040",
  one_bg3 = "#2a2a4a",

  grey = "#243CBF",    --line numbers
  grey_fg = "#243CBF", --comments
  grey_fg2 = "#4d4d6d",
  light_grey = "#5c5c7c",
  red = "#FF761A",
  baby_pink = "#FF8E78",
  pink = "#ffafb7",
  line = "#202040", -- for lines like vertsplit
  green = "#9BCCBF",
  vibrant_green = "#b9e75b",
  nord_blue = "#a1bce1",
  blue = "#6699cc",
  yellow = "#FFC552",
  sun = "#FFD392",
  purple = "#99A4BC",
  dark_purple = "#635196",
  teal = "#34BFA4",
  orange = "#f99157",
  cyan = "#BFDAFF",
  statusline_bg = "#0b0b2b",
  -- statusline_bg = "#0e1147",
  lightbg = "#2a2a4a",
  pmenu_bg = "#FFB07B",
  folder_bg = "#598cbf",
}

-- https://github.com/chriskempson/base16/blob/main/styling.md
-- https://github.com/chriskempson/base16
M.base_16 = {
  -- base00 = "#0e1147", --Default Background

  -- base01 = "#0e1147", --Lighter Background (Used for status bars, line number and folding marks)
  -- base01 = "#0b0b2b", --Lighter Background (Used for status bars, line number and folding marks)

  -- base02 = "#ffffff", --Selection Background
  -- base03 = "#f6d5f5", --Comments, Invisibles, Line Highlighting

  base00 = "#020222",
  base01 = "#0b0b2b",
  base02 = "#161636",
  base03 = "#202040",

  base04 = "#e4e4eb", --Dark Foreground (Used for status bars)
  base05 = "#eeeef5", --Default Foreground, Caret, Delimiters, Operators

  base06 = "#f3f3fa", --Light Foreground (Not often used)
  base07 = "#F8F8FF", --Light Background (Not often used)
  base08 = "#BFDAFF", --Variables, XML Tags, Markup Link Text, Markup Lists, Diff Deleted
  base09 = "#B4B4B9", --Integers, Boolean, Constants, XML Attributes, Markup Link Url
  base0A = "#FFC552", --Classes, Markup Bold, Search Text Background
  base0B = "#f2e4b8", --Strings, Inherited Class, Markup Code, Diff InsertReplaceEdits
  base0C = "#B4B4B9", --Support, Regular Expressions, Escape Characters, Markup Quotes
  base0D = "#FFC552", --Functions, Methods, Attribute IDs, Headings
  base0E = "#8BCCBF", --Keywords, Storage, Selector, Markup Italic, Diff Changed
  base0F = "#DFDFE5", --Deprecated, Opening/Closing Embedded Language Tags, e.g. <?php ?>
}

M.polish_hl = {
  syntax = {
    Statement = { fg = M.base_30.purple },
    Type = { fg = M.base_30.pmenu_bg, bold = true, italic = true },
    Include = { fg = M.base_30.tan },
    Keyword = { fg = M.base_16.base0D },
    Operator = { fg = M.base_30.red },
  },

  --- https://neovim.io/doc/user/treesitter.html#treesitter-highlight-groups
  treesitter = {
    ["@function"] = { bold = true, italic = true },
    ["@function.builtin"] = { bold = true },
    ["@function.call"] = { bold = true, fg = M.base_30.dark_purple },
    ["@constructor"] = { fg = M.base_30.purple },
    ["@variable.parameter"] = { fg = M.base_30.white },
    ["@module"] = { fg = M.base_30.deep_black },
    ["@symbol"] = { fg = M.base_30.purple },
    ["@keyword"] = { italic = true, fg = M.base_30.purple },
    ["@function.method.call"] = { bold = true },
    -- ["@comment"] = { italic = true, bg = M.base_30.baby_pink },
    -- ["@comment"] = { bold = true, italic = true, bg = M.base_30.red },
    -- ["@keyword"] = { fg = M.base_16.base0D },
  },
}

M.type = "dark"

M = require("base46").override_theme(M, "falcon-custom")

return M
