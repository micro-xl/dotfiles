require('nvim_comment').setup({})

-- Keymap for comment
local bufopts = { noremap = true, silent = true }
vim.keymap.set('n', '', ':CommentToggle<CR>', bufopts)
vim.keymap.set('i', '', ':CommentToggle<CR>', bufopts)
vim.keymap.set('v', '', ":'<,'>CommentToggle<CR>gv", bufopts)
vim.keymap.set('n', '<C-/>', ':CommentToggle<CR>', bufopts)
vim.keymap.set('i', '<C-/>', ':CommentToggle<CR>', bufopts)
vim.keymap.set('v', '<C-/>', ":'<,'>CommentToggle<CR>gv", bufopts)
