--[[ Configs for the startup screen for the vim ]]

return {
  {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
      require('dashboard').setup {
        --[[ theme config overrides the top level config. ]]
        shortcut_type = 'number', -- letter or number
        theme = 'hyper', -- hyper or doom
        config = { -- theme configs
          package = { enable = true }, -- show how many plugins neovim loaded
          disable_move = true,
          mru = { limit = 10, label = '', cwd_only = false },
          project = { enable = true, limit = 8, label = '', action = 'Telescope find_files cwd=' },
          week_header = { enable = true },
          footer = {},
        },
      }
      vim.api.nvim_set_hl(0, 'DashboardHeader', { fg = '#ca8498' })
    end,
    dependencies = { { 'nvim-tree/nvim-web-devicons' }, { 'rebelot/kanagawa.nvim' } },
  },
}
