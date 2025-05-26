--[[ Theme and style setting ]]
--
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
  kanagawa.load 'wave' -- dragon | wave | lotus
  vim.api.nvim_set_hl(0, 'Normal', { bg = 'none', fg = '#787878' })
  vim.api.nvim_set_hl(0, 'LineNr', { fg = '#787878', bg = 'none' })
  vim.api.nvim_set_hl(0, 'StatusLine', { bg = '#ca8498' })
  vim.api.nvim_set_hl(0, 'StatusLineNC', { bg = '#ca8498' })
  vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'none', fg = 'none' })
  vim.api.nvim_set_hl(0, 'WinSeparator', { bg = 'none', fg = '#ca8498' })
  vim.api.nvim_set_hl(0, 'VertSplit', { bg = 'none', fg = '#ca8498' })
  vim.api.nvim_set_hl(0, 'FloatBorder', { bg = 'none', fg = '#ca8498' })
  vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'FloatTitle', { bg = 'none', fg = '#FFFFFF' })
  vim.api.nvim_set_hl(0, 'GitSignsAdd', { bg = 'none', fg = '#5f8559' })
  vim.api.nvim_set_hl(0, 'GitSignsChange', { bg = 'none', fg = '#a6a04c' })
  vim.api.nvim_set_hl(0, 'GitSignsDelete', { bg = 'none', fg = '#944051' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedAdd', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedAddLn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedAddNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChange', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedDelete', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChangeLn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChangeNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedDeleteNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedTopdelete', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedTopdeleteNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChangedelete', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChangedeleteLn', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'GitSignsStagedChangedeleteNr', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignOk', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignHint', { bg = 'none', fg = '#9fb386' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignWarn', { bg = 'none', fg = '#c29d19' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignError', { bg = 'none', fg = '#963838' })
  vim.api.nvim_set_hl(0, 'DiagnosticSignInfo', { bg = 'none', fg = '#9fb386' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineError', { fg = '#963838', undercurl = true })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineWarn', { fg = '#c29d19', undercurl = true, underdashed = false })
  vim.api.nvim_set_hl(0, 'TelescopeBorder', { bg = 'none', fg = '#ca8498' })
  vim.api.nvim_set_hl(0, 'LspInfoBorder', { bg = 'none', fg = '#ca8498' })
  vim.api.nvim_set_hl(0, 'MsgArea', { bg = 'none', fg = '#ca8498' })
  vim.g.terminal_color_0 = '#160017'

  vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'DiagnosticUnderlineInfo', { bg = 'none' })
  vim.api.nvim_set_hl(0, 'DiagnositcError', { bg = 'none', fg = '#FF4051' })
end

function load_onedark()
  require('onedark').setup {
    -- Main options --
    style = 'light', -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
    transparent = false, -- Show/hide background
    term_colors = true, -- Change terminal color as per the selected theme style
    ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
    cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu

    -- toggle theme style ---
    toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
    toggle_style_list = { 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer', 'light' }, -- List of styles to toggle between

    -- Change code style ---
    -- Options are italic, bold, underline, none
    -- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
    code_style = {
      comments = 'italic',
      keywords = 'none',
      functions = 'none',
      strings = 'none',
      variables = 'none',
    },

    -- Lualine options --
    lualine = {
      transparent = false, -- lualine center bar transparency
    },

    -- Custom Highlights --
    colors = {}, -- Override default colors
    highlights = {}, -- Override highlight groups

    -- Plugins Config --
    diagnostics = {
      darker = true, -- darker colors for diagnostic
      undercurl = true, -- use undercurl instead of underline for diagnostics
      background = true, -- use background color for virtual text
    },
  }
  vim.cmd.colorscheme 'onedark'
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

function load_material()
  vim.g.material_style = 'darker' --  darker | lighter | oceanic | palenight | deep ocean
  require('material').setup {

    contrast = {
      terminal = true, -- Enable contrast for the built-in terminal
      sidebars = true, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
      floating_windows = true, -- Enable contrast for floating windows
      cursor_line = false, -- Enable darker background for the cursor line
      lsp_virtual_text = true, -- Enable contrasted background for lsp virtual text
      non_current_windows = false, -- Enable contrasted background for non-current windows
      filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
    },

    styles = { -- Give comments style such as bold, italic, underline etc.
      comments = { --[[ italic = true ]]
      },
      strings = { --[[ bold = true ]]
      },
      keywords = { --[[ underline = true ]]
      },
      functions = { --[[ bold = true, undercurl = true ]]
      },
      variables = {},
      operators = {},
      types = {},
    },

    plugins = { -- Uncomment the plugins that you use to highlight them
      -- Available plugins:
      -- "coc",
      -- "colorful-winsep",
      -- "dap",
      -- "dashboard",
      -- "eyeliner",
      -- "fidget",
      -- "flash",
      -- "gitsigns",
      -- "harpoon",
      -- "hop",
      -- "illuminate",
      -- "indent-blankline",
      -- "lspsaga",
      -- "mini",
      -- "neogit",
      -- "neotest",
      -- "neo-tree",
      -- "neorg",
      -- "noice",
      -- "nvim-cmp",
      -- "nvim-navic",
      -- "nvim-tree",
      -- "nvim-web-devicons",
      -- "rainbow-delimiters",
      -- "sneak",
      -- "telescope",
      -- "trouble",
      -- "which-key",
      -- "nvim-notify",
    },

    disable = {
      colored_cursor = false, -- Disable the colored cursor
      borders = false, -- Disable borders between vertically split windows
      background = false, -- Prevent the theme from setting the background (NeoVim then uses your terminal background)
      term_colors = false, -- Prevent the theme from setting terminal colors
      eob_lines = false, -- Hide the end-of-buffer lines
    },

    high_visibility = {
      lighter = false, -- Enable higher contrast text for lighter style
      darker = false, -- Enable higher contrast text for darker style
    },

    lualine_style = 'default', -- Lualine style ( can be 'stealth' or 'default' )

    async_loading = true, -- Load parts of the theme asynchronously for faster startup (turned on by default)

    custom_colors = nil, -- If you want to override the default colors, set this to a function

    custom_highlights = {}, -- Overwrite highlights with your own
  }
  vim.cmd 'colorscheme material'
end

--
return {
  {
    -- 'marko-cerovac/material.nvim',
    -- 'navarasu/onedark.nvim',
    -- 'scottmckendry/cyberdream.nvim',
    -- 'catppuccin/nvim',
    'rebelot/kanagawa.nvim',
    event = 'VimEnter',
    config = function()
      load_kanagawa()
      -- load_catppuccin()
      -- load_cyberdream()
      -- load_material()
      -- load_onedark()
      -- font : iosevka
    end,
  },
}
