return {
  {
    'folke/noice.nvim',
    event = 'VeryLazy',
    dependencies = {
      { 'rebelot/kanagawa.nvim' },
      { 'MunifTanjim/nui.nvim' },
      'rcarriga/nvim-notify',
    },
    config = function()
      require('noice').setup {
        popupmenu = {
          backend = 'cmp', -- nui or cmp
        },
        lsp = {
          progress = {
            enabled = true,
          },
          hover = {
            enabled = true,
            silent = true, -- set to true to not show a message if hover is not available
            opts = {
              border = 'rounded',
            },
          },
        },
      }
      vim.api.nvim_set_hl(0, 'NoiceCmdlinePopupBorder', { link = 'FloatBorder' }) -- command line border color
    end,
  },
}

-- cmp 는 nvim-cmp ui 사용중
-- lsp 관련은noice 에 포함된 nui 사용중
