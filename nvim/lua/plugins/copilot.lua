return {
  {
    'github/copilot.vim',
    enabled = false,
    config = function()
      vim.g.copilot_no_tap_map = true
      vim.g.copilot_filetype = {
        ['*'] = false,
        ['javascript'] = true,
        ['typescript'] = true,
        ['json'] = true,
        ['html'] = true,
        ['lua'] = true,
        ['oil'] = false,
      }
      vim.api.nvim_set_keymap('i', '<C-e>', '<Plug>(copilot-next)', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('i', '<C-q>', '<Plug>(copilot-previous)', { noremap = true, silent = true })
      vim.api.nvim_set_keymap('i', '<C-y>', '<Plug>(copilot-accept-word)', { noremap = true, silent = true })
    end,
  },
}
