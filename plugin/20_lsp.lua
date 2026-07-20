local capabilities = require('lsp.capabilities')
vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.enable({
  'dartls',
})
vim.diagnostic.config({
  signs = {
    text = {
      -- [vim.diagnostic.severity.ERROR] = '✘',
      -- [vim.diagnostic.severity.WARN] = '▲',
      -- [vim.diagnostic.severity.HINT] = '⚑',
      -- [vim.diagnostic.severity.INFO] = '»',
    },
  },
  severity_sort = true,
  update_in_insert = true,
})
require('mason').setup()
require('mason-lspconfig').setup({
  automatic_enable = true,
})

local keymap = vim.keymap.set
keymap('n', 'K', vim.lsp.buf.hover, { desc = 'LSP: Hover Documentation' })
keymap('n', 'gd', vim.lsp.buf.definition, { desc = 'LSP: Go to Definition' })
keymap('n', 'gD', vim.lsp.buf.declaration, { desc = 'LSP: Go to Declaration' })
keymap('n', 'gi', vim.lsp.buf.implementation, { desc = 'LSP: Go to Implementation' })
keymap('n', 'go', vim.lsp.buf.type_definition, { desc = 'LSP: Go to Type Definition' })
keymap('n', 'gr', vim.lsp.buf.references, { desc = 'LSP: Find References' })
keymap('n', 'gl', vim.diagnostic.open_float, { desc = 'LSP: Show Diagnostics' })
keymap('n', 'gs', vim.lsp.buf.signature_help, { desc = 'LSP: Signature Help' })
keymap('n', 'rn', vim.lsp.buf.rename, { desc = 'LSP: Rename Symbol' })
keymap('n', 'ca', vim.lsp.buf.code_action, { desc = 'LSP: Code Action' })
