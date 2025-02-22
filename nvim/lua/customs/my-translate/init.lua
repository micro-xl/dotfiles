local h_shell = require 'lib.h-shell'
local h_buffer = require 'lib.h-buffer'
local h_string = require 'lib.h-string'
local h_list = require 'lib.h-list'
local pipe = require('lib.h-function').pipe

--[[ translate visual selection ]]

local M = {}

-- @param {string} target
-- @param {string} from
-- @param {string} to
function translate(target, from, to)
  local escape = pipe(h_string.escape_dollar_sign, h_string.escape_double_quote, h_string.trim)
  local cmd = 'trans '
    .. '-b '
    .. '-show-original n '
    .. '-show-original-phonetics n '
    .. '-show-translation n '
    .. '-show-translation-phonetics n '
    .. '-show-prompt-message n '
    .. '--no-ansi '
    .. from
    .. ':'
    .. to
    .. ' "'
    .. escape(target)
    .. '"'
  local stdout, err = h_shell.pexec(cmd)
  if err ~= nil or stdout == nil then
    error(err or 'Fail to translate')
  end
  return stdout
end

-- @param {table} opts
-- @param {table} opts.lang
-- @param {string} opts.lang.from
-- @param {string} opts.lang.to
-- @param {table} opts.keys - configs for keymaps
-- @param {string} opts.keys.trigger - keymap for visual mode
-- @param {string} opts.keys.quit - keymap for quit on the result buffer
M.setup = function(opts)
  local from_lang = opts.lang.from or 'en'
  local to_lang = opts.lang.to or 'ko'
  local trigger_keymap = opts.keys.trigger or 'tl'
  local quit_keymap = opts.keys.quit or 'q'
  vim.keymap.set('x', trigger_keymap, function()
    local selected = h_buffer.get_visual_selection()
    local stdout = translate(selected, from_lang, to_lang)
    local lines = h_list.map(vim.split(h_string.trim(stdout), '\n'), h_string.trim)
    local bufnr = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_open_win(bufnr, true, {
      relative = 'cursor',
      width = h_list.find_max(h_list.map(lines, string.len)),
      height = #lines,
      col = 0,
      row = 1,
      focusable = false,
      style = 'minimal',
      border = 'rounded',
      -- title = 'Translate', -- Exist in official document, but not included in manual (:h nvim_open_win)
      -- title_pos = 'center',
    })
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    vim.keymap.set('n', quit_keymap, ':q<CR>', { buffer = bufnr, silent = true })
  end, {})
end

return M
