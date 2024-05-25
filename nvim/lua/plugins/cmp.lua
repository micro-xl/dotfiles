--[[ Autocompletion ]]

return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets.
          -- This step is not supported in many windows environments.
          -- Remove the below condition to re-enable on windows.
          if vim.fn.has 'win32' == 1 or vim.fn.executable 'make' == 0 then
            return
          end
          return 'make install_jsregexp'
        end)(),
        dependencies = {
          {
            'rafamadriz/friendly-snippets',
            config = function()
              require('luasnip.loaders.from_vscode').lazy_load()
            end,
          },
        },
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds other completion capabilities.
      --  nvim-cmp does not ship with all sources by default. They are split
      --  into multiple repos for maintenance purposes.
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
    config = function()
      local function use_kind_filter(filter)
        return function(entry, _)
          local kind = require('cmp.types').lsp.CompletionItemKind[entry:get_kind()]
          return filter(kind)
        end
      end
      local cmp = require 'cmp'
      local luasnip = require 'luasnip'
      luasnip.config.setup {}

      cmp.setup {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        completion = { completeopt = 'menu,menuone,noinsert' },
        mapping = cmp.mapping.preset.insert {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-n>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm { select = true },
        },
        sources = {
          {
            name = 'nvim_lsp',
            entry_filter = use_kind_filter(function(kind)
              return kind ~= 'Text' and kind ~= 'Snippet'
            end),
          },
          { name = 'luasnip' },
          { name = 'path' },
        },
        format = function(entry, vim_item)
          vim_item.kind = ({
            Text = '',
            Method = '',
            Function = '󰊕',
            Constructor = '',
            Field = '',
            Variable = '󰫧',
            Class = 'C',
            Interface = 'I',
            Module = '',
            Property = '',
            Unit = '',
            Value = '',
            Enum = '',
            Keyword = '󱀍',
            Snippet = '',
            Color = '',
            File = '',
            Folder = '',
            EnumMember = '',
            Constant = '󱀍',
            Struct = '󰅩',
            Event = '',
            Operator = '',
          })[vim_item.kind] or vim_item.kind

          local source = entry.source.name
          vim_item.menu = ({
            nvim_lsp = '[LSP]',
            nvim_lua = '[vim]',
            luasnip = '[LuaSnip]',
            fuzzy_path = '[Path]',
            fuzzy_buffer = '[Buf]',
            cmdline = '[Cmd]',
            buffer = '[Buf]',
            path = '[Path]',
            spell = '[Spell]',
          })[source] or source
          if source == 'luasnip' or source == 'nvim_lsp' then
            vim_item.dup = 0
          end
          return vim_item
        end,
        sorting = {
          priority_weight = 1,
          comparators = {
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.kind,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
          },
        },
      }
    end,
  },
}
