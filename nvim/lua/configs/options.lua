vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = false -- Add relative line numbers, to help with jumping.
vim.opt.mouse = 'a' -- Enable mouse mode
vim.opt.showmatch = true -- Show matched character on '/' search.
-- TODO: Comment for below options. Study and Make notes.
vim.opt.autoread = true
vim.opt.autowrite = true
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
vim.opt.termguicolors = true
vim.opt.foldmethod = 'manual'
vim.opt.foldenable = false
vim.opt.wrap = true
vim.opt.mousemoveevent = true
vim.opt.backspace = { 'indent', 'eol', 'start' }
vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }
vim.opt.pumheight = 10
vim.opt.showcmd = true
vim.opt.langmap = 'ㅁa,ㅠb,ㅊc,ㅇd,ㄷe,ㄹf,ㅎg,ㅗh,ㅑi,ㅓj,ㅏk,ㅣl,ㅡm,ㅜn,ㅐo,ㅔp,ㅂq,ㄱr,ㄴs,ㅅt,ㅕu,ㅍv,ㅈw,ㅌx,ㅛy,ㅋz' -- Map Hangul inputs to English on normal mode
vim.opt.showmode = false -- Show current mode. It is replaced by status line
vim.opt.breakindent = false -- Enable break indent
vim.opt.undofile = true -- Save undo history
vim.opt.ignorecase = true -- Ignore case on '/' search
vim.opt.smartcase = true -- Enable smartcase on '/' search. Automatically case match applied
vim.opt.incsearch = true -- Live search on= '/' search. Don't need press enter to start searching
vim.opt.signcolumn = 'yes' -- Enable signcolumn on left side gutter
vim.opt.updatetime = 250 -- Decrease update time
vim.opt.timeoutlen = 300 -- Decrease mapped sequence wait time. (Displays which-key popup sooner)
vim.opt.splitright = true -- Default split window direction
vim.opt.splitbelow = true -- Default split window direction
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' } -- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.inccommand = 'split' -- Preview substitutions live, as you type!
vim.opt.cursorline = true -- Show which line your cursor is on
vim.opt.scrolloff = 10 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.clipboard = 'unnamedplus'
vim.api.nvim_exec('language en_US', true)
