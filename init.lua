local plugins = {
  { src = 'https://codeberg.org/cryptomilk/nvim-pack-ui' },
  { src = 'https://github.com/nvim-lua/plenary.nvim' },

  { src = 'https://github.com/nvim-mini/mini.nvim' },
  -- { src = 'https://github.com/honza/vim-snippets' },
  { src = 'https://github.com/rafamadriz/friendly-snippets' },
  { src = 'https://github.com/supermaven-inc/supermaven-nvim' },
  { src = 'https://github.com/MagicDuck/grug-far.nvim' },
  -- {
  --   src = 'https://github.com/neoclide/coc.nvim',
  --   version = "release"
  -- },
  { src = 'https://github.com/mrjones2014/smart-splits.nvim' },
  { src = 'https://github.com/backdround/improved-search.nvim' },
  { src = 'https://github.com/ingur/floatty.nvim' },

  -- treesitter
  -- { src = 'https://github.com/vim-polyglot/vim-polyglot' },
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
  { src = 'https://github.com/windwp/nvim-ts-autotag' },
  { src = 'https://github.com/noisesfromspace/touchup.nvim' },

  -- lsp native
  { src = 'https://github.com/neovim/nvim-lspconfig' },
  { src = 'https://github.com/mason-org/mason.nvim' },
  { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
  { src = 'https://github.com/stevearc/conform.nvim' },
  -- { src = 'https://github.com/nvimtools/none-ls.nvim' },

  -- { src = 'https://github.com/olimorris/codecompanion.nvim' },
  -- { src = 'https://github.com/ravitemer/codecompanion-history.nvim' },
  { src = 'https://github.com/azorng/goose.nvim' },
}

vim.pack.add(plugins)

_G.Config = {}

local gr = vim.api.nvim_create_augroup('custom-config', {})
Config.new_autocmd = function(event, pattern, callback, desc)
  local opts = { group = gr, pattern = pattern, callback = callback, desc = desc }
  vim.api.nvim_create_autocmd(event, opts)
end
