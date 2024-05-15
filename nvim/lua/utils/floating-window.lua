local trim = require('utils.string').trim
local map = require('utils.list').map
local find_max = require('utils.list').find_max

local function print_to_cursor_floating_window(str)
  local lines = map(vim.split(str, '\n'), trim)
  local bufnr = vim.api.nvim_create_buf(false, true)
  local winnr = vim.api.nvim_open_win(bufnr, true, {
    relative = 'cursor',
    width = find_max(map(lines, string.len)),
    height = #lines,
    col = 0,
    row = 1,
    focusable = false,
    style = 'minimal',
    border = 'rounded',
    -- title = 'Translate', -- Exist in official document, but not included in manual (:h nvim_open_win)
    -- title_pos = 'center',
  })
  vim.api.nvim_win_set_option(winnr, "winhl", "Normal:Normal")
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
  vim.keymap.set('n', '<esc>', ':q<CR>', { buffer = bufnr, silent = true })
  return {
    bufnr = bufnr,
    winnr = winnr
  }
end

return {
  print_to_floating_window = print_to_cursor_floating_window
}
