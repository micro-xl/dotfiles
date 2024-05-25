vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')
vim.keymap.set('v', '$', '$h')
do -- Wrap the current word in (single/double)quotes
  vim.keymap.set('n', "<leader>'", "ciw'<C-r>\"'<esc>")
  vim.keymap.set('n', '<leader>"', 'ciw"<C-r>""<esc>')
end
do -- Wrap the selected word in (single/double)quotes
  vim.keymap.set('v', "<leader>'", "c'<C-r>\"'<esc>")
  vim.keymap.set('v', '<leader>"', 'c"<C-r>""<esc>')
end
do -- Wrap the selected word in bracket
  vim.keymap.set('n', '<leader>(', 'ciw(<C-r>")<esc>')
  vim.keymap.set('n', '<leader>{', 'ciw{<C-r>"}<esc>')
  vim.keymap.set('n', '<leader>[', 'ciw[<C-r>"]<esc>')
  vim.keymap.set('n', '<leader><', 'ciw<<C-r>"><esc>')
  vim.keymap.set('n', '<leader>`', 'ciw`<C-r>"`<esc>')
end
do -- Wrap the selected word in bracket
  vim.keymap.set('v', '<leader>(', 'c(<C-r>")<esc>vi(')
  vim.keymap.set('v', '<leader>{', 'c{<C-r>"}<esc>vi{')
  vim.keymap.set('v', '<leader>[', 'c[<C-r>"]<esc>vi[')
  vim.keymap.set('v', '<leader><', 'c<<C-r>"><esc>vi<')
  vim.keymap.set('v', '<leader>`', 'c`<C-r>"`<esc>vi`')
end
do -- Enable Continously indent move
  vim.keymap.set('v', '>', '>gv')
  vim.keymap.set('v', '<', '<gv')
end
do -- search for the next occurrence of the current word
  vim.keymap.set('n', '*', '*N', { silent = true })
  vim.keymap.set('v', '*', "y/\\V<C-R>=escape(@\",'/')<CR><CR>N", { silent = true })
end
vim.keymap.set('n', '<C-w>w', ':bd!<CR>', { silent = true })
do -- Tab Navigation
  vim.keymap.set('n', '<C-t>n', ':tabnext<CR>', { silent = true })
  vim.keymap.set('n', '<C-t>p', ':tabprev<CR>', { silent = true })
  vim.keymap.set('n', '<C-t>c', ':tabnew<CR>', { silent = true })
  vim.keymap.set('n', '<C-t>x', ':tabclose<CR>', { silent = true })
end
do -- Resize window
  vim.keymap.set('n', '<C-w>H', '25<C-w><', { silent = true })
  vim.keymap.set('n', '<C-w>L', '25<C-w>>', { silent = true })
  vim.keymap.set('n', '<C-w>K', '25<C-w>-', { silent = true })
  vim.keymap.set('n', '<C-w>J', '25<C-w>+', { silent = true })
end
-- Save Ctrl S
vim.keymap.set('i', '', '<ESC>:w<CR>', { silent = true })
vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('n', '{', ':bp<CR>', { silent = true })
vim.keymap.set('n', '}', ':bn<CR>', { silent = true })
vim.keymap.set('t', '{', ':bp<CR>', { silent = true })
vim.keymap.set('t', '}', ':bn<CR>', { silent = true })
-- Close all buffer but current one
vim.keymap.set('n', '<C-w>C', ':%bd|e#|bd#<CR>', { silent = true })
-- Paste without yanking in visual mode
vim.keymap.set('x', 'p', '"_dP', { silent = true })
