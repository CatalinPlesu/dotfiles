require("fzf-lua").setup({
  -- preview window is in fullscreen and takes 70% of the space and is above the search results
  winopts = {
    fullscreen = true,
    preview = {
      layout = "vertical",
      vertical = "up:70%",
    },
  },

  -- use exact string matching, but only for the files picker

  grep_curbuf = {
    fzf_opts = {
      -- ['--exact'] = '',
      -- ['--no-sort'] = '',
      ["--cycle"] = "",
    }
  },
  files = {
    fzf_opts = {
      -- ['--exact'] = '',
      -- ['--no-sort'] = '',
      ["--cycle"] = "",
    }
  },

  -- use cltr-q to select all items and convert to quickfix list (as in telescope)
  keymap = {
    fzf = {
      ["ctrl-q"] = "select-all+accept",
    },
  },

  diagnostics = {
    cwd_only       = false,
    file_icons     = false,
    git_icons      = false,
    color_headings = true, -- use diag highlights to color source & filepath
    diag_icons     = true, -- display icons from diag sign definitions
    diag_source    = true, -- display diag source (e.g. [pycodestyle])
    diag_code      = true, -- display diag code (e.g. [undefined])
    icon_padding   = '',   -- add padding for wide diagnostics signs
    multiline      = 2,    -- split heading and diag to separate lines
    -- severity_only  = 1
    -- severity_only:   keep any matching exact severity
    -- severity_limit:  keep any equal or more severe (lower)
    -- severity_bound:  keep any equal or less severe (higher)
  }
})
-- use `fzf-lua` for replace vim.ui.select
require("fzf-lua").register_ui_select()
