--[[ Indent blankline visual tab lines ]]
return {
  {
    'lukas-reineke/indent-blankline.nvim',
    event = 'VimEnter',
    main = 'ibl',
    opts = {
      indent = {
        char = '│',
        highlight = 'LineNr',
      },
      exclude = {
        filetypes = { 'dashboard' },
      },
    },
  },
}
