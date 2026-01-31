local opt = vim.opt

opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"

-- opt.nofoldenable = true
opt.foldlevelstart = 99

return {}
