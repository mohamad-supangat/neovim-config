-- 1. Pastikan plugin sudah ter-load (asumsi plugin sudah tersedia di runtimepath / rtp)
-- Jika Anda menggunakan manajer lain seperti mini.deps atau manual cloning, pastikan 'kulala' ada.

-- 2. Konfigurasi Plugin menggunakan setup() bawaan kulala.nvim
require('kulala').setup({
  kulala_core = {
    path = nil,
    timeout = 60000,
    data_dir = nil,
    download_url = 'https://github.com/mistweaverco/kulala-core/releases/download/%s/%s',
    download_tool = 'curl',
  },
  session = {
    restore = true,
  },
  treesitter = {
    enable = true,
    cli_path = 'tree-sitter',
  },
  default_env = 'default',
  environment_scope = 'b',
  vscode_rest_client_environmentvars = false,

  response_format = {
    indent = 2,
    expand_tabs = true,
    sort_keys = false,
  },
  ui = {
    display_mode = 'split',
    split_direction = 'right',
    win_opts = { bo = {}, wo = {} },
    default_view = 'body',
    winbar = true,
    default_winbar_panes = { 'body', 'headers', 'verbose', 'script_output', 'report' },
    winbar_labels = {
      body = 'Body',
      headers = 'Headers',
      headers_body = 'All',
      verbose = 'Verbose',
      script_output = 'Script Output',
      stats = 'Stats',
      report = 'Report',
      help = 'Help',
    },
    winbar_labels_keymaps = true,
    show_variable_info_text = false,
    show_icons = 'on_request',
    icons = {
      inlay = {
        loading = '⏳',
        done = '✔',
        error = '✘',
      },
      lualine = '🐼',
      textHighlight = 'WarningMsg',
      loadingHighlight = 'Normal',
      doneHighlight = 'String',
      errorHighlight = 'ErrorMsg',
    },
    show_request_summary = true,
    max_response_size = 32768,
    max_request_size = 2048,
    report = {
      show_script_output = true,
      show_asserts_output = true,
      show_summary = true,
      headersHighlight = 'Special',
      successHighlight = 'String',
      errorHighlight = 'Error',
    },
    scratchpad_default_contents = {
      '@MY_TOKEN_NAME=my_token_value',
      '',
      '# @name scratchpad',
      'POST https://echo.kulala.app/post HTTP/1.1',
      'accept: application/json',
      'content-type: application/json',
      '',
      '{',
      '  "foo": "bar"',
      '}',
    },
    pickers = {
      snacks = {
        layout = function()
          local has_snacks, snacks_picker = pcall(require, 'snacks.picker')
          return not has_snacks and {}
            or vim.tbl_deep_extend('force', snacks_picker.config.layout('telescope'), {
              reverse = true,
              layout = {
                { { win = 'list' }, { height = 1, win = 'input' }, box = 'vertical' },
                { win = 'preview', width = 0.6 },
                box = 'horizontal',
                width = 0.8,
              },
            })
        end,
      },
    },
  },

  lsp = {
    enable = true,
    filetypes = {
      'http',
      'rest',
      'javascript',
      'typescript',
      'lua',
    },
    enforce_external_script_naming_convention = true,
    keymaps = false,
    on_attach = nil,
  },

  debug = 3,
  generate_bug_report = false,
  global_keymaps = false,
  global_keymaps_prefix = '<leader>R',
  kulala_keymaps = true,
  kulala_keymaps_prefix = '',
  script_console_notify = true,
  openapi_panel_keymaps = true,
  openapi_panel = {
    split = 'right',
    signs = { folded = '>', expanded = 'v' },
    highlights = {
      section = 'Title',
      operation = 'Function',
      parameter = 'Identifier',
      response = 'Number',
      schema = 'Type',
      try_it_out = 'String',
      description = 'Comment',
      badge = 'Comment',
      sign = 'Special',
      value = 'Constant',
    },
  },
})

-- 3. Native Keymaps (Pengganti properti `keys` di lazy.nvim)
vim.keymap.set('n', '<leader>Rs', function()
  require('kulala').run()
end, { desc = 'Send request' })

vim.keymap.set('n', '<leader>Ra', function()
  require('kulala').run_all()
end, { desc = 'Send all requests' })

vim.keymap.set('n', '<leader>Rb', function()
  require('kulala').scratchpad()
end, { desc = 'Open scratchpad' })
