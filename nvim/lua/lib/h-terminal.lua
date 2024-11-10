local asserter = require 'lib.asserter'
local mod = {}

-- @param {string} command_str - command string to run in terminal
mod.open_terminal_horizontal = function(command_str_nil)
  asserter.assert(command_str_nil == nil or type(command_str_nil) == 'string', 'command_str_nil is not a string or nil')
  vim.cmd 'belowright split term://zsh'
  vim.opt.number = false
  vim.opt.bufhidden = 'hide'
  vim.cmd 'startinsert'
  if command_str_nil ~= nil then
    vim.fn.feedkeys(command_str_nil, vim.api.nvim_replace_termcodes('<CR>', true, false, true))
  end
end

-- @param {string} command_str - command string to run in terminal
mod.open_terminal_vertical = function(command_str_nil)
  asserter.assert(command_str_nil == nil or type(command_str_nil) == 'string', 'command_str_nil is not a string or nil')
  vim.cmd 'belowright vsplit term://zsh'
  vim.opt.number = false
  vim.opt.bufhidden = 'hide'
  vim.cmd 'startinsert'
  if command_str_nil ~= nil then
    vim.fn.feedkeys(command_str_nil, vim.api.nvim_replace_termcodes('<CR>', true, false, true))
  end
end

mod.buf_is_terminal = function(bufnr)
  asserter.number(bufnr, 'bufnr')
  return vim.bo[bufnr].buftype == 'terminal'
end

return mod
