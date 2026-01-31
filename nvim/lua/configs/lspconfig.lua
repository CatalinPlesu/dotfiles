-- !!! https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = { "html", "cssls", "ansiblels", "eslint", "jsonls", "ts_ls", "yamlls", "dockerls" }

-- lsps with default config
require("nvchad.configs.lspconfig").defaults()
vim.lsp.enable(servers)

-- BICEP
vim.filetype.add({ extension = { ramboefile = "bicep" } }) -- DEMO map .ramboefile to .bicep so it triggerd the bicep-lsp

local bicep_mason_path = vim.fn.stdpath("data") ..
    "/mason/packages/bicep-lsp/extension/bicepLanguageServer/Bicep.LangServer.dll"

vim.lsp.config("bicep", {
  cmd = { "dotnet", bicep_mason_path },
  filetypes = { "bicep" },
})

vim.lsp.enable("bicep")
-- END BICEP

-- CADDY

vim.filetype.add {
  extension = {
    caddy = 'caddy',
  },
  filename = {
    Caddyfile = 'caddy',
  },
}


-- ROSLYN (+razor support)
local mason_root = require("mason.settings").current.install_root_dir

vim.lsp.config("roslyn", {})
-- END ROSLYN

-- An example nvim-lspconfig capabilities setting
-- local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

vim.lsp.enable("markdown_oxide")

-- IMPORTANT: vim diagnostic configuration AFTER LSPs are loaded
vim.diagnostic.config(
  {
    underline = false,
    virtual_text = false,
    update_in_insert = false,
    severity_sort = true,
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = " ",
        [vim.diagnostic.severity.WARN] = " ",
        [vim.diagnostic.severity.HINT] = " ",
        [vim.diagnostic.severity.INFO] = " ",
      }
    }
  }
)
