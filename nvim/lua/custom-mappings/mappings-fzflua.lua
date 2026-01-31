local fzf = require("fzf-lua")

map("n", "gm", fzf.marks, "FZF Marks")
map("n", "<leader>da", fzf.diagnostics_workspace, "FZF Diagnostics")
map("n", "<leader>ds", function() fzf.diagnostics_workspace({ severity_only = 1 }) end, "FZF Diagnostics (errors)")

map("n", "gr", fzf.lsp_references, "FZF References")
map("n", "gR", fzf.lsp_references, "FZF References")
map("n", "<leader>fs", fzf.lsp_document_symbols, "FZF Document symbols")
map("n", "<leader>i", fzf.lsp_implementations, "FZF Implementations")

map("n", "T", fzf.buffers, "FZF Buffers")

-- New FZF bindings
map("n", "<leader>ff", fzf.files, "Find files")
map("n", "<leader>fg", fzf.live_grep, "Live grep")
map("n", "<leader>fb", fzf.buffers, "Find buffers")
map("n", "<leader>fh", fzf.help_tags, "Help tags")
map("n", "<leader>fo", fzf.oldfiles, "Recent files")
map("n", "<leader>fw", fzf.grep_cword, "Find word")
map("n", "<leader>fc", fzf.commands, "Commands")
map("n", "<leader>fk", fzf.keymaps, "Keymaps")
map("n", "<leader>fd", fzf.diagnostics_document, "Document diagnostics")
map("n", "<leader>fD", fzf.diagnostics_workspace, "Workspace diagnostics")
map("n", "<leader>/", fzf.blines, "Buffer lines")
map("n", "<leader><leader>", fzf.buffers, "Buffers")

-- overrides
map("n", "<leader>fz", fzf.grep_curbuf, "FZF grep current buffer")
map("n", "<leader>gt", fzf.git_status, "FZF Git status")
map("n", "<leader>qo", fzf.quickfix, "FZF Quickfix")
map("n", "<leader>qO", fzf.lgrep_quickfix, "FZF Grep → quickfix")
map("n", "<leader>ca", fzf.lsp_code_actions, "FZF Code actions")
map("n", "<leader>?", fzf.builtin, "FZF Builtins")
