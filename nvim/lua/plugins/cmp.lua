--[[ Autocompletion ]]

return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      { -- Snippet Engine & its associated nvim-cmp source
        'L3MON4D3/LuaSnip',
        ft = { 'lua', 'typescript', 'javascript' },
        build = (function()
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
      do
        local snp = luasnip.snippet
        local ins = luasnip.insert_node
        local fmt = require('luasnip.extras.fmt').fmt
        local text = luasnip.text_node
        luasnip.config.setup {}
        luasnip.add_snippets('javascript', {
          snp('ylog', {
            text 'function yellowLog(...args) {',
            text { '', '  const log = args.reduce((acc, cur, i) => {' },
            text { '', "    const space = i > 0 ? ' ' : '';" },
            text { '', "    if (typeof cur === 'string') return acc + space + cur;" },
            text { '', "    if (cur === null) return acc + space + 'null';" },
            text { '', "    if (cur === undefined) return acc + space + 'undefined';" },
            text { '', "    if (Number.isNaN(cur)) return acc + space + 'NaN';" },
            text { '', '    return acc + space + JSON.stringify(cur, null, 2);' },
            text { '', "  }, '');" },
            text { '', "  console.log('\\x1b[30m\\x1b[43m%s\\x1b[0m', log);" },
            text { '', '}' },
          }),
        })
        luasnip.add_snippets('typescript', {
          snp(
            'desc',
            fmt(
              [[
      describe('{1}', () => {{
        it('{2}', () => {{
          {3}
        }})
      }})
]],
              {
                ins(1, '/* test name */'),
                ins(2, '/* specification */'),
                ins(3, '// test code'),
              }
            )
          ),
          snp('ylog', {
            text 'function yellowLog(...args: any[]) {',
            text { '', '  const log = args.reduce((acc, cur, i) => {' },
            text { '', "    const space = i > 0 ? ' ' : '';" },
            text { '', "    if (typeof cur === 'string') return acc + space + cur;" },
            text { '', "    if (cur === null) return acc + space + 'null';" },
            text { '', "    if (cur === undefined) return acc + space + 'undefined';" },
            text { '', "    if (Number.isNaN(cur)) return acc + space + 'NaN';" },
            text { '', '    return acc + space + JSON.stringify(cur, null, 2);' },
            text { '', "  }, '');" },
            text { '', "  console.log('\\x1b[30m\\x1b[43m%s\\x1b[0m', log);" },
            text { '', '}' },
          }),
          snp(
            'pbcopy',
            fmt(
              [[
      function pbcopy(data: {1}) {{
        const proc = require('child_process').spawn('pbcopy');
        proc.stdin.write(data);
        proc.stdin.end();
      }}
    ]],
              {
                ins(1, 'any'),
              }
            )
          ),
        })

        vim.cmd "imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'"
        vim.keymap.set('i', '<S-Tab>', function()
          luasnip.jump(-1)
        end, { silent = true })
        vim.keymap.set('s', '<Tab>', function()
          luasnip.jump(1)
        end, { silent = true })
        vim.keymap.set('s', '<S-Tab>', function()
          luasnip.jump(-1)
        end, { silent = true })
      end

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
          ['<C-y>'] = nil,
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
      cmp.setup.filetype({ 'oil' }, { enabled = false })
    end,
  },
}
