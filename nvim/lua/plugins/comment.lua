-- Comment visual regions/lines

return {
  { -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    keys = { '<C-/>', '<C-?>' },
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
