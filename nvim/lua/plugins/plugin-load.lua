vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])


require('plugins.lsp.nvim-lspconfig')
require('plugins.luasnip')
require('plugins.nvim-cmp')
require('plugins.cmp-spell')
require('plugins.fidget')
require('plugins.nvim-tree')
require('plugins.vim-system-copy')
require('plugins.nvim-comment')
require('plugins.nvim-autopairs')
require('plugins.rainbow')
require('plugins.indentLine')
require('plugins.gitsigns')
-- Theme
-- require('plugins.themes.vscode')
-- require('plugins.themes.neovim-ayu')
-- require('plugins.themes.oxocarbon')
-- require('plugins.themes.moonfly')
-- require('plugins.themes.material')
-- require('plugins.themes.jellybeans')
-- require('plugins.themes.tokyonight')
require('plugins.themes.transparent-background')
require('plugins.lualine')
require('plugins.bufferline')
require('plugins.popui')
require('plugins.fugitive')
require('plugins.blamer')
require('plugins.nvim-treesitter')
require('plugins.telescope')
require('plugins.copilot')
require('plugins.oil')
require('plugins.neoscroll')
-- require('plugins.hardtime')
-- require('plugins.chat-gpt')
