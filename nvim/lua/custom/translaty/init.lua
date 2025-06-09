local h_shell = require 'lib.h-shell'
local h_buffer = require 'lib.h-buffer'
local h_string = require 'lib.string'
local h_list = require 'lib.h-list'
local pipe = require('lib.h-function').pipe

--- @class Translaty
local M = {}

--- @param target string text to translate
--- @param from string language code to translate from
--- @param to string language code to translate to
function M.translate(target, from, to)
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

local function ensure_trans_installed()
  if vim.fn.executable 'trans' == 0 then
    error 'trnaslate command is not installed. Please install translate-shell.'
  end
end

--- @class TranslatyOpts
--- @field lang { from: string, to: string }
--- @field keymaps { tranlate_selected: string, quit: string }

--- @param opts TranslatyOpts
M.setup = function(opts)
  ensure_trans_installed()
  local from_lang = opts.lang.from or 'en'
  local to_lang = opts.lang.to or 'ko'
  local trigger_keymap = opts.keymaps.tranlate_selected or 'tl'
  local quit_keymap = opts.keymaps.quit or 'q'
  vim.keymap.set('x', trigger_keymap, function()
    local selected = h_buffer.get_visual_selection()
    local stdout = M.translate(selected, from_lang, to_lang)
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
