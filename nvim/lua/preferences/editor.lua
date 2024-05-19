local get_current_file_path = require('utils.path').get_current_file_path;


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
