require('mason').setup()
require('mason-lspconfig').setup({
  automatic_enable = true,
})

local null_ls = require('null-ls')

vim.lsp.enable({
  'dartls',
})

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
keymap('n', 'ca', '<Cmd>lua vim.lsp.buf.code_action()<CR>', { desc = 'Actions' })
keymap('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'LSP signature help' })
keymap('n', 'gl', '<Cmd>lua vim.diagnostic.open_float()<CR>', { desc = 'Diagnostic popup' })
keymap('n', '<space>xx', '<Cmd>lua vim.diagnostic.setqflist()<CR>', { desc = 'Diagnostic All' })
keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', { desc = 'Hover' })
keymap('n', 'rn', '<Cmd>lua vim.lsp.buf.rename()<CR>', { desc = 'Rename' })
keymap('n', 'gr', '<Cmd>lua vim.lsp.buf.references()<CR>', { desc = 'References' })
keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', { desc = 'Source definition' })
keymap('n', 'go', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { desc = 'Type definition' })
keymap('n', '<Leader>fm', function()
  -- 1. Format using everything EXCEPT null-ls
  vim.lsp.buf.format({
    filter = function(client)
      return client.name ~= 'null-ls'
    end,
    async = false,
  })
  -- 2. Format using ONLY null-ls
  vim.lsp.buf.format({
    filter = function(client)
      return client.name == 'null-ls'
    end,
    async = false,
  })
end, { desc = 'Format' })
keymap('x', '<Leader>fm', '<Cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format selection' })
