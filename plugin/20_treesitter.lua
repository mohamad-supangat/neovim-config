require('tree-sitter-manager').setup({
  ensure_installed = {
    'lua',
    'markdown_inline',
    'vimdoc',
    'lua',
    'typescript',
    'vue',
    'pug',
    'python',
    'php',
    'phpdoc',
    'prisma',
    'markdown',
    'html',
    'blade',
    'vim',
    'json',
    'css',
    'dockerfile',
    'bash',
    'fish',
    'javascript',
    'scss',
    'http',
    'xml',
    'yaml',
  },
})

-- auto start treesitter
vim.api.nvim_create_autocmd('FileType', {
  pattern = '*',
  callback = function()
    -- Check if a parser exists for the current file type before starting
    local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
    if lang and vim.treesitter.language.add(lang) then
      pcall(vim.treesitter.start)
      vim.bo.autoindent = true
    end
  end,
})
