local asserter = require('asserter')
local mod = {};

function open_h_tree(opts)
  asserter.not_nil(opts.enter_on_open, 'opts.enter_on_open')
  -- local buf = vim.api.nvim_create_buf(false, true)
  -- set_buf_option(buf)
  local h_tree_win = vim.api.nvim_open_win(0, opts.enter_on_open, {
    split = 'left',
    win = 0
  })
  vim.api.nvim_win_set_width(h_tree_win, 30)
end

-- bufnr {number} The buffer number to set the options for
function set_buf_option(bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'buftype', 'nofile')
  vim.api.nvim_buf_set_option(bufnr, 'bufhidden', 'hide')
  vim.api.nvim_buf_set_option(bufnr, 'buflisted', false)
  vim.api.nvim_buf_set_option(bufnr, 'filetype', 'h-tree')
  vim.api.nvim_buf_set_option(bufnr, 'swapfile', false)
  vim.api.nvim_buf_set_option(bufnr, 'buflisted', false)
  vim.api.nvim_buf_set_option(bufnr, 'modifiable', false)
  vim.api.nvim_buf_set_option(bufnr, 'readonly', true)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', -1)
  vim.api.nvim_buf_set_option(bufnr, 'undofile', false)
  vim.api.nvim_buf_set_option(bufnr, 'undolevels', 0)
end

open_h_tree({
  enter_on_open = true,
})

mod.setup = function()
end

return mod
