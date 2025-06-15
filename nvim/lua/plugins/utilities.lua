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
    event = 'InsertEnter',
    cmd = {
      'InlineCompletionToggle',
      'InlineCompletionProvider',
      'InlineCompletionRequest',
    },
    config = function()
      require('custom.inline-completion').setup {
        provider = 'openai', -- or 'anthropic'
        auto_trigger = true,
        trigger_delay = 1000,
        keymaps = {
          accept = '<Tab>',
          reject = '<C-c>',
          next_suggestion = '<C-n>',
          prev_suggestion = '<C-p>',
        },
        providers = {
          openai = {
            api_key = vim.env.OPENAI_API_KEY,
            model = 'gpt-3.5-turbo',
            max_tokens = 50,
          },
          anthropic = {
            api_key = vim.env.ANTHROPIC_API_KEY,
            model = 'claude-3-haiku-20240307',
            max_tokens = 50,
          },
        }
      }
    end,
  },
}
