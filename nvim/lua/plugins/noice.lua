return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'MunifTanjim/nui.nvim' },
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        cmdline = {
          format = {
            search_down_case_match = {
              kind = 'search',
              pattern = '^/c',
              icon = '  C',
              lang = 'regex',
            }, -- /c for case sensitive matching
          },
        },
        messages = {
          enabled = true,
          view = 'mini',
          -- Or can use each implementation for specific situation
          view_error = 'notify',       -- view for errors
          view_warn = 'notify',        -- view for warnings
          -- view_history = 'messages', -- view for :messages
          view_search = 'virtualtext', -- view for search count messages. Set to `false` to disable
        },
        popupmenu = {
          backend = 'cmp', -- nui or cmp
          opts = {
            winblend = 0,
            border = 'rounded',
          },
        },
        lsp = {
          progress = {
            enabled = true,
            view = 'mini',
          },
          hover = {
            enabled = true,
            silent = true, -- set to true to not show a message if hover is not available
            opts = {
              border = 'rounded',
            },
          },
        },
        presets = {
          bottom_search = false, -- use a classic bottom cmdline for search
          -- command_palette = true, -- position the cmdline and popupmenu together
          -- long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false,    -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = true, -- add a border to hover docs and signature help
        },
      }
      vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { link = 'FloatBorder' }) -- command line border color
    end,
  },
}

-- cmp 는 nvim-cmp ui 사용중
-- lsp 관련은 noice 에 포함된 nui 사용중
-- Messages
