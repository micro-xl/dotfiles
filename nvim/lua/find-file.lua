local asserter = require('asserter')
local floating = require('floating-window')
local h_string = require('h-string')
local h_list = require('h-list')
local fz = require('fzf-wrapper');
local exec = require('h-shell').exec
local get_icon = require('nvim-web-devicons').get_icon

local mod = {}


-- @params {table} opts
-- @params {string} opts.excludes
mod.find_file = function(opts)
  asserter.not_nil(opts, 'opts');
  asserter.table(opts, 'opts');

  local excludes = opts.excludes ~= nil and h_list.join(h_list.map(opts.excludes, function(exclude_item)
    return '--exclude ' .. exclude_item
  end), ' ') or '';
  floating.open(0.8, 0.8, {
    filetype = 'find-file'
  })
  local pwd_stdout = h_string.trim(exec('pwd'))
  local fd_stdout = h_string.trim(exec('fd --type f --hidden --no-ignore ' .. excludes .. ' .'))
  local sources = h_list.map(h_string.split(fd_stdout, '\n'), function(item)
    return get_icon(item) .. ' ' .. item
  end)
  fz.with_fzf(function(fzf)
    local picked = fzf(sources)

    local extract_path = function(item)
      return h_string.replace(item, get_icon(item) .. ' ', '')
    end
    vim.cmd('e ' .. pwd_stdout .. '/' .. extract_path(picked[1]))
  end)
end


-- @params {table} opts
-- @params {table} opts.excludes
-- @params {string} opts.command
-- @params {string} opts.keymap
mod.setup = function(opts)
  asserter.not_nil(opts.command, 'opts.command')
  asserter.non_empty_string(opts.command, 'opts.command')
  asserter.non_empty_string(opts.keymap, 'opts.keymap')

  vim.api.nvim_create_user_command(opts.command, function()
    mod.find_file({
      excludes = opts.excludes
    })
  end, {})

  vim.api.nvim_set_keymap('n', opts.keymap, ':' .. opts.command .. '<CR>', { noremap = true, silent = true })
end

return mod;
