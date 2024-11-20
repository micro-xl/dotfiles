return {
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    event = 'VeryLazy',
    branch = "canary",
    dependencies = {
      { "github/copilot.vim" },    -- or zbirenbaum/copilot.lua
      { "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
    },
    build = "make tiktoken",       -- Only on MacOS or Linux
    opts = {
      -- https://github.com/CopilotC-Nvim/CopilotChat.nvim/blob/canary/lua/CopilotChat/config.lua
      model = 'gpt-4o',  -- Default model to use, see ':CopilotChatModels' for available models (can be specified manually in prompt via $).
      agent = 'copilot', -- Default agent to use, see ':CopilotChatAgents' for available agents (can be specified manually in prompt via @).
      insert_at_end = true,
      clear_chat_on_new_prompt = false,
      temperature = 0.1, -- GPT result temperature
      mappings = {
        reset = {
          normal = '<C-r>',
          insert = '<C-r>',
        },
      }
    },
    -- See Commands section for default commands if you want to lazy load on them
    keys = {
      {
        "<leader>aa",
        function()
          local input = vim.fn.input("CopilotChat Question: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").buffer })
          end
        end,
        desc = "CopilotChat - Question with current buffer"
      },
      {
        mode = "v",
        "<leader>aa",
        function()
          local input = vim.fn.input("CopilotChat Question: ")
          if input ~= "" then
            require("CopilotChat").ask(input, { selection = require("CopilotChat.select").visual })
          end
        end,
        desc = "CopilotChat - Question with visual selection"
      }
    }
  },
}
