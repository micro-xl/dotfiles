-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    -- { '<leader>1', ':Neotree ' .. vim.fn.getcwd(-1, -1) .. '<CR>', { desc = 'NeoTree', silent = true } },
    {
      '<leader>1',
      function()
        vim.cmd('Neotree' .. vim.fn.getcwd(-1, -1))
      end,
      { desc = 'NeoTree', silent = true },
    },
  },
  opts = {
    filesystem = {
      window = {
        position = 'left', -- left | current
        width = 100,
        mappings = {
          ['<leader>1'] = 'close_window',
        },
      },
      follow_current_file = {
        enabled = false,
      },
      filtered_items = {
        visible = true,
        show_hidden_count = true,
        hide_dotfiles = false,
        hide_hidden = false,
        hide_gitignored = false,
      },
      hijack_netrw_behavior = 'disabled',
      use_libuv_file_watcher = true,
    },
  },
}
