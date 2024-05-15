local get_current_file_path = require('utils.path').get_current_file_path;
vim.opt.showmatch = true
vim.opt.autoread = true
vim.opt.autowrite = true
vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.cindent = true
vim.opt.ruler = true
vim.opt.wmnu = true
vim.opt.hlsearch = true
vim.opt.history = 500
vim.opt.encoding = 'utf8'
vim.opt.fileencodings = { 'utf-8', 'cp949' }
vim.opt.cursorline = true
vim.opt.smartcase = true
vim.opt.incsearch = true
vim.opt.enc = 'utf-8'
vim.opt.termguicolors = true
vim.opt.foldmethod = 'syntax'
vim.opt.foldenable = false
vim.opt.wrap = true
vim.opt.showmode = false
vim.opt.mousemoveevent = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.pumheight = 10
vim.opt.showcmd = true
vim.opt.langmap = 'ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz'

-- Diagnotistic
vim.api.nvim_create_autocmd(
  'CursorHold',
  {
    pattern = '*',
    callback = function()
      vim.diagnostic.open_float({})
    end
  }
)
vim.o.updatetime = 500
vim.diagnostic.config({
  virtual_text = false,
  float = {
    border = 'single',
    scope = 'cursor',
    focus = false,
    wrap = true,
  }
})

-- lsp event handler
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'single' })
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'single' })

-- File changed on disk
vim.api.nvim_create_autocmd(
  'FileChangedShellPost',
  {
    pattern = '*',
    callback = function()
      vim.cmd('echohl WarningMsg | echo "File Changed On Disk. Buffer reloaded." | echohl None')
      vim.cmd('e')
    end
  }
)

-- Decorate cursor
local cursor_column_group = vim.api.nvim_create_augroup('CursorColumn', { clear = true })
local cursor_line_group = vim.api.nvim_create_augroup('CursorLine', { clear = true })
-- vim.api.nvim_create_autocmd(
--   { 'VimEnter, WinEnter, BufWinEnter' },
--   {
--     pattern = '*',
--     group = cursor_column_group,
--     callback = function() vim.opt_local.cursorcolumn = true end,
--   }
-- )
-- vim.api.nvim_create_autocmd(
--   'WinLeave',
--   {
--     pattern = '*',
--     group = cursor_column_group,
--     callback = function() vim.opt_local.cursorcolumn = false end,
--   }
-- )
-- vim.api.nvim_create_autocmd(
--   { 'VimEnter, WinEnter, BufWinEnter' },
--   {
--     pattern = '*',
--     group = cursor_line_group,
--     callback = function() vim.opt_local.cursorline = true end
--   }
-- )
-- vim.api.nvim_create_autocmd(
--   'WinLeave',
--   {
--     pattern = '*',
--     group = cursor_line_group,
--     callback = function() vim.opt_local.cursorline = false end
--   }
-- )

vim.api.nvim_set_hl(0, 'VertSplit', { fg = '#FFFFFF' })
vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = '#FFFFFF' })




-- Save message
-- local save_message_augroup = vim.api.nvim_create_augroup('SaveMessage', { clear = true })
-- vim.api.nvim_set_hl(0, 'SaveIcon', { fg = '#98BF64' })
-- vim.api.nvim_create_autocmd('BufWritePost',
--   {
--     pattern = '*',
--     group = save_message_augroup,
--     callback = function()
--       vim.opt.cmdheight = 2
--       local current_file_path = get_current_file_path();
--       vim.api.nvim_echo({ { ' ', 'SaveIcon' }, { 'Saved ' .. current_file_path } }, false, {})
--       vim.opt.cmdheight = 1
--     end,
--   }
-- )


-- translate
local translate_shell = require('custom.translate-shell').translate_shell
vim.api.nvim_create_user_command("TranslateKrEn", function(command)
  print(translate_shell(command.args, 'ko', 'en', { brief = false }))
end, { nargs = 1 })
vim.api.nvim_create_user_command("TranslateEnKr", function(command)
  print(translate_shell(command.args, 'en', 'ko', { brief = false }))
end, { nargs = 1 })
vim.api.nvim_create_user_command("TranslateYank", function(command)
  local translated = translate_shell(command.args, 'en', 'ko', { brief = true })
  vim.cmd(":let @\" = '" .. translated .. "'")
  print("yank translated: " .. translated)
end, { nargs = 1 })
