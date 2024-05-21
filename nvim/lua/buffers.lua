local asserter = require('asserter')
local fz = require('fzf-wrapper');
local floating = require('floating-window')
local pipe = require('h-function').pipe
local h_list = require('h-list')

local mod = {}

local get_loaded_buffer = pipe(
  function() return vim.api.nvim_list_bufs() end,
  function(bufs)
    return h_list.filter(
      bufs,
      function(bufnr)
        return vim.api.nvim_buf_is_loaded(bufnr)
      end)
  end,
  function(bufs)
    return h_list.map(bufs, function(bufnr)
      return vim.api.nvim_buf_get_name(bufnr)
    end)
  end,
  function(bufnames)
    return h_list.filter(bufnames, function(bufname)
      return bufname ~= ''
    end)
  end
)

mod.fzf_open_buffers = function()
  floating.open(0.9, 0.8, {
    filetype = 'buffers'
  })
  local sources = get_loaded_buffer()
  fz.with_fzf_on_cur_win(function(fzf)
    local picked = fzf(sources)
    vim.cmd('e ' .. picked[1])
  end)
end

-- @params {table} opts
-- @params {string} command
-- @params {string} keymap
mod.setup = function(opts)
  asserter.not_nil(opts, 'opts')
  asserter.non_empty_string(opts.command, 'opts.command')
  asserter.non_empty_string(opts.keymap, 'opts.keymap')

  vim.api.nvim_create_user_command(opts.command, function()
    mod.fzf_open_buffers()
  end, {})

  vim.api.nvim_set_keymap('n', opts.keymap, ':' .. opts.command .. '<CR>', { noremap = true, silent = true })
end


return mod
