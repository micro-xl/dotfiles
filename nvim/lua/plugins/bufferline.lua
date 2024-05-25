return {
  {
    'akinsho/bufferline.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('bufferline').setup {}
    end,
  },
}
