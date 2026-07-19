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

local null_ls = require('null-ls')
null_ls.setup({
  cache = false,
  debug = false,
  temp_dir = '/tmp',
  -- on_attach = require("lsp.handlers").on_attach,
  sources = {
    null_ls.builtins.completion.tags,
    null_ls.builtins.completion.spell,
    -- null_ls.builtins.formatting.biome,
    null_ls.builtins.formatting.blade_formatter,
    null_ls.builtins.formatting.fish_indent,
    null_ls.builtins.formatting.dart_format,
    null_ls.builtins.formatting.phpcsfixer.with({
      condition = function(utils)
        return utils.root_has_file({ '.php_cs.dist', '.php_cs', 'composer.json', '.rootdir' })
      end,
    }),
    null_ls.builtins.formatting.prettier.with({
      extra_filetypes = { 'toml', 'css', 'json5', 'vue', 'jsonc' },
      condition = function(utils)
        return utils.root_has_file({ '.prettierrc' })
      end,
    }),

    null_ls.builtins.diagnostics.fish,
    null_ls.builtins.diagnostics.phpcs,
    null_ls.builtins.diagnostics.editorconfig_checker,
    null_ls.builtins.hover.dictionary,
  },
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
keymap('n', 'fm', function()
  -- 1. Format using everything EXCEPT null-ls
  vim.lsp.buf.format({
    filter = function(client)
      return client.name ~= 'null-ls'
    end,
    async = true,
  })
  -- 2. Format using ONLY null-ls
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == 'null-ls'
    end,
    async = true,
  })
end, { desc = 'Format' })
keymap('x', '<Leader>fm', '<Cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format selection' })
