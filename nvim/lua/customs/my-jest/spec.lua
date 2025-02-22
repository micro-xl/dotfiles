return {
  dir = '~/.config/nvim/lua/customs/my-jest',
  name = 'customs.my-jest',
  keys = { '<F5>', '<leader><F5>', '<F6>', '<leader><F6>' },
  dependencies = {
    'preservim/vimux',
  },
  cmd = {
    'TestSingle',
    'TestSingleDebug',
    'TestSingleWatch',
    'TestSingleCopy',
    'TestSingleCopyDebug',
    'TestSingleCopyWatch',
  },
  opts = { test_command = 'jest' },
  config = function(_, opts)
    require('customs.my-jest').setup(opts)
  end,
}
