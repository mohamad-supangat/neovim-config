local italics_groups = {
  'Comment',
  'Conditional',
  'Identifier',
  'SpecialChar',
  'SpecialComment',
  'String',
  'Todo',
  'CmpItemKind',
  'NvimTreeGitRenamed',
  'NvimTreeOpenedFile',
  'NvimTreeRootFolder',
}

local function update_hl(group)
  local old_hl = vim.api.nvim_get_hl(0, {
    name = group,
  })

  local new_hl = vim.tbl_extend('force', old_hl, { italic = true })
  vim.api.nvim_set_hl(0, group, new_hl)
end

local function _add_highlights()
  for _, group in ipairs(italics_groups) do
    update_hl(group)
  end
end

local function add_highlights()
  -- ? some plugins calculate colors from basic highlights
  -- : clear immediately
  _add_highlights()
  -- ? some plugins use autocommands to redefine highlights
  -- : clear again after a while
  vim.defer_fn(_add_highlights, 500)
  -- again
  vim.defer_fn(_add_highlights, 1000)
  -- yes, clear 4 times!!!
  vim.defer_fn(_add_highlights, 5000)
end

local function toggle_italics(option)
  if option == nil then
    vim.g.italics_enabled = not vim.g.italics_enabled
  else
    vim.g.italics_enabled = option
  end
  if vim.g.colors_name then
    vim.cmd('colorscheme ' .. vim.g.colors_name)
  else
    vim.cmd('doautocmd ColorScheme')
  end
end

vim.api.nvim_create_autocmd({ 'BufEnter', 'VimEnter', 'ColorScheme' }, {
  pattern = '*',
  callback = function(args)
    add_highlights()
  end,
})
