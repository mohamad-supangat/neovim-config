if package.loaded['avante'] then
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name, kind = ev.data.spec.name, ev.data.kind
      if name == 'avante.nvim' and (kind == 'install' or kind == 'update') then
        vim.system({ 'make' }, { cwd = ev.data.path }):wait()
      end
    end,
  })

  require('avante').setup({
    shortcuts = {
      {
        name = 'refactor',
        description = 'Refactor code with best practices',
        prompt = 'Please refactor this code following best practices.',
      },
    },
    provider = 'gemini',
    selector = {
      provider = 'mini_pick',
      provider_opts = {},
    },
    windows = {
      position = 'smart',
      ask = {
        floating = false,
      },
    },
  })

  vim.keymap.set({ 'n', 'x' }, '<A-b>', '<cmd>AvanteToggle<CR>', { desc = 'Toggle CodeCompanion Chat' })
end
