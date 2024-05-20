DEBUG = {
  lsp_attached_handler = false,
  formatting = false,
}


--------------------------------
--          prequire          --
--------------------------------
local require = require('prequire').prequire

--------------------------------
--        plugin-load         --
--------------------------------
do
  vim.cmd [[packadd packer.nvim]]
  local packer = require('packer')
  -- local use_rocks = packer.use_rocks;
  packer.startup(function(use)
    use('wbthomason/packer.nvim')
    use('dense-analysis/ale')
    use('tpope/vim-endwise')
    use('rebelot/kanagawa.nvim')
    use('rcarriga/nvim-notify')
    use('neovim/nvim-lspconfig')           -- configs for the nvim native LSP client.
    use('nvim-lua/plenary.nvim')           -- lua util function set like loadash in javascript
    use('jose-elias-alvarez/null-ls.nvim') -- null language server to provides neovim's language server for extending other language server
    use('L3MON4D3/LuaSnip');
    use('saadparwaiz1/cmp_luasnip')
    use('hrsh7th/nvim-cmp')
    use('hrsh7th/cmp-nvim-lsp')
    use('hrsh7th/cmp-nvim-lua')
    use('hrsh7th/cmp-buffer')
    use('hrsh7th/cmp-path')
    use('hrsh7th/cmp-cmdline')
    use('f3fora/cmp-spell')
    use('vijaymarupudi/nvim-fzf')
    use('junegunn/fzf')
    use('junegunn/fzf.vim')
    use({
      'j-hui/fidget.nvim',
    }) -- ui for LSP server
    use('nvim-tree/nvim-web-devicons')
    use('nvim-tree/nvim-tree.lua')
    use('christoomey/vim-system-copy')
    use('terrortylor/nvim-comment')
    use({
      'sonph/onehalf',
      rtp = 'vim/'
    })
    use('windwp/nvim-autopairs')
    use('luochen1990/rainbow')
    use('github/copilot.vim')
    use('folke/todo-comments.nvim')
    use('Yggdroot/indentLine')
    use('lewis6991/gitsigns.nvim')
    use('nvim-lualine/lualine.nvim')
    use({
      'Theyashsawarkar/bufferline.nvim',
      tag = '*',
      require = 'nvim-tree/nvim-web-devicons'
    })
    use('hood/popui.nvim')
    use('tpope/vim-fugitive')
    use('APZelos/blamer.nvim')
    use('nvim-telescope/telescope.nvim')
    use({
      'nvim-telescope/telescope-fzf-native.nvim',
      run = 'make',
      requires = { 'nvim-telescope/telescope.nvim' },
    })
    use({ 'tzachar/fuzzy.nvim', requires = { 'nvim-telescope/telescope-fzf-native.nvim' } })
    use({
      'tzachar/cmp-fuzzy-path',
      requires = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim', 'junegunn/fzf.vim' }
    })
    use({
      'tzachar/cmp-fuzzy-buffer',
      requires = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' }
    })
    use({
      'nvim-treesitter/nvim-treesitter',
      run = ':tsupdate'
    })
    use({
      'iamcco/markdown-preview.nvim',
      run = 'cd app && yarn install'
    })
    use('MunifTanjim/nui.nvim')
    use({ "stevearc/oil.nvim" })
    use({ "karb94/neoscroll.nvim" })
    use({
      "m4xshen/hardtime.nvim",
      dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim"
      },
      opts = {}
    })
    use("easymotion/vim-easymotion")
    -- use('marko-cerovac/material.nvim')
    -- use('bluz71/vim-moonfly-colors')
    -- use('nyoom-engineering/oxocarbon.nvim')
    -- use('Shatur/neovim-ayu')
    -- use_rocks({ 'rxlua' });
    -- use_rocks({ 'penlight' });
  end);
end

--------------------------------
---          notify          ---
--------------------------------
do
  vim.notify = require('notify')
  vim.notify.setup({
    render = 'default', -- 'default' | 'minimal' | 'compact'
    opacity = 0.4
  })
end


