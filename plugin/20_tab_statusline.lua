--------------------------------------------------------------------------------
-- UTILS COMMON
--------------------------------------------------------------------------------
local function escape_text(text)
  return text:gsub('%%', '%%%%')
end

local function get_icon(filename)
  local ok, mini_icons = pcall(require, 'mini.icons')
  if ok and mini_icons.get then
    local icon = select(1, mini_icons.get('file', filename))
    if icon and icon ~= '' then
      return icon .. ' '
    end
  end
  return ''
end

local function truncate_path(path, chars, full_dirs)
  local parts = vim.split(path, '/', { trimempty = true })
  local truncated = {}
  local n_parts = #parts

  for i, component in ipairs(parts) do
    if i > (n_parts - full_dirs) then
      table.insert(truncated, component)
    else
      local len = #component
      if len > chars then
        table.insert(truncated, component:sub(1, chars))
      else
        table.insert(truncated, component)
      end
    end
  end

  return table.concat(truncated, '/')
end

--------------------------------------------------------------------------------
-- TABLINE SETUP (Independent Highlights)
--------------------------------------------------------------------------------
local function setup_tabline_highlights()
  local hl_fill = vim.api.nvim_get_hl(0, { name = 'TabLineFill', link = false })
  local hl_tab = vim.api.nvim_get_hl(0, { name = 'TabLine', link = false })

  local bg_fill = hl_fill.bg or 'NONE'
  local bg_tab = hl_tab.bg or 'NONE'
  local fg_active = '#111111' -- Teks gelap agar kontras dengan background putih
  local bg_active = '#ffffff' -- Custom Background Putih untuk Tab Aktif

  -- Custom Group Tabline
  vim.api.nvim_set_hl(0, 'PillTablineActive', { fg = fg_active, bg = bg_active, bold = true })
  vim.api.nvim_set_hl(0, 'PillTablineSepSel', { fg = bg_active, bg = bg_fill })
  vim.api.nvim_set_hl(0, 'PillTablineSep', { fg = bg_tab, bg = bg_fill })
end

_G.PillTablineGoToBuffer = function(buf)
  buf = tonumber(buf)
  if buf and vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.api.nvim_set_current_buf, buf)
  end
end

local function get_buf_label(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local filename = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
  local label = get_icon(filename) .. filename
  if vim.bo[buf].modified then
    label = label .. ' '
  end
  return escape_text(label)
end

_G.PillTabline = function()
  local parts = { '%#TabLineFill#%= ' }

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local is_current = (buf == vim.api.nvim_get_current_buf())
      local body_hl = is_current and 'PillTablineActive' or 'TabLine'
      local sep_hl = is_current and 'PillTablineSepSel' or 'PillTablineSep'
      local label = get_buf_label(buf)

      local path_str = ''
      if is_current then
        local path = vim.fs.normalize(vim.fn.expand('%:.:h'))
        path = truncate_path(path, 1, 1)
        path = ' ' .. path
        path_str = string.format('%%#Directory#%s%%#TabLineFill# ', path)
      end

      table.insert(
        parts,
        string.format(
          '%%%d@v:lua.PillTablineGoToBuffer@%%#%s#%%#%s# %s %%#%s#%%X%%#TabLineFill# %s',
          buf,
          sep_hl,
          body_hl,
          label,
          sep_hl,
          path_str
        )
      )
    end
  end

  table.insert(parts, '%#TabLineFill#%=')
  return table.concat(parts)
end

--------------------------------------------------------------------------------
-- STATUSLINE SETUP (Independent Highlights - Transparent Base)
--------------------------------------------------------------------------------
local function setup_statusline_highlights()
  local hl_norm = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })

  local bg_fill = 'NONE' -- Transparan khusus statusline
  local fg_text = hl_norm.fg or '#ffffff'
  local bg_active = '#333333'

  -- Pastikan hanya StatusLine yang transparan (Jangan sentuh TabLineFill)
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = 'NONE' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = 'NONE' })

  -- Custom Group Statusline
  vim.api.nvim_set_hl(0, 'PillStatusActive', { fg = fg_text, bg = bg_active, bold = true })
  vim.api.nvim_set_hl(0, 'PillStatusSep', { fg = bg_active, bg = bg_fill })

  -- Mode Colors
  vim.api.nvim_set_hl(0, 'PillStatusModeNormal', { fg = '#111111', bg = '#7aa2f7', bold = true })
  vim.api.nvim_set_hl(0, 'PillStatusModeNormalSep', { fg = '#7aa2f7', bg = bg_fill })

  vim.api.nvim_set_hl(0, 'PillStatusModeInsert', { fg = '#111111', bg = '#9ece6a', bold = true })
  vim.api.nvim_set_hl(0, 'PillStatusModeInsertSep', { fg = '#9ece6a', bg = bg_fill })

  vim.api.nvim_set_hl(0, 'PillStatusModeVisual', { fg = '#111111', bg = '#bb9af7', bold = true })
  vim.api.nvim_set_hl(0, 'PillStatusModeVisualSep', { fg = '#bb9af7', bg = bg_fill })

  vim.api.nvim_set_hl(0, 'PillStatusModeReplace', { fg = '#111111', bg = '#f7768e', bold = true })
  vim.api.nvim_set_hl(0, 'PillStatusModeReplaceSep', { fg = '#f7768e', bg = bg_fill })

  vim.api.nvim_set_hl(0, 'PillStatusModeCommand', { fg = '#111111', bg = '#e0af68', bold = true })
  vim.api.nvim_set_hl(0, 'PillStatusModeCommandSep', { fg = '#e0af68', bg = bg_fill })
end

