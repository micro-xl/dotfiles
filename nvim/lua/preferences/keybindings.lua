local change_cwd_to_root_dir_of_cur_file = require('utils.path').change_cwd_to_root_dir_of_cur_file

vim.keymap.set('n', '<esc>', ':noh<esc>', { silent = true })
vim.g.mapleader = ','

vim.keymap.set('v', '$', '$h')

-- Wrap the current word in (single/double)quotes
vim.keymap.set('n', "<leader>'", "ciw'<C-r>\"'<esc>")
vim.keymap.set('n', '<leader>"', 'ciw"<C-r>""<esc>')

-- Wrap the selected word in (single/double)quotes
vim.keymap.set('v', "<leader>'", "c'<C-r>\"'<esc>")
vim.keymap.set('v', '<leader>"', 'c"<C-r>""<esc>')

-- Wrap the selected word in bracket
vim.keymap.set('n', '<leader>(', 'ciw(<C-r>")<esc>')
vim.keymap.set('n', '<leader>{', 'ciw{<C-r>"}<esc>')
vim.keymap.set('n', '<leader>[', 'ciw[<C-r>"]<esc>')
vim.keymap.set('n', '<leader><', 'ciw<<C-r>"><esc>')
vim.keymap.set('n', '<leader>`', 'ciw`<C-r>"`<esc>')

-- Wrap the selected word in bracket
vim.keymap.set('v', '<leader>(', 'c(<C-r>")<esc>vi(')
vim.keymap.set('v', '<leader>{', 'c{<C-r>"}<esc>vi{')
vim.keymap.set('v', '<leader>[', 'c[<C-r>"]<esc>vi[')
vim.keymap.set('v', '<leader><', 'c<<C-r>"><esc>vi<')
vim.keymap.set('v', '<leader>`', 'c`<C-r>"`<esc>vi`')


vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<', '<gv')

-- search for the next occurrence of the current word
vim.keymap.set('n', '*', '*N', { silent = true })
vim.keymap.set('v', '*', 'y/\\V<C-R>=escape(@",\'/\')<CR><CR>N', { silent = true })


vim.keymap.set('n', '<C-w>w', ':bd!<CR>', { silent = true })

-- Tab Navigation
vim.keymap.set('n', '<C-t>n', ':tabnext<CR>', { silent = true })
vim.keymap.set('n', '<C-t>p', ':tabprev<CR>', { silent = true })
vim.keymap.set('n', '<C-t>c', ':tabnew<CR>', { silent = true })
vim.keymap.set('n', '<C-t>x', ':tabclose<CR>', { silent = true })

-- Resize window
vim.keymap.set('n', '<C-w>H', '25<C-w><', { silent = true })
vim.keymap.set('n', '<C-w>L', '25<C-w>>', { silent = true })
vim.keymap.set('n', '<C-w>K', '25<C-w>-', { silent = true })
vim.keymap.set('n', '<C-w>J', '25<C-w>+', { silent = true })

-- Zoom
local function toggle_zoom()
  if vim.t.zoomed == 1 then
    vim.cmd(vim.t.zoom_winrestcmd)
    vim.t.zoomed = 0
  else
    vim.t.zoom_winrestcmd = vim.fn.winrestcmd()
    vim.cmd('resize')
    vim.cmd('vertical resize')
    vim.t.zoomed = 1
  end
end

vim.keymap.set('n', '<C-w>z', toggle_zoom, { silent = true })
vim.keymap.set('t', '<C-a>z', toggle_zoom, { silent = true })



-- buffer Navigation
local function until_not_terminal(command)
  local function recursiveFunc()
    vim.cmd(command)
    if (vim.bo.buftype == 'terminal') then
      recursiveFunc()
    end
  end

  return function()
    recursiveFunc()
    vim.cmd('stopinsert')
  end
end

vim.keymap.set('n', '{', function() vim.cmd('bp') end, { silent = true });
vim.keymap.set('n', '}', function() vim.cmd('bn') end, { silent = true });
vim.keymap.set('t', '{', function() vim.cmd('bp') end, { silent = true });
vim.keymap.set('t', '}', function() vim.cmd('bn') end, { silent = true });

-- Save Ctrl S
vim.keymap.set('i', '', '<ESC>:w<CR>', { silent = true })
vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true })
vim.keymap.set('n', '<C-S-s>', '<ESC>:w<CR>', { silent = true })

-- Find
vim.keymap.set('n', '<C-f>', '/\\c')

-- Close all buffer but current one
vim.keymap.set('n', '<C-w>C', ':%bd|e#|bd#<CR>', { silent = true })

-- Change CWD to root path of current file
vim.keymap.set('n', '©', change_cwd_to_root_dir_of_cur_file, { silent = true })

-- Paste without yanking in visual mode
vim.keymap.set('x', 'p', '"_dP', { silent = true })

-- Luafile
vim.keymap.set('n', '<leader>rl', ':luafile %<CR>', { silent = false })

-- translate
vim.keymap.set('n', '<leader>tl', function()
  local current_word = vim.fn.expand('<cword>'):gsub('_', ' ')
  local translated = require('custom.translate-shell').translate_shell(current_word, 'en', 'ko')
  require('utils.floating-window').print_to_floating_window(translated)
end, { silent = false, noremap = true })

vim.keymap.set('x', '<leader>tl', function()
  local selected = require('utils.nvim_extended').get_last_visual_selection():gsub('_', ' ')
  local translated = require('custom.translate-shell').translate_shell(selected, 'en', 'ko', { brief = true })
  require('utils.floating-window').print_to_floating_window(translated)
end, { silent = false, noremap = true })
