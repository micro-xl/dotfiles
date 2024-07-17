local h_terminal = require 'lib.h-terminal'
local h_path = require 'lib.h-path'

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
vim.keymap.set('n', 'œ', ':bp<CR>', { silent = true })
vim.keymap.set('n', '∑', ':bn<CR>', { silent = true })
vim.keymap.set('t', 'œ', '<C-\\><C-n>bp<CR>', { silent = true })
vim.keymap.set('t', '∑', '<C-\\><C-n>:bn<CR>', { silent = true })

-- Close all buffer but current one
vim.keymap.set('n', '<C-w>C', ':%bd|e#|bd#<CR>', { silent = true })
-- Paste without yanking in visual mode
vim.keymap.set('x', 'p', '"_dP', { silent = true })

-- Change CWD to root path of current file
vim.keymap.set('n', '©', h_path.change_cwd_to_root_dir_of_cur_file, { silent = true })

-- Diagnostics
vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, {})
vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, {})

-- <C-f> for find
vim.keymap.set('n', '<C-f>', function()
  vim.api.nvim_feedkeys('/', 'n', false)
end, { silent = true })

-- Terminal
vim.keymap.set('n', '<C-a>s', function()
  h_terminal.open_terminal_horizontal()
end, {})
vim.keymap.set('n', '<C-a>v', function()
  h_terminal.open_terminal_vertical()
end, {})
vim.keymap.set('n', '<C-a>x', function()
  if h_terminal.buf_is_terminal(0) == true then
    vim.cmd 'q!'
  end
end, { noremap = true, silent = true })
vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { noremap = true })
vim.keymap.set('t', '<C-a>s', function()
  h_terminal.open_terminal_horizontal()
end, {})
vim.keymap.set('t', '<C-a>v', function()
  h_terminal.open_terminal_vertical()
end, {})
vim.keymap.set('t', '<C-a>x', function()
  vim.cmd 'q!'
end, {})
