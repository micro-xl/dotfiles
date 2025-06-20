local cfg_path = vim.fn.stdpath 'config'
local custom_module_path = cfg_path .. '/lua/custom/'

return {
  {
    dir = custom_module_path .. 'test-js',
    name = 'custom/test-js',
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
    config = function()
      require('custom.test-js').setup {
        test_command = 'jest',
      }
    end,
  },
  {
    dir = custom_module_path .. 'translaty',
    name = 'custom/translaty',
    config = function()
      require('custom.translaty').setup {
        lang = { from = 'en', to = 'ko' },
        keymaps = {
          trigger = '<leader>tl',
          quit = '<ESC>',
        },
      }
    end,
  },
  {
    dir = custom_module_path .. 'inline-completion',
    name = 'custom/inline-completion',
    config = function()
    end
  }
}
