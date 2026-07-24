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
local isnt_installed = function(lang)
  return #vim.api.nvim_get_runtime_file('parser/' .. lang .. '.*', false) == 0
end
local to_install = vim.tbl_filter(isnt_installed, languages)
if #to_install > 0 then
  require('nvim-treesitter').install(to_install)
end

-- Enable tree-sitter after opening a file for a target language
local filetypes = {}
for _, lang in ipairs(languages) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(lang)) do
    table.insert(filetypes, ft)
  end
end
local ts_start = function(ev)
  vim.treesitter.start(ev.buf)
  ev.buf.autoindent = true
  ev.buf.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
end
Config.new_autocmd('FileType', filetypes, ts_start, 'Start tree-sitter')
