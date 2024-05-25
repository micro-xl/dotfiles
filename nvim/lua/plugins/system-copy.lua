return {
  {
    'christoomey/vim-system-copy',
    keys = {
      {
        'cp',
        mode = { 'n', 'v' },
      },
    },
    config = function()
      vim.g.system_copy_silent = 1
    end,
  },
}
