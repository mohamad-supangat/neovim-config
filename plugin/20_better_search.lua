local search = require('improved-search')
local keymap = vim.keymap.set

-- Search next / previous.
keymap({ 'n', 'x', 'o' }, 'n', search.stable_next)
keymap({ 'n', 'x', 'o' }, 'N', search.stable_previous)

-- Search current word without moving.
keymap('n', '!', search.current_word)
keymap('n', '/', search.current_word)

-- Search selected text in visual mode
keymap('x', '!', search.in_place) -- search selection without moving
keymap('x', '/', search.in_place) -- search selection without moving
keymap('x', '*', search.forward) -- search selection forward
keymap('x', '#', search.backward) -- search selection backward

-- Search by motion in place
keymap('n', '|', search.in_place)
-- You can also use search.forward / search.backward for motion selection.
