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
  local lazypath = vim.fn.stdpath("data") .. "lua/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "https://github.com/folke/lazy.nvim.git",
      "--branch=stable", -- latest stable release
      lazypath,
    })
  end
  vim.opt.rtp:prepend(lazypath)

  require('lazy').setup({
    'dense-analysis/ale',
    'tpope/vim-endwise',
    'rebelot/kanagawa.nvim',
    'rcarriga/nvim-notify',
    'neovim/nvim-lspconfig',           -- configs for the nvim native LSP client
    'nvim-lua/plenary.nvim',           -- lua util function set like loadash in javascript
    'jose-elias-alvarez/null-ls.nvim', -- null language server to provides neovim's language server for extending other language server
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-nvim-lua',
    'hrsh7th/cmp-buffer',
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-cmdline',
    'f3fora/cmp-spell',
    'vijaymarupudi/nvim-fzf',
    'junegunn/fzf',
    'junegunn/fzf.vim',
    'j-hui/fidget.nvim',
    'nvim-tree/nvim-web-devicons',
    'nvim-tree/nvim-tree.lua',
    'christoomey/vim-system-copy',
    'terrortylor/nvim-comment',
    'windwp/nvim-autopairs',
    'luochen1990/rainbow',
    'github/copilot.vim',
    'folke/todo-comments.nvim',
    'Yggdroot/indentLine',
    'lewis6991/gitsigns.nvim',
    'nvim-lualine/lualine.nvim',
    {
      'akinsho/bufferline.nvim',
      dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    'hood/popui.nvim',
    'tpope/vim-fugitive',
    'APZelos/blamer.nvim',
    'nvim-telescope/telescope.nvim',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      dependencies = { 'nvim-telescope/telescope.nvim' },
      build = 'make'
    },
    {
      'tzachar/fuzzy.nvim',
      dependencies = { 'nvim-telescope/telescope-fzf-native.nvim' }
    },
    {
      'tzachar/cmp-fuzzy-path',
      dependencies = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim', 'junegunn/fzf.vim' }
    },
    {
      'tzachar/cmp-fuzzy-buffer',
      requires = { 'hrsh7th/nvim-cmp', 'tzachar/fuzzy.nvim' }
    },
    {
      'nvim-treesitter/nvim-treesitter',
      cmd = 'Tsupdate'
    },
    {
      'iamcco/markdown-preview.nvim',
      build = 'cd app && yarn install'
    },
    'MunifTanjim/nui.nvim',
    'stevearc/oil.nvim',
    'karb94/neoscroll.nvim',
    {
      "m4xshen/hardtime.nvim",
      dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    },
    "easymotion/vim-easymotion",
    "petertriho/nvim-scrollbar",
    "norcalli/nvim-colorizer.lua",
  })
  vim.loader.enable()
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
  vim.opt.foldmethod = 'syntax'
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
  require('kanagawa').load('wave') -- wave, dragon, lotus
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
  vim.api.nvim_set_hl(0, "LineNr", { fg = '#787878', bg = 'none' })
  vim.api.nvim_set_hl(0, "StatusLine", { bg = '#787878' })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none", fg = 'none' })
  vim.api.nvim_set_hl(0, "WinSeparator", { fg = "#ca8498", bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none", fg = "#ca8498" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsAdd", { bg = "none", fg = "#5f8559" })
  vim.api.nvim_set_hl(0, "GitSignsChange", { bg = "none", fg = "#a6a04c" })
  vim.api.nvim_set_hl(0, "GitSignsDelete", { bg = "none", fg = "#944051" })
  vim.api.nvim_set_hl(0, "GitSignsStagedAdd", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedAddLn", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedAddNr", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedChange", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedDelete", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedChangeLn", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedChangeNr", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedDeleteNr", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedTopdelete", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedTopdeleteNr", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedChangedelete", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteLn", { bg = "none" })
  vim.api.nvim_set_hl(0, "GitSignsStagedChangedeleteNr", { bg = "none" })
  vim.api.nvim_set_hl(0, "DiagnosticSignOk", { bg = 'none' })
  vim.api.nvim_set_hl(0, "DiagnosticSignHint", { bg = 'none', fg = '#9fb386' })
  vim.api.nvim_set_hl(0, "DiagnosticSignWarn", { bg = 'none', fg = '#c29d19' })
  vim.api.nvim_set_hl(0, "DiagnosticSignError", { bg = 'none', fg = '#963838' })
  vim.api.nvim_set_hl(0, "DiagnosticSignInfo", { bg = 'none', fg = '#9fb386' })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { bg = '#963838' })
  vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { bg = '#c29d19' })
  -- vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { bg = 'none'l})
  -- vim.api.nvim_set_hl(0, "DiagnositcError", { bg = "none", fg = '#FF4051' })
end

--------------------------------
---         colorizer         --
--------------------------------
do
  require('colorizer').setup()
end


--------------------------------
---         gitsigns          --
--------------------------------
do
  require('gitsigns').setup({
    signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
  });
end

--------------------------------
---        scrollbar          --
--------------------------------
do
  require('scrollbar').setup()
  require('scrollbar.handlers.gitsigns').setup()
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
    keymap = '<C-b>'
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
