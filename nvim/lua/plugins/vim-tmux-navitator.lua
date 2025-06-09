return {
  'christoomey/vim-tmux-navigator',
  cmd = {
    'TmuxNavigateLeft',
    'TmuxNavigateDown',
    'TmuxNavigateUp',
    'TmuxNavigateRight',
    'TmuxNavigatePrevious',
  },
  keys = {
    { '<C-w>h', '<CMD>TmuxNavigateLeft<CR>' },
    { '<C-w>j', '<CMD>TmuxNavigateDown<CR>' },
    { '<C-w>k', '<CMD>TmuxNavigateUp<CR>' },
    { '<C-w>l', '<CMD>TmuxNavigateRight<CR>' },
  },
  enabled = false,
}
