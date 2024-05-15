local function toggle_g_status()
  if vim.bo.filetype == 'fugitive' then
    vim.cmd('bd!')
  else
    vim.cmd('tab G')
  end
end

vim.keymap.set('n', '<leader>4', toggle_g_status, { noremap = true, silent = true })
