local function load_wal_colors()
  local wal_colors = dofile(vim.fn.expand('~/.cache/wal/colors-nvim.lua'))
  require('mini.hues').setup({
    background = wal_colors.background,
    foreground = wal_colors.foreground,
    -- n_hues = 8,
    -- saturation = 'low',
    plugins = {
      default = true,
    },
  })
end

load_wal_colors()
Config.new_autocmd('Signal', 'SIGUSR1', load_wal_colors, 'Auto reload wal colorscheme')
