local asserter = require('asserter');
local mod = {}

function get_concrete_window_size(widthRatio, heightRatio)
  local current_editor_width = vim.api.nvim_get_option('columns')
  local current_editor_height = vim.api.nvim_get_option('lines')
  local width = math.floor(current_editor_width * widthRatio)
  local height = math.floor(current_editor_height * heightRatio)
  return {
    width = width,
    height = height
  }
end

-- @param widthRatio {number} width ratio of the window
-- @param heightRatio {number} height ratio of the window
-- @param opts {table} options
-- @param opts.filetype {string} filetype of the buffer
-- @param opts.close_on_esc {boolean} close window on escape key
-- @returns {table}
-- @returns {number} window.winnr - opened window number
-- @returns {number} window.bufnr - opened buffer number
mod.open = function(widthRatio, heightRatio, opts)
  asserter.number(widthRatio, 'args[0] (widthRatio)')
  asserter.number(heightRatio, 'args[1] (heightRatio)')

  opts.close_on_esc = opts.close_on_esc or true

  local inner_bufnr = vim.api.nvim_create_buf(false, true);

  local winnr = nil;
  local render = function(bufnr)
    local window_dimensions = get_concrete_window_size(widthRatio, heightRatio)
    winnr = vim.api.nvim_open_win(bufnr, true, {
      width = window_dimensions.width,
      height = window_dimensions.height,
      row = math.floor((vim.api.nvim_get_option('lines') - window_dimensions.height) / 2),
      col = math.floor((vim.api.nvim_get_option('columns') - window_dimensions.width) / 2),
      relative = 'editor',
      border = 'rounded',
      anchor = 'NW',
      style = 'minimal'
    })
  end

  render(inner_bufnr)

  vim.api.nvim_create_augroup("floating_window", {})
  vim.api.nvim_create_autocmd("VimResized", {
    group = 'floating_window',
    callback = function()
      vim.api.nvim_win_close(winnr, true)
      render(inner_bufnr)
    end,
    buffer = inner_bufnr,
  })

  if opts.close_on_esc then
    vim.api.nvim_buf_set_keymap(inner_bufnr, 'n', '<ESC>', ':close ' .. winnr .. '<CR>', { noremap = true, silent = true })
    vim.api.nvim_buf_set_keymap(inner_bufnr, 't', '<ESC>', ':close ' .. winnr .. '<CR>', { noremap = true, silent = true })
  end

  if (opts.filetype ~= nil) then
    vim.api.nvim_buf_set_option(inner_bufnr, 'filetype', opts.filetype)
  end

  return {
    winnr = winnr,
    bufnr = inner_bufnr
  }
end

return mod
