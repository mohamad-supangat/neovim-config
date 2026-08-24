require('koda').setup({
  transparent = true, -- enable for transparent backgrounds

  -- Set the variants to use when auto-switching based on vim.o.background
  -- Valid values: 'dark', 'light', 'moss', 'glade'
  theme = {
    dark = 'moss',
    light = 'light',
  },

  -- Automatically enable highlights only for plugins installed by your plugin manager
  -- Currently only supports `lazy.nvim`, `mini.deps` and `vim.pack`
  auto = true, -- disable to load ALL available plugin highlights

  cache = true, -- caches the theme for better performance

  -- Style to be applied to different syntax groups
  -- Common use case would be to set either `italic = true` or `bold = true` for a desired group
  -- See `:help nvim_set_hl` for more valid values
  styles = {
    functions = { bold = true },
    keywords = {},
    comments = {},
    strings = {},
    constants = {}, -- includes numbers, booleans
  },

  -- Override colors for the active variant
  -- Available keys (e.g., 'func') can be found in lua/koda/palette/
  colors = {
    -- Apply to all variants:
    -- func = "#4078F2",

    -- Or override per variant:
    -- dark = { func = "#4078F2" },
    -- moss = { keyword = "#A627A4" },
  },

  -- You can modify or extend highlight groups using the `on_highlights` configuration option
  -- Any changes made take effect when highlights are applied
  on_highlights = function(hl, c)
    -- hl.LineNr = { fg = c.info } -- change a specific highlight to use a different palette color
    -- hl.Comment = { fg = c.emphasis, italic = true } -- modify a syntax group (add bold, italic, etc)
    -- hl.RainbowDelimiterRed = { fg = "#fb2b2b" } -- add a custom highlight group for another plugin
  end,
})
