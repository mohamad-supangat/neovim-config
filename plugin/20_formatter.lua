local util = require('conform.util')
require('conform').setup({
  formatters_by_ft = {
    ['*'] = { 'trim_whitespace', 'trim_newlines' },
    dart = { 'dart_format' },
    lua = { 'stylua' },
    python = { 'blue', 'ruff_fix', 'ruff_format' },
    php = { 'php_cs_fixer', 'lsp' },
    blade = { 'blade-formatter' },
    javascript = { 'prettier' },
    markdown = { 'prettier' },
    typescript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescriptreact = { 'prettier' },
    json = { 'prettier' },
    jsonc = { 'prettier' },
    json5 = { 'prettier' },
    vue = { 'prettier' },
    pug = { 'prettier' },
    html = { 'prettier' },
    css = { 'prettier' },
    scss = { 'prettier' },
    sass = { 'prettier' },
    bash = { 'shfmt' },
    fish = { 'fish_indent' },
    sh = { 'shfmt' },
    nginx = { 'nginxfmt' },
    http = { 'kulala' },
    sql = { 'sqruff' },
    jinja = { 'djlint' },
  },

  formatters = {
    kulala = {
      command = 'kulala-fmt',
      args = { 'format', '$FILENAME' },
      stdin = false,
    },
    php_cs_fixer = {
      command = 'php-cs-fixer',
      env = {
        PHP_CS_FIXER_IGNORE_ENV = '1',
      },
      args = { 'fix', '$FILENAME' },
      stdin = false,
      cwd = util.root_file({ '.rootdir', 'composer.json' }),
    },
  },
})

function format()
  vim.lsp.buf.format({ async = false })
  require('conform').format({ lsp_fallback = true, async = true })
end

local keymap = vim.keymap.set

keymap({ 'n', 'x' }, 'fm', format, { noremap = true, silent = true, desc = 'Format' })
keymap({ 'n', 'x' }, 'fM', format, { noremap = true, silent = true, desc = 'Format' })
