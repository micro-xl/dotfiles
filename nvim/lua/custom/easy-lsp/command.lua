--- @class EasyLspCommand
local M = {}

function M.setup()
  vim.api.nvim_create_user_command('LspInfo', function()
    vim.cmd 'checkhealth vim.lsp'
  end, {
    desc = 'Show LSP information',
  })

  vim.api.nvim_create_user_command('LspLog', function()
    vim.cmd.view(vim.lsp.get_log_path())
    vim.api.nvim_create_autocmd(
      { 'BufEnter', 'CursorHold', 'FocusGained' },
      { buffer = 0, command = 'checktime' }
    )                             -- Detect file changes

    vim.opt_local.autoread = true -- auto-read on file changes

    vim.api.nvim_create_autocmd(  -- Jump to the end of the log file
      { 'BufReadPost', 'FileChangedShellPost' },
      { buffer = 0, command = 'normal! G' }
    )
  end, {
    desc = 'Show LSP log',
  })
end

return M
