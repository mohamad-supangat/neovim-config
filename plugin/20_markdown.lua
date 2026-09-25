local obsidianPath = vim.fn.expand('~/Documents/Obsidian/')
vim.keymap.set(
  'n',
  '<leader>no',
  '<cmd>edit ' .. obsidianPath .. '<CR>:lcd %:p:h<CR>',
  { noremap = true, silent = true, desc = 'Obsidian notes picker' }
)

vim.keymap.set('n', '<Leader>nk', function()
  MiniPick.builtin.files({}, {
    source = {
      name = 'Notes',
      cwd = obsidianPath,
    },
  })
end, { noremap = true, silent = true, desc = 'Obsidian notes picker' })

require('super-kanban').setup({

  })
vim.keymap.set('n', '<Leader>kb', function()
  local pattern = obsidianPath .. '**/kanban-*.md'
  local files = vim.fn.glob(pattern, false, true)

  if #files == 0 then
    vim.notify('No kanban-*.md files found in:\n' .. base, vim.log.levels.WARN)
    return
  end

  MiniPick.start({
    source = {
      name = 'Kanban Boards',
      items = files,
      choose = function(item)
        if item then
          -- Jalankan setelah MiniPick close
          vim.schedule(function()
            vim.cmd('SuperKanban open ' .. vim.fn.fnameescape(item))
          end)
        end
      end,
    },
  })
end, { noremap = true, silent = true, desc = 'Open Kanban board picker' })
