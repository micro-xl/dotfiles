local asserter = require('asserter')
local h_string = require('h-string')
local floating = require('floating-window')
local fz = require('fzf-wrapper')
local exec = require('h-shell').exec

local mod = {}

local function cd_to_bookmark(file_path)
  asserter.non_empty_string(file_path, 'file_path')
  local sources = h_string.split(h_string.trim(exec('cat ' .. file_path)), '\n')
  floating.open(0.9, 0.8, { filetype = 'bookmarks' });
  fz.with_fzf_on_cur_win(function(fzf)
    local picked = fzf(sources)
    vim.notify('[CWD] ' .. picked[1])
    vim.cmd('cd ' .. picked[1])
  end)
end

-- @params {table} opts
-- @params {string} opts.bookmarks_file_path
-- @params {string} opts.open_command
-- @params {string} opts.keymap_open
-- @params {string} opts.edit_command
mod.setup = function(opts)
  asserter.not_nil(opts.bookmarks_file_path, 'opts.bookmarks_file_path')
  asserter.non_empty_string(opts.bookmarks_file_path, 'opts.bookmarks_file_path')
  asserter.non_empty_string(opts.open_command, 'opts.open_command')
  asserter.non_empty_string(opts.keymap_open, 'opts.keymap_open')
  asserter.non_empty_string(opts.edit_command, 'opts.edit_command')

  vim.api.nvim_create_user_command(opts.open_command, function() cd_to_bookmark(opts.bookmarks_file_path) end, {})
  vim.api.nvim_create_user_command(opts.edit_command, function() vim.cmd('e ' .. opts.bookmarks_file_path) end, {})

  vim.api.nvim_set_keymap('n', opts.keymap_open, ':' .. opts.open_command .. '<CR>', { noremap = true, silent = true })
end

return mod;
