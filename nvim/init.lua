--[[ Gloval variables ]]
vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.g.have_nerd_font = true

local DEBUG = false
function LOG(message)
  if DEBUG == true then
    vim.notify(vim.inspect(message))
  end
end

--[[ Configs ]]
require 'configs.options'
require 'configs.keymaps'
require 'configs.autocommands'
require 'configs.diagnostics'

--[[ Plugins ]]
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({ -- imports each plugins to easly disable the plugins
  -- { import = 'plugins' },
  { import = 'customs.jest' },
  { import = 'customs.pbcopy' },
  { import = 'customs.translate' },
  { import = 'plugins.cmp' },
  { import = 'plugins.lsp' },
  { import = 'plugins.oil' },
  { import = 'plugins.theme' },
  { import = 'plugins.noice' },
  { import = 'plugins.comment' },
  { import = 'plugins.lualine' },
  { import = 'plugins.dressing' },
  { import = 'plugins.gitsigns' },
  { import = 'plugins.neo-tree' },
  { import = 'plugins.which-key' },
  { import = 'plugins.telescope' },
  { import = 'plugins.dashboard' },
  { import = 'plugins.vim-sleuth' },
  { import = 'plugins.bufferline' },
  { import = 'plugins.treesitter' },
  { import = 'plugins.formatting' },
  -- { import = 'plugins.todo-comment' },
  { import = 'plugins.outline' },
  { import = 'plugins.indent-blankline' },
  { import = 'plugins.autopairs' },
  { import = 'plugins.copilot' },
}, {
  ui = {
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
    border = 'rounded',
  },
})
