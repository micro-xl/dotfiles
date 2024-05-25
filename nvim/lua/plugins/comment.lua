-- Comment visual regions/lines

return {
  { -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    keys = {
      {
        '<C-/>',
        mode = { 'n', 'v' },
      },
      {
        '<C-?>',
        mode = { 'n', 'v' },
      },
    },
    opts = {
      toggler = {
        line = '<C-/>',
        block = '<C-?>',
      },
      opleader = {
        line = '<C-/>',
        block = '<C-?>',
      },
    },
  },
}
