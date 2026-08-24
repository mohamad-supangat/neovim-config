local function escape_tabline_text(text)
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

local function get_buf_label(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  local filename = name == '' and '[No Name]' or vim.fn.fnamemodify(name, ':t')
  local label = get_icon(filename) .. filename
  if vim.bo[buf].modified then
    label = label .. ' '
  end
  return escape_tabline_text(label)
end

-- Membuat Custom Highlight Group untuk Tabline Pill
local function setup_pill_highlights()
  local hl_fill = vim.api.nvim_get_hl(0, { name = 'TabLineFill', link = false })
  local hl_tab = vim.api.nvim_get_hl(0, { name = 'TabLine', link = false })
  local hl_norm = vim.api.nvim_get_hl(0, { name = 'Normal', link = false })

  local bg_fill = hl_fill.bg or 'NONE'
  local bg_tab = hl_tab.bg or 'NONE'
  local fg_active = '#000000' -- Teks aktif mengikuti Normal fg
  local bg_active = '#dddddd' -- Custom Background untuk Tab Aktif

  -- 1. Custom Group untuk Badan Pill Aktif
  vim.api.nvim_set_hl(0, 'PillTablineActive', {
    fg = fg_active,
    bg = bg_active,
    bold = true,
  })

  -- 2. Separator Pill Aktif (fg menyatu dengan pill, bg menyatu dengan tabline fill)
  vim.api.nvim_set_hl(0, 'PillTablineSepSel', {
    fg = bg_active,
    bg = bg_fill,
  })

  -- 3. Separator Pill Tidak Aktif
  vim.api.nvim_set_hl(0, 'PillTablineSep', {
    fg = bg_tab,
    bg = bg_fill,
  })
end

-- Inisialisasi highlight dan buat autocmd agar warna tetap konsisten saat berganti colorscheme
setup_pill_highlights()
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = setup_pill_highlights,
})

_G.PillTablineGoToBuffer = function(buf)
  buf = tonumber(buf)
  if buf and vim.api.nvim_buf_is_valid(buf) then
    pcall(vim.api.nvim_set_current_buf, buf)
  end
end

local function truncate(path, chars, full_dirs)
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

_G.PillTabline = function()
  local parts = { '%#TabLineFill#%= ' }

  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
      local is_current = (buf == vim.api.nvim_get_current_buf())

      -- Penggunaan Custom Highlight Group yang telah didefinisikan
      local body_hl = is_current and 'PillTablineActive' or 'TabLine'
      local sep_hl = is_current and 'PillTablineSepSel' or 'PillTablineSep'
      local label = get_buf_label(buf)

      local path_str = ''
      if is_current then
        local path = vim.fs.normalize(vim.fn.expand('%:.:h'))
        path = truncate(path, 1, 1)
        path = ' ' .. path
        path_str = string.format('%%#Directory#%s%%#TabLineFill# ', path)
      end

      -- Format tampilan pill
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

vim.o.showtabline = 2
vim.o.tabline = '%!v:lua.PillTabline()'
