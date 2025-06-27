local h_path = require 'lib.h-path'
local assert = require 'lib.asserter'

--- @class KeymapsConfig
local M = {}

--- @class KeymapsConfigOptions
--- @field leader? string
--- @field enable_continously_indent_move? boolean
--- @field enable_ctrl_s_to_save? boolean
--- @field keymap_to_move_visual_selection_down? string
--- @field keymap_to_move_visual_selection_up? string
--- @field keymap_delete_current_buffer_force? string
--- @field keymap_wrap_pairs_leader? string
--- @field keymap_previous_buffer? string
--- @field keymap_next_buffer? string
--- @field keymap_close_other_buffers? string
--- @field keymap_previous_tab? string
--- @field keymap_next_tab? string
--- @field keymap_close_current_tab? string
--- @field keymap_new_tab? string
--- @field resize_window_unit? number
--- @field enable_paste_without_yanking? boolean
--- @field keymap_search? string

local defaults = {
  leader = ' ',
  enable_continously_indent_move = true,
  enable_ctrl_s_to_save = true,
  keymap_to_move_visual_selection_down = '∆',
  keymap_to_move_visual_selection_up = '˚',
  keymap_delete_current_buffer_force = '<C-b>D',
  keymap_wrap_pairs_leader = ',',
  keymap_previous_buffer = '[b',
  keymap_next_buffer = ']b',
  keymap_close_other_buffers = '<C-b>C',
  keymap_previous_tab = '<C-t>p',
  keymap_next_tab = '<C-t>n',
  keymap_close_current_tab = '<C-t>x',
  keymap_new_tab = '<C-t>c',
  resize_window_unit = 25,
  enable_paste_without_yanking = true,
  keymap_search = '/',
}

