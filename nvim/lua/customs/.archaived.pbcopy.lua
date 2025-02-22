--[[ cp for pbcopy visual select ]]

local h_buffer = require 'lib.h-buffer'
local h_shell = require 'lib.h-shell'
local h_string = require 'lib.h-string'
local pipe = require('lib.h-function').pipe

return {
  dir = 'custom.pbcopy',
  keys = {
    { 'cp', mode = { 'n', 'v', 'x' } },
  },
  config = function()
    vim.keymap.set('x', 'cp', function()
      local selected = h_buffer.get_visual_selection()
      local escape = pipe(h_string.escape_dollar_sign, h_string.escape_double_quote)
      h_shell.pexec('printf "%s" "' .. escape(selected) .. '" | ' .. 'pbcopy')
    end, {})
  end,
}
