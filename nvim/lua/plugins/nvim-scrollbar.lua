return {
  'petertriho/nvim-scrollbar',
  dependencies = {
    {
      'lewis6991/gitsigns.nvim',
      opts = {
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
        },
      },
    }
  },
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {
    show = true,
    show_in_active_only = true,
  }
}
