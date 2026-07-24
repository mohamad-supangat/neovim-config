require('goose').setup({
  prefered_picker = 'mini.pick',
  default_global_keymaps = true,
  keymap = {
    global = {
      -- toggle = '<leader>gg', -- Open goose. Close if opened
      toggle = '<A-b>',
      open_input = false, -- Opens and focuses on input window on insert mode
      open_input_new_session = false, -- Opens and focuses on input window on insert mode. Creates a new session
      open_output = false, -- Opens and focuses on output window
      toggle_focus = false, -- Toggle focus between goose and last window
      close = '<leader>gq', -- Close UI windows
      toggle_fullscreen = '<leader>gf', -- Toggle between normal and fullscreen mode
      select_session = '<leader>gs', -- Select and load a goose session
      goose_mode_chat = '<leader>gmc', -- Set goose mode to `chat`. (Tool calling disabled. No editor context besides selections)
      goose_mode_auto = '<leader>gma', -- Set goose mode to `auto`. (Default mode with full agent capabilities)
      goose_mode_approve = '<leader>gmp', -- Set goose mode to `approve`. (Manual approval for all tool usage)
      goose_mode_smart_approve = '<leader>gms', -- Set goose mode to `smart_approve`. (Risk-based tool usage approval)
      configure_provider = '<leader>gp', -- Quick provider and model switch from predefined list
      open_config = '<leader>g.', -- Open goose config file
      inspect_session = '<leader>g?', -- Inspect current session as JSON
      diff_open = '<leader>gd', -- Opens a diff tab of a modified file since the last goose prompt
      diff_next = '<leader>g]', -- Navigate to next file diff
      diff_prev = '<leader>g[', -- Navigate to previous file diff
      diff_close = '<leader>gc', -- Close diff view tab and return to normal editing
      diff_revert_all = '<leader>gra', -- Revert all file changes since the last goose prompt
      diff_revert_this = '<leader>grt', -- Revert current file changes since the last goose prompt
    },
    window = {
      submit = '<cr>', -- Submit prompt (normal mode)
      submit_insert = '<cr>', -- Submit prompt (insert mode)
      close = '<esc>', -- Close UI windows
      stop = '<C-c>', -- Stop goose while it is running
      next_message = ']]', -- Navigate to next message in the conversation
      prev_message = '[[', -- Navigate to previous message in the conversation
      mention_file = '@', -- Pick a file and add to context. See File Mentions section
      toggle_pane = '<tab>', -- Toggle between input and output panes
      prev_prompt_history = '<up>', -- Navigate to previous prompt in history
      next_prompt_history = '<down>', -- Navigate to next prompt in history
    },
  },
  ui = {
    window_type = 'float', -- float|split
    window_width = 0.35, -- Width as percentage of editor width
    input_height = 0.15, -- Input height as percentage of window height
    fullscreen = false, -- Start in fullscreen mode (default: false)
    layout = 'right', -- right|left|center (float window only)
    floating_height = 0.8, -- Height as percentage of editor height for "center" layout
    display_model = true, -- Display model name on top winbar
    display_goose_mode = true, -- Display mode on top winbar: auto|chat|approve|smart_approve
  },
  providers = {},
  system_instructions = '',
})

-- vim.keymap.set({ 'n', 'x' }, '<A-b>', '<cmd>CodeCompanionChat Toggle<CR>', { desc = 'Toggle CodeCompanion Chat' })