local mode_map = {
  ['n'] = { name = 'NORMAL', hl = 'PillStatusModeNormal', sep = 'PillStatusModeNormalSep' },
  ['no'] = { name = 'N-OPER', hl = 'PillStatusModeNormal', sep = 'PillStatusModeNormalSep' },
  ['v'] = { name = 'VISUAL', hl = 'PillStatusModeVisual', sep = 'PillStatusModeVisualSep' },
  ['V'] = { name = 'V-LINE', hl = 'PillStatusModeVisual', sep = 'PillStatusModeVisualSep' },
  ['\22'] = { name = 'V-BLOCK', hl = 'PillStatusModeVisual', sep = 'PillStatusModeVisualSep' },
  ['s'] = { name = 'SELECT', hl = 'PillStatusModeVisual', sep = 'PillStatusModeVisualSep' },
  ['S'] = { name = 'S-LINE', hl = 'PillStatusModeVisual', sep = 'PillStatusModeVisualSep' },
  ['i'] = { name = 'INSERT', hl = 'PillStatusModeInsert', sep = 'PillStatusModeInsertSep' },
  ['ic'] = { name = 'INSERT', hl = 'PillStatusModeInsert', sep = 'PillStatusModeInsertSep' },
  ['R'] = { name = 'REPLACE', hl = 'PillStatusModeReplace', sep = 'PillStatusModeReplaceSep' },
  ['Rv'] = { name = 'V-REPL', hl = 'PillStatusModeReplace', sep = 'PillStatusModeReplaceSep' },
  ['c'] = { name = 'COMMAND', hl = 'PillStatusModeCommand', sep = 'PillStatusModeCommandSep' },
  ['cv'] = { name = 'VIM EX', hl = 'PillStatusModeCommand', sep = 'PillStatusModeCommandSep' },
  ['t'] = { name = 'TERMINAL', hl = 'PillStatusModeInsert', sep = 'PillStatusModeInsertSep' },
}

local function get_macro_status()
  local recording_register = vim.fn.reg_recording()
  if recording_register == '' then
    return ''
  end
  local text = '󰑊 Recording @' .. recording_register
  return string.format(
    ' %%#PillStatusModeReplaceSep#%%#PillStatusModeReplace# %s %%#PillStatusModeReplaceSep#',
    text
  )
end

local function get_diagnostics()
  if not rawget(vim, 'lsp') then
    return ''
  end
  local count_err = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
  local count_warn = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })

  local res = {}
  if count_err > 0 then
    table.insert(res, string.format('%%#DiagnosticError#E:%d', count_err))
  end
  if count_warn > 0 then
    table.insert(res, string.format('%%#DiagnosticWarn#W:%d', count_warn))
  end

  if #res > 0 then
    return ' ' .. table.concat(res, ' ') .. ' '
  end
  return ''
end

local function get_git_branch()
  local branch = vim.b.gitsigns_head or vim.g.actual_curbuf_branch
  if not branch or branch == '' then
    if vim.fn.exists('*FugitiveHead') == 1 then
      branch = vim.fn.FugitiveHead()
    end
  end
  if branch and branch ~= '' then
    return ' ' .. branch
  end
  return ''
end

_G.PillStatusline = function()
  local mode_info = mode_map[vim.api.nvim_get_mode().mode]
    or {
      name = 'UNKNOWN',
      hl = 'PillStatusActive',
      sep = 'PillStatusSep',
    }

  local mode_pill =
    string.format('%%#%s#%%#%s# %s %%#%s#', mode_info.sep, mode_info.hl, mode_info.name, mode_info.sep)
  local macro_pill = get_macro_status()

  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)
  local filename = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
  local label = get_icon(filename) .. filename
  if vim.bo[buf].modified then
    label = label .. ' '
  end
  label = escape_text(label)

  local file_pill = string.format('%%#PillStatusSep#%%#PillStatusActive# %s %%#PillStatusSep#', label)
  local diagnostics = get_diagnostics()

  local git = get_git_branch()
  local ft = vim.bo.filetype ~= '' and vim.bo.filetype or 'no ft'
  local line = vim.fn.line('.')
  local col = vim.fn.col('.')
  local percent = math.floor((line / vim.fn.line('$')) * 100)

  local right_text =
    string.format('%s %s %s | %d:%d [%d%%]', git ~= '' and (git .. ' |') or '', ft, '', line, col, percent)
  local right_pill =
    string.format('%%#PillStatusSep#%%#PillStatusActive# %s %%#PillStatusSep#', escape_text(right_text))

  return table.concat({
    '%#StatusLine# ',
    mode_pill,
    macro_pill,
    ' ',
    file_pill,
    '%=',
    diagnostics,
    '%=',
    right_pill,
    ' %#StatusLine#',
  })
end

--------------------------------------------------------------------------------
-- INIT & AUTOCMD
--------------------------------------------------------------------------------
local function setup_all_highlights()
  setup_tabline_highlights()
  setup_statusline_highlights()
end

setup_all_highlights()

vim.api.nvim_create_autocmd('ColorScheme', {
  callback = setup_all_highlights,
})

-- Opsi Tabline Native
vim.o.showtabline = 2
vim.o.tabline = '%!v:lua.PillTabline()'

-- Integrasi mini.statusline / Native Statusline
local ok_statusline, mini_statusline = pcall(require, 'mini.statusline')
if ok_statusline then
  mini_statusline.setup({
    content = {
      active = function()
        return _G.PillStatusline()
      end,
      inactive = function()
        return '%#StatusLineNC# %f %='
      end,
    },
  })
else
  vim.o.statusline = '%!v:lua.PillStatusline()'
end
