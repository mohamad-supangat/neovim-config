local languages = {
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
}

require('nvim-treesitter').setup({ install_dir = vim.fn.stdpath('data') .. '/site' })
require('nvim-treesitter').install(languages)
require('nvim-ts-autotag').setup({
  opts = {
    enable_close = true,
    enable_rename = true,
    enable_close_on_slash = false,
  },
  aliases = {
    ['blade'] = 'html',
    ['html.handlebars'] = 'html',
  },
})
-- -- auto start treesitter
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = '*',
--   callback = function()
--     -- Check if a parser exists for the current file type before starting
--     local lang = vim.treesitter.language.get_lang(vim.bo.filetype)
--     if lang and vim.treesitter.language.add(lang) then
--       pcall(vim.treesitter.start)
--       vim.bo.autoindent = true
--     end
--   end,
-- })
