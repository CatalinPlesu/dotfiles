local opts = {
  async = true,
  formatters_by_ft = {
    cs = { "csharpier" },
    css = { "prettier" },
    html = { "prettier" },
    csproj = { "xmlformat" },
    xml = { "xmlformat" },
    caddy = { 'caddy' },
  },
  formatters = {
    xmlformat = {
      command = "xmlformat",
      -- args = { "--overwrite" },
    },
    csharpier = {
      command = "csharpier",
      args = {
        "format",
        "--write-stdout",
      },
      to_stdin = true,
    },
    caddy = {
      command = 'caddy',
      args = { 'fmt', '-' },
      stdin = true,
    },
  },
  format_on_save = {
    -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

require("conform").setup(opts)
