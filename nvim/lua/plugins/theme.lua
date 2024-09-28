--[[ Theme and style setting ]]

function load_kanagawa()
  local kanagawa = require 'kanagawa'
  kanagawa.setup {
    compile = true, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    functionStyle = {},
    keywordStyle = { italic = true },
    statementStyle = { bold = true },
    typeStyle = {},
    transparent = false, -- whethere set or not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    overrides = function(colors) -- add/modify highlights
      return {}
    end,
  }
  kanagawa.load 'dragon' -- dragon | wave | lotus
end

function load_catppuccin()
  require('catppuccin').setup {
    flavour = 'mocha', -- latte, frappe, macchiato, mocha
    transparent_background = true, -- disables setting the background color.
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
    term_colors = false, -- sets terminal colors (e.g. `g:terminal_color_0`)
    dim_inactive = {
      enabled = false, -- dims the background color of inactive window
      shade = 'dark',
      percentage = 0.15, -- percentage of the shade to apply to the inactive window
    },
    no_italic = false, -- Force no italic
    no_bold = false, -- Force no bold
    no_underline = false, -- Force no underline
    styles = { -- Handles the styles of general hi groups (see `:h highlight-args`):
      comments = { 'italic' }, -- Change the style of comments
      conditionals = { 'italic' },
      loops = {},
      functions = {},
      keywords = {},
      strings = {},
      variables = {},
      numbers = {},
      booleans = {},
      properties = {},
      types = {},
      operators = {},
      -- miscs = {}, -- Uncomment to turn off hard-coded styles
    },
    color_overrides = {},
    custom_highlights = {},
    default_integrations = true,
    integrations = {
      cmp = true,
      gitsigns = true,
      nvimtree = true,
      treesitter = true,
      notify = false,
      mini = {
        enabled = true,
        indentscope_color = '',
      },
      -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
    },
  }
  vim.cmd.colorscheme 'catppuccin'
end

function load_cyberdream()
  require('cyberdream').setup {
    -- Enable transparent background
    transparent = true,

    -- Enable italics comments
    italic_comments = false,

    -- Replace all fillchars with ' ' for the ultimate clean look
    hide_fillchars = false,

    -- Modern borderless telescope theme - also applies to fzf-lua
    borderless_telescope = false,

    -- Set terminal colors used in `:terminal`
    terminal_colors = true,

    -- Use caching to improve performance - WARNING: experimental feature - expect the unexpected!
    -- Early testing shows a 60-70% improvement in startup time. YMMV. Disables dynamic light/dark theme switching.
    cache = false, -- generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache

    theme = {
      variant = 'default', -- use "light" for the light variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`
    },

    -- Disable or enable colorscheme extensions
    extensions = {
      telescope = true,
      notify = true,
      mini = true,
    },
  }
  vim.cmd 'colorscheme cyberdream'
end

--
return {
  {
    'scottmckendry/cyberdream.nvim',
    -- 'catppuccin/nvim',
    -- 'rebelot/kanagawa.nvim',
    event = 'VimEnter',
    config = function()
      -- load_kanagawa()
      -- load_catppuccin()
      load_cyberdream()
      -- font : iosevka
      -- vim.api.nvim_set_hl(0, 'Normal', { bg = '#010112', fg = '#787878' })
      -- vim.api.nvim_set_hl(0, 'LineNr', { fg = '#787878', bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#787878' })
      -- vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none', fg = 'none' })
      -- vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'none', fg = '#ca8498' })
      -- vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = '#ca8498' })
      -- vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'FloatTitle', { bg = 'none', fg = '#FFFFFF' })
      -- vim.api.nvim_set_hl(0, 'GitSignsAdd', { bg = 'none', fg = '#5f8559' })
      -- vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none', fg = '#a6a04c' })
      -- vim.api.nvim_set_hl(0, 'GitSignsDelete', { bg = 'none', fg = '#944051' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedAdd', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedAddLn', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedAddNr', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedDelete', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedChangeLn', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedChangeNr', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedDeleteNr', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedTopdelete', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedTopdeleteNr', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedChangedelete', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedChangedeleteLn', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'GitSignsStagedChangedeleteNr', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticSignOk', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { bg = 'none', fg = '#9fb386' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { bg = 'none', fg = '#c29d19' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticSignError', { bg = 'none', fg = '#963838' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { bg = 'none', fg = '#9fb386' })
      -- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { fg = '#963838', undercurl = true })
      -- vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { fg = '#c29d19', undercurl = true, underdashed = false })
      -- vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none', fg = '#ca8498' })
      -- vim.api.nvim_set_hl(0, 'LspInfoBorder', { bg = 'none', fg = '#ca8498' })
      -- vim.api.nvim_set_hl(0, 'MsgArea', { bg = 'none', fg = '#ca8498' })

      -- vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
      -- vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { bg = 'none'l})
      -- vim.api.nvim_set_hl(0, "DiagnositcError", { bg = "none", fg = '#FF4051' })
    end,
  },
}
