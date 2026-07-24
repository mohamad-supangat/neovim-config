if package.loaded['codecompanion'] then
  -- Gunakan vim.uv untuk Neovim 0.10+ dengan fallback ke vim.loop untuk versi lama
  local uv = vim.uv or vim.loop

  local Spinner = {
    processing = false,
    spinner_index = 1,
    -- Pindahkan pembuatan namespace ke inisialisasi tabel
    namespace_id = vim.api.nvim_create_namespace('CodeCompanionSpinner'),
    timer = nil,
    buf = nil, -- Cache buffer agar tidak perlu looping mencari buffer setiap 100ms
    extmark_id = nil, -- Menyimpan ID extmark untuk diupdate, bukan dihapus-buat ulang
    spinner_symbols = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
    filetype = 'codecompanion',
  }

  function Spinner:get_buf()
    -- 1. Gunakan cache jika buffer masih valid dan filetype-nya cocok
    if self.buf and vim.api.nvim_buf_is_valid(self.buf) and vim.bo[self.buf].filetype == self.filetype then
      return self.buf
    end

    -- Reset extmark jika buffer berubah
    self.extmark_id = nil

    -- 2. Cari buffer baru jika cache kosong/tidak valid
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].filetype == self.filetype then
        self.buf = buf
        return buf
      end
    end
    return nil
  end

  function Spinner:update_spinner()
    if not self.processing then
      return self:stop_spinner()
    end

    local buf = self:get_buf()
    if not buf then
      return
    end

    self.spinner_index = (self.spinner_index % #self.spinner_symbols) + 1
    local symbol = self.spinner_symbols[self.spinner_index]
    local last_line = vim.api.nvim_buf_line_count(buf) - 1

    -- Update extmark yang sudah ada (jauh lebih ringan dari clear_namespace)
    local opts = {
      id = self.extmark_id,
      virt_lines = { { { symbol .. ' Processing...', 'Comment' } } },
      virt_lines_above = true,
    }

    self.extmark_id = vim.api.nvim_buf_set_extmark(buf, self.namespace_id, last_line, 0, opts)
  end

  function Spinner:start_spinner()
    if self.processing then
      return
    end -- Cegah multiple timers

    self.processing = true
    self.spinner_index = 0
    self.extmark_id = nil

    if self.timer then
      self.timer:stop()
      if not self.timer:is_closing() then
        self.timer:close()
      end
    end

    self.timer = uv.new_timer()
    self.timer:start(
      0,
      100,
      vim.schedule_wrap(function()
        self:update_spinner()
      end)
    )
  end

  function Spinner:stop_spinner()
    self.processing = false

    if self.timer then
      self.timer:stop()
      if not self.timer:is_closing() then
        self.timer:close()
      end
      self.timer = nil
    end

    if self.buf and vim.api.nvim_buf_is_valid(self.buf) then
      vim.api.nvim_buf_clear_namespace(self.buf, self.namespace_id, 0, -1)
    end

    self.extmark_id = nil
  end

  function Spinner:init()
    -- Optimalisasi pembuatan augroup (cukup dipanggil sekali dengan clear = true)
    local group = vim.api.nvim_create_augroup('CodeCompanionHooks', { clear = true })

    vim.api.nvim_create_autocmd('User', {
      pattern = 'CodeCompanionRequest*',
      group = group,
      callback = function(request)
        if request.match == 'CodeCompanionRequestStarted' then
          self:start_spinner()
        elseif request.match == 'CodeCompanionRequestFinished' then
          self:stop_spinner()
        end
      end,
    })
  end

  require('codecompanion').setup({
    extensions = {
      history = {
        enabled = true,
      },
    },
    interactions = {
      chat = {
        adapter = {
          name = 'gemini',
          model = 'gemini-3-flash-preview',
        },
        slash_commands = {
          opts = {
            acp = { trigger = '<C-Space>' },
          },
        },
      },
      inline = {
        adapter = {
          name = 'gemini',
          model = 'gemini-3-flash-preview',
        },
        keymaps = {
          accept_change = {
            modes = { n = 'ga' },
            description = 'Accept the suggested change',
          },
          reject_change = {
            modes = { n = 'gr' },
            description = 'Reject the suggested change',
          },
        },
      },
    },
    opts = {
      language = 'Indonesia',
    },
    display = {
      chat = {
        start_in_insert_mode = false,
        show_references = true,
        separator = '─',
        window = {
          layout = 'float',
          height = 0.9,
          width = 0.9,
          opts = {
            breakindent = true,
            cursorcolumn = false,
            cursorline = false,
            foldcolumn = '0',
            linebreak = true,
            list = true,
            number = false,
            spell = false,
            wrap = true,
          },
        },
      },
    },
  })

  Spinner:init()

  -- keymaps
  vim.keymap.set({ 'n', 'x' }, '<A-b>', '<cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle CodeCompanion Chat' })
end
