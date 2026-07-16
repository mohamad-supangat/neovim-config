require('mason').setup()
require('mason-lspconfig').setup()

local nuls = require('null-ls')

nuls.setup({
  cache = false,
  debug = false,
  temp_dir = '/tmp',
  -- on_attach = require("lsp.handlers").on_attach,
  sources = {
    nuls.builtins.completion.tags,
    nuls.builtins.formatting.blade_formatter,
    -- nuls.builtins.completion.spell,
    -- nuls.builtins.completion.nvim_snippets,
    -- nuls.builtins.completion.luasnip,
    -- nuls.builtins.formatting.biome,
    nuls.builtins.formatting.phpcsfixer.with({
      condition = function(utils)
        return utils.root_has_file({ '.php_cs.dist', '.php_cs', 'composer.json' })
      end,
    }),
    nuls.builtins.formatting.prettier.with({
      extra_filetypes = { 'toml', 'css', 'json5', 'vue', 'jsonc' },
      condition = function(utils)
        return utils.root_has_file({ '.prettierrc' })
      end,
    }),

    nuls.builtins.formatting.buf,
    nuls.builtins.diagnostics.buf,

    nuls.builtins.diagnostics.fish,
    -- nuls.builtins.diagnostics.editorconfig_checker,
    nuls.builtins.hover.dictionary,
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
keymap('n', '<Leader>fm', '<Cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format' })
keymap('x', '<Leader>fm', '<Cmd>lua vim.lsp.buf.format()<CR>', { desc = 'Format selection' })