--------------------------------
--        vim-options         --
--------------------------------
do
  vim.opt.showmatch = true
  vim.opt.autoread = true
  vim.opt.autowrite = true
  vim.opt.mouse = 'a'
  vim.opt.number = true
  vim.opt.autoindent = true
  vim.opt.smartindent = true
  vim.opt.expandtab = true
  vim.opt.tabstop = 2
  vim.opt.shiftwidth = 2
  vim.opt.cindent = true
  vim.opt.ruler = true
  vim.opt.wmnu = true
  vim.opt.hlsearch = true
  vim.opt.history = 500
  vim.opt.encoding = 'utf8'
  vim.opt.fileencodings = { 'utf-8', 'cp949' }
  vim.opt.cursorline = true
  vim.opt.smartcase = true
  vim.opt.incsearch = true
  vim.opt.enc = 'utf-8'
  vim.opt.termguicolors = true
  vim.opt.foldmethod = 'syntax'
  vim.opt.foldenable = false
  vim.opt.wrap = true
  vim.opt.showmode = false
  vim.opt.mousemoveevent = true
  vim.opt.backspace = { 'indent', 'eol', 'start' }
  vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
  vim.opt.pumheight = 10
  vim.opt.showcmd = true
  vim.opt.langmap = 'ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz'
  vim.opt.foldmethod = 'manual'
  vim.opt.updatetime = 500
end



--------------------------------
--         diagnostics        --
--------------------------------
do
  vim.api.nvim_create_autocmd(
    'CursorHold',
    {
      pattern = '*',
      callback = function()
        vim.diagnostic.open_float({})
      end
    }
  )
  vim.diagnostic.config({
    virtual_text = false,
    float = {
      border = 'single',
      scope = 'cursor',
      focus = false,
      wrap = true,
    }
  })
end

--------------------------------
--           style            --
--------------------------------
do
  -- colorscheme (kanagawa)
  require('kanagawa').load('dragon')
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none', ctermbg = 'none' })
  vim.api.nvim_set_hl(0, "NonText", { bg = 'none', ctermbg = 'none' })

  -- split divider
  vim.api.nvim_set_hl(0, 'VertSplit', { fg = '#FFFFFF', ctermfg = 'white' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { fg = '#FFFFFF', ctermfg = 'white' })
end

--------------------------------
--       remember-fold        --
--------------------------------
do
  require('remember-fold').setup({
    enabled = true,
    ignore_filetypes = { 'oil', 'bookmarks' },
  })
end

--------------------------------
--          terminal          --
--------------------------------
do
  require('terminal').setup({
    open_terminal_h_cmd = 'Hterminal',
    open_terminal_v_cmd = 'Vterminal',
    open_terminal_h_keymap = '<C-a>s',
    open_terminal_v_keymap = '<C-a>v',
    close_terminal_keymap = '<C-a>x',
  })
end

--------------------------------
---         bookmarks         --
--------------------------------
do
  require('bookmarks').setup({
    bookmarks_file_path = '~/.bookmarks',
    open_command = 'Bookmarks',
    edit_command = "BookmarksEdit",
    keymap_open = 'π',
  })
end

--------------------------------
---         find-file         --
--------------------------------
do
  require('find-file').setup({
    command = 'FindFile',
    keymap = '<C-p>',
    excludes = { 'node_modules', 'dist', 'esm', '.git' }
  })
end

--------------------------------
---          buffers          --
--------------------------------
do
  require('buffers').setup({
    command = 'Buffers',
    keymap = '<TAB>'
  })
end

-- below legacy

require('preferences.editor')
require('preferences.keybindings')
require('preferences.neovide')
require('plugins.plugin-load')
require('custom.command');
require('custom.jest-run')
require('custom.translate-shell')
require('custom.zshrc').setup({})
require('custom.swapfile').setup({})



-- How to implements the new features to neovim
--
-- 1. Use Language-Service of each language server
-- Each language server provides the services of the language. (ex. organize imports, format, etc.)
-- I can trigger this service by calling the Language-Service API of the language server.
-- Also, I can consider to implements custom abstract layer to send message for calling these API like this.
-- Like this,
-- ``` lua
-- LspService {
--   sendRequestSyncToLspServer(launguage_server, service_name, arguments)
-- }
-- ```
--
-- However, this may be an over-abstraction adding obsolete protocols.
-- There is many implements for each language server to call the Language-Service API of language server(ex. typescript.nvim).
-- Furthermore, these plugins provides the complex and extended features which are the language server can't provides.
--
-- 2. null-ls
--
--
-- No, already exists the implementation of this. typescript.nvim
-- need for sending specific command for specific language server

-- No
-- RemotePlugin
-- node-clien usage study, what is server for node-client?

-- ExtendedLanguageService
-- how 1: make treesitter plugin using lua script
-- how 2: make remote plugin with tsmorph
-- how 3: make language-server plugin (like tsserver-plugin) for language-service
--
-- telescope
-- throw error when bookmarks empty CR
--
--
