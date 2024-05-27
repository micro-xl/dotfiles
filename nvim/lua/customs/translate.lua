local h_shell = require('lib.h-shell');
local h_buffer = require('lib.h-buffer');
local h_string = require('lib.h-string');
local h_list = require('lib.h-list');
local pipe = require('lib.h-function').pipe;

--[[ translate visual selection ]]

return {
  {
    dir = 'custom.translate',
    config = function()
      local escape = pipe(
        h_string.escape_dollar_sign,
        h_string.escape_double_quote,
        h_string.trim
      )
      vim.keymap.set('x', 'tl', function()
        local selected = h_buffer.get_visual_selection();
        local cmd = "trans " ..
            "-b " ..
            "-show-original n " ..
            "-show-original-phonetics n " ..
            "-show-translation n " ..
            "-show-translation-phonetics n " ..
            "-show-prompt-message n " ..
            "--no-ansi " ..
            'en' .. ":" .. 'ko' .. ' "' .. escape(selected) .. '"'
        local stdout, err = h_shell.pexec(cmd)
        if err ~= nil or stdout == nil then
          error(err or 'Fail to translate');
        end
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
        vim.keymap.set('n', '<esc>', ':q<CR>', { buffer = bufnr, silent = true })
      end, {})
    end
  }
}
