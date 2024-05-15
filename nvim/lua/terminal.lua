local asserter = require('asserter')
local mod = {}

-- @param {string} command_str - command string to run in terminal
mod.open_terminal_horizontal = function(command_str)
  vim.cmd('belowright split term://zsh');
  vim.opt.number = false;
  vim.opt.bufhidden = 'hide';
  vim.cmd('startinsert')
  if command_str ~= nil then
    vim.fn.feedkeys(command_str, vim.api.nvim_replace_termcodes('<CR>', true, false, true))
  end
end

-- @param {string} command_str - command string to run in terminal
mod.open_terminal_vertical = function(command_str)
  vim.cmd('belowright vsplit term://zsh');
  vim.opt.number = false;
  vim.opt.bufhidden = 'hide';
  vim.cmd('startinsert')
  if command_str ~= nil then
    vim.fn.feedkeys(command_str, vim.api.nvim_replace_termcodes('<CR>', true, false, true))
  end
end

local function buf_is_terminal(bufnr)
  return vim.bo[bufnr].buftype == 'terminal'
end

mod.setup = function(opts)
  asserter.not_nil(opts.open_terminal_h_cmd, 'opts.open_terminal_h_cmd')
  asserter.not_nil(opts.open_terminal_v_cmd, 'opts.open_terminal_v_cmd')
  asserter.not_nil(opts.open_terminal_h_keymap, 'opts.open_terminal_h_keymap')
  asserter.not_nil(opts.open_terminal_v_keymap, 'opts.open_terminal_v_keymap')
  asserter.not_nil(opts.close_terminal_keymap, 'opts.close_terminal_keymap')

  vim.keymap.set('t', '<ESC>', '<C-\\><C-n>', { noremap = true })
  vim.api.nvim_create_user_command(opts.open_terminal_h_cmd, function(command)
      mod.open_terminal_horizontal(command.args);
    end,
    { nargs = '?' })

  vim.api.nvim_create_user_command(opts.open_terminal_v_cmd, function(command)
      mod.open_terminal_vertical(command.args);
    end,
    { nargs = '?' })

  vim.keymap.set('n', opts.open_terminal_h_keymap, ':' .. opts.open_terminal_h_cmd .. '<CR>',
    { noremap = true, silent = true })
  vim.keymap.set('n', opts.open_terminal_v_cmd, ':' .. opts.open_terminal_v_cmd .. '<CR>',
    { noremap = true, silent = true })
  vim.keymap.set('n', opts.close_terminal_keymap, function()
    if buf_is_terminal(0) == true then
      vim.cmd('q!')
    end
  end, { noremap = true, silent = true })

  vim.keymap.set('t', opts.open_terminal_h_keymap, '<C-\\><C-n>:' .. opts.open_terminal_h_cmd .. '<CR>',
    { noremap = true, silent = true })
  vim.keymap.set('t', opts.open_terminal_v_keymap, '<C-\\><C-n>:' .. opts.open_terminal_v_cmd .. '<CR>',
    { noremap = true, silent = true })
  vim.keymap.set('t', opts.close_terminal_keymap, '<C-\\><C-n>:q!<CR>', { noremap = true, silent = true })
end
mod.setup = function()
end

return mod;
