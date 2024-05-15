local devicon = require('nvim-web-devicons')

vim.api.nvim_set_hl(0, 'DevIconDefault', { fg = devicon.get_default_icon().color });
vim.api.nvim_set_hl(0, 'DevIconZip', { fg = '#F3E5AB' })

devicon.setup({
  override_by_extension = {
    icon = '',
    color = 'DevIconZip',
    name = 'Zip',
  }
})
