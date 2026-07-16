local plugins = {
  { src = 'https://codeberg.org/cryptomilk/nvim-pack-ui' },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
  {
    src = 'https://github.com/nvim-mini/mini.nvim',
  },
  {
    src = "https://github.com/honza/vim-snippets"
  },
  {
    src = "https://github.com/supermaven-inc/supermaven-nvim"
  },
  { src = "https://github.com/MagicDuck/grug-far.nvim" },
  {
    src = 'https://github.com/neoclide/coc.nvim',
    version = "release"
  },
  {
    src = "https://github.com/MeanderingProgrammer/render-markdown.nvim"
  },
  { src = 'https://github.com/mrjones2014/smart-splits.nvim' },
  {
    src = 'https://github.com/ingur/floatty.nvim'
  }
}

vim.pack.add(plugins)
