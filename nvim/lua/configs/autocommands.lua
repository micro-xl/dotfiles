vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
vim.api.nvim_create_autocmd('FileChangedShellPost', {
  pattern = '*',
  callback = function()
    vim.cmd 'echohl WarningMsg | echo "File Changed On Disk. Buffer reloaded." | echohl None'
    vim.cmd 'e'
  end,
})
vim.api.nvim_create_autocmd('CursorHold', {
  desc = 'Open a floating diagnostic when cursor hold',
  pattern = '*',
  callback = function()
    vim.diagnostic.open_float {}
  end,
})
