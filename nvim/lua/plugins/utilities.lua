local cfg_path = vim.fn.stdpath "config"
local custom_module_path = cfg_path .. "/lua/custom/"

return {
  {
    dir = custom_module_path .. "test-js",
    name = "custom/test-js",
    dependencies = {
      "preservim/vimux",
    },
    cmd = {
      "TestSingle",
      "TestSingleDebug",
      "TestSingleWatch",
      "TestSingleCopy",
      "TestSingleCopyDebug",
      "TestSingleCopyWatch",
    },
    config = function()
      require("custom.test-js").setup {
        test_command = "jest",
      }
    end,
  },
  {
    dir = custom_module_path .. "translaty",
    name = "custom/translaty",
    config = function()
      require("custom.translaty").setup {
        lang = { from = "en", to = "ko" },
        keymaps = {
          trigger = "<leader>tl",
          quit = "<ESC>",
        },
      }
    end,
  },
  {
    dir = custom_module_path .. "open-completion",
    name = "custom/open-completion",
    config = function()
      -- print log to announce to complete setup
      local openComplete = require('custom.open-completion')
      openComplete.setup({
        completion_prompting = openComplete.COMPLETION_PROMPTING.CODELLAMA_7B,
        keymap = {
          request = "<C-e>",
          accept = "<C-y>",
          next = "<C-n>",
          prev = "<C-p>"
        }
      })
    end
  }
}
