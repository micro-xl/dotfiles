local function toggle_g_status()
  if vim.bo.filetype == 'fugitive' then
    vim.cmd('bd!')
  else
    vim.cmd('tab G')
  end
end

vim.api.nvim_set_hl(0, 'DiffAdd', { bg = 'none', ctermbg = 'none' })
vim.api.nvim_set_hl(0, 'DiffChange', { bg = 'none', ctermbg = 'none' })
vim.api.nvim_set_hl(0, 'DiffText', { bg = 'none', ctermbg = 'none' })
vim.api.nvim_set_hl(0, 'DiffDelete', { bg = 'none', ctermbg = 'none' })
vim.keymap.set('n', '<leader>4', toggle_g_status, { noremap = true, silent = true })
