local opt = {
  -- ...
  signs = {
    left = "",
    right = "",
    diag = "●",
    arrow = "    ",
    up_arrow = "    ",
    vertical = " │",
    vertical_end = " └",
  },
  blend = {
    factor = 0.22,
  },
  -- ...
}

require("tiny-inline-diagnostic").setup(opt)

vim.diagnostic.config({ virtual_text = false })       -- Only if needed in your configuration, if you already have native LSP diagnostics
