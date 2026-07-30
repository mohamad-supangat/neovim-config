vim.bo.commentstring = '{{-- %s --}}'

function format()
  require('conform').format({ lsp_fallback = false, async = false })
  vim.lsp.buf.format({ async = false })
end

local keymap = vim.keymap.set

keymap({ 'n', 'x' }, 'fm', format, { noremap = true, silent = true, desc = 'Format' })
keymap({ 'n', 'x' }, 'fM', format, { noremap = true, silent = true, desc = 'Format' })
