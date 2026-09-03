local function load_wal_colors()
  local wal_colors = dofile(vim.fn.expand('~/.cache/wal/colors-nvim.lua'))
  require('mini.hues').setup({
    background = wal_colors.background,
    foreground = wal_colors.foreground,
    plugins = {
      default = true,
    },
  })
end

load_wal_colors()
Config.new_autocmd('Signal', 'SIGUSR1', load_wal_colors, 'Auto reload wal colorscheme')

-- Define a function to clear backgrounds
local function make_transparent()
  local transparent_groups = {
    'Normal', -- Main text background
    'NormalNC', -- Non-current window background
    'NormalFloat', -- Floating windows (like hover menus)
    'FloatBorder', -- Borders for floating windows
    'LineNr', -- Line numbers
    'CursorLineNr', -- Current line number
    'SignColumn', -- Git signs and diagnostics column
    'FoldColumn', -- Code folding column
    'EndOfBuffer', -- The empty space at the end of a file (~)

    -- Optional: Add plugin-specific groups here if needed
    'TelescopeNormal',
    'TelescopeBorder',
    'NvimTreeNormal',
    'NvimTreeNormalNC',
  }

  for _, group in ipairs(transparent_groups) do
    -- Set the background of each group to 'none'
    vim.api.nvim_set_hl(0, group, { bg = 'none', ctermbg = 'none' })
  end
end

make_transparent()

Config.new_autocmd('ColorScheme', '*', make_transparent, 'Make Color schema transparant')