--- @param opts? KeymapsConfigOptions
function M.setup(opts)
  opts = vim.tbl_deep_extend('force', defaults, opts or {})
  assert.not_nil(opts.leader, 'opts.leader')
  vim.g.mapleader = opts.leader
  vim.g.maplocalleader = opts.leader

  vim.keymap.set('v', opts.keymap_to_move_visual_selection_down, '', { desc = 'move selection down' })
  vim.keymap.set('v', opts.keymap_to_move_visual_selection_up, '', { desc = 'move selection up' })
  vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { silent = true, desc = 'Clear search highlighting' })
  vim.keymap.set('v', '$', '$h', { desc = 'Move to last non-blank character of the line' })

  local wrapping_key = opts.keymap_wrap_pairs_leader
  vim.keymap.set('n', wrapping_key .. "'", "ciw'<C-r>\"'<esc>", { desc = 'Wrap current word in single quotes' })
  vim.keymap.set('n', wrapping_key .. '"', 'ciw"<C-r>""<esc>', { desc = 'Wrap current word in double quotes' })
  vim.keymap.set('v', wrapping_key .. "'", "c'<C-r>\"'<esc>", { desc = 'Wrap selection in single quotes' })
  vim.keymap.set('v', wrapping_key .. '"', 'c"<C-r>""<esc>', { desc = 'Wrap selection in double quotes' })
  vim.keymap.set('n', wrapping_key .. '(', 'ciw(<C-r>")<esc>', { desc = 'Wrap current word in parentheses' })
  vim.keymap.set('n', wrapping_key .. '{', 'ciw{<C-r>"}<esc>', { desc = 'Wrap current word in curly braces' })
  vim.keymap.set('n', wrapping_key .. '[', 'ciw[<C-r>"]<esc>', { desc = 'Wrap current word in square brackets' })
  vim.keymap.set('n', wrapping_key .. '<', 'ciw<<C-r>"><esc>', { desc = 'Wrap current word in angle brackets' })
  vim.keymap.set('n', wrapping_key .. '`', 'ciw`<C-r>"`<esc>', { desc = 'Wrap current word in backticks' })
  vim.keymap.set('v', wrapping_key .. '(', 'c(<C-r>")<esc>vi(', { desc = 'Wrap selection in parentheses' })
  vim.keymap.set('v', wrapping_key .. '{', 'c{<C-r>"}<esc>vi{', { desc = 'Wrap selection in curly braces' })
  vim.keymap.set('v', wrapping_key .. '[', 'c[<C-r>"]<esc>vi[', { desc = 'Wrap selection in square brackets' })
  vim.keymap.set('v', wrapping_key .. '<', 'c<<C-r>"><esc>vi<', { desc = 'Wrap selection in angle brackets' })
  vim.keymap.set('v', wrapping_key .. '`', 'c`<C-r>"`<esc>vi`', { desc = 'Wrap selection in backticks' })

  if opts.enable_continously_indent_move then
    vim.keymap.set('v', '>', '>gv', { desc = 'Indent selection continously' })
    vim.keymap.set('v', '<', '<gv', { desc = 'Unindent selection continously' })
  end

  vim.keymap.set('n', '*', '*N', { silent = true, desc = 'Find occurrences of word under cursor' })
  vim.keymap.set('v', '*', "y/\\V<C-R>=escape(@\",'/')<CR><CR>N",
    { silent = true, desc = 'Find occurrences of selection' })
  vim.keymap.set('n', opts.keymap_delete_current_buffer_force, ':bd!<CR>',
    { silent = true, desc = 'Force delete current buffer' })

  -- Tab Navigation
  vim.keymap.set('n', opts.keymap_next_tab, ':tabnext<CR>', { silent = true, desc = 'Go to next tab' })
  vim.keymap.set('n', opts.keymap_previous_tab, ':tabprev<CR>', { silent = true, desc = 'Go to previous tab' })
  vim.keymap.set('n', opts.keymap_close_current_tab, ':tabclose<CR>', { silent = true, desc = 'Close current tab' })
  vim.keymap.set('n', opts.keymap_new_tab, ':tabnew<CR>', { silent = true, desc = 'Open new tab' })

  -- Resize window
  local resize_unit = opts.resize_window_unit
  vim.keymap.set('n', '<C-w><', resize_unit .. '<C-w><', { silent = true, desc = 'Decrease window width' })
  vim.keymap.set('n', '<C-w>>', resize_unit .. '<C-w>>', { silent = true, desc = 'Increase window width' })
  vim.keymap.set('n', '<C-w>-', resize_unit .. '<C-w>-', { silent = true, desc = 'Decrease window height' })
  vim.keymap.set('n', '<C-w>+', resize_unit .. '<C-w>+', { silent = true, desc = 'Increase window height' })

  if opts.enable_ctrl_s_to_save then
    vim.keymap.set('i', '', '<ESC>:w<CR>', { silent = true, desc = 'Save current buffer' })
    vim.keymap.set('n', '<C-s>', ':w<CR>', { silent = true, desc = 'Save current buffer' })
  end

  vim.keymap.set('n', opts.keymap_previous_buffer, ':bp<CR>', { silent = true, desc = 'Go to previous buffer' })
  vim.keymap.set('n', opts.keymap_next_buffer, ':bn<CR>', { silent = true, desc = 'Go to next buffer' })
  vim.keymap.set('t', opts.keymap_previous_buffer, '<C-\\><C-n>bp<CR>',
    { silent = true, desc = 'Go to previous buffer in terminal mode' })
  vim.keymap.set('t', opts.keymap_next_buffer, '<C-\\><C-n>:bn<CR>',
    { silent = true, desc = 'Go to next buffer in terminal mode' })

  vim.keymap.set('n', opts.keymap_close_other_buffers, ':%bd|e#|bd#<CR><C-o>',
    { silent = true, desc = 'Close other buffers' })

  if opts.enable_paste_without_yanking then
    vim.keymap.set('x', 'p', '"_dP', { silent = true })
  end

  -- TODO: move this keymap to project settings
  -- Change CWD to root path of current file
  vim.keymap.set('n', '©', h_path.change_cwd_to_root_dir_of_cur_file, { silent = true })

  -- TODO: move this keymap to diagnostics settings
  -- Diagnostics
  vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, {})
  vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, {})

  vim.keymap.set('n', opts.keymap_search, function()
    vim.api.nvim_feedkeys('/', 'n', false)
  end, { silent = true })
end

return M
