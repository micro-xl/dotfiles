-- [[
-- avante.nvim is a Neovim plugin designed to emulate the behaviour of the Cursor AI IDE.
-- It provides users with AI-driven code suggestions and the ability to apply these recommendations directly to their source files with minimal effort.
-- ]]
--
function AvanteAskWithLSPType()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/hover', params, function(err, result, ctx, _)
    if err or not result then
      vim.notify('No LSP hover information available.', vim.log.levels.WARN)
      return
    end
    local markdown_lines = vim.lsp.util.convert_input_to_markdown_lines(result.contents)
    local type_info = table.concat(markdown_lines, '\n')
    local prompt = string.format(
      'The following is the type information retrieved from the Language Server Protocol (LSP) at the current cursor position:\n\n%s\n\nPlease use this information to assist with any questions or clarifications I might have regarding this code segment.',
      type_info
    )
    require('avante.api').ask { prompt = prompt }
  end)
end

vim.api.nvim_create_user_command('AvanteAskWithLSPType', AvanteAskWithLSPType, {})

return {
  'yetone/avante.nvim',
  event = 'VeryLazy',
  version = false, -- Never set this value to "*"! Never!
  opts = {
    -- add any opts here
    -- for example
    provider = 'openai',
    openai = {
      endpoint = 'https://api.openai.com/v1',
      model = 'gpt-4o', -- your desired model (or use gpt-4o, etc.)
      timeout = 30000, -- Timeout in milliseconds, increase this for reasoning models
      temperature = 0,
      max_tokens = 8192, -- Increase this to include reasoning tokens (for reasoning models)
      --reasoning_effort = "medium", -- low|medium|high, only used for reasoning models
    },
  },
  -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
  build = 'make',
  -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
  dependencies = {
    'nvim-treesitter/nvim-treesitter',
    'stevearc/dressing.nvim',
    'nvim-lua/plenary.nvim',
    'MunifTanjim/nui.nvim',
    --- The below dependencies are optional,
    'echasnovski/mini.pick', -- for file_selector provider mini.pick
    'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
    'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
    'ibhagwan/fzf-lua', -- for file_selector provider fzf
    'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
    'zbirenbaum/copilot.lua', -- for providers='copilot'
    {
      -- support for image pasting
      'HakonHarnes/img-clip.nvim',
      event = 'VeryLazy',
      opts = {
        -- recommended settings
        default = {
          embed_image_as_base64 = false,
          prompt_for_file_name = false,
          drag_and_drop = {
            insert_mode = true,
          },
          -- required for Windows users
          use_absolute_path = true,
        },
      },
    },
    {
      -- Make sure to set this up properly if you have lazy=true
      'MeanderingProgrammer/render-markdown.nvim',
      opts = {
        file_types = { 'markdown', 'Avante' },
      },
      ft = { 'markdown', 'Avante' },
    },
  },
}
