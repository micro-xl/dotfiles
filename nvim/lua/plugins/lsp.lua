local h_path = require 'lib.h-path'
local h_lsp = require 'lib.h-lsp'
--[[ LspConfiguration ]]

return {
  { -- Collections of Configuration for LSP
    'neovim/nvim-lspconfig',
    event = { 'VimEnter' }, -- TODO: filetype으로 lazy loading 하려고 해도 config가 자꾸 안되는 이슈가있다
    dependencies = {
      { -- Manageing the external tools (LSP, DAP, Linter & Foramtter) for Cross-Flatform
        'williamboman/mason.nvim',
        config = true,
      },
      {
        'williamboman/mason-lspconfig.nvim',
      },
      'WhoIsSethDaniel/mason-tool-installer.nvim',
      { -- Configures Lua Lsp for Neovim config, including lua-language-server (completion, annotations and signature of Neovim api)
        'folke/neodev.nvim',
        config = true,
      },
    },
    config = function()
      -- and elegantly composed help section, `:help lsp-vs-treesitter`
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          local builtin = require 'telescope.builtin'
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})
          vim.keymap.set('n', 'gh', vim.lsp.buf.hover, {})
          vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, {})
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {})
          vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, {})
          vim.keymap.set('n', 'gr', builtin.lsp_references, {})
          vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, {})
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
          vim.keymap.set('n', 'gr', builtin.lsp_references, {})
          vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, {})
          vim.keymap.set('n', 'gd', builtin.lsp_definitions, {})
          vim.keymap.set('n', 'gi', builtin.lsp_implementations, {})
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.server_capabilities.documentHighlightProvider then
            local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          -- The following autocommand is used to enable inlay hints in your
          -- code, if the language server you are using supports them
          -- This may be unwanted, since they displace some of your code
          if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled {})
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), require('cmp_nvim_lsp').default_capabilities())

      -- Enable the following language servers
      --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
      --
      --  Add any additional override configuration in the following tables. Available keys are:
      --  - cmd (table): Override the default command used to start the server
      --  - filetypes (table): Override the default list of associated filetypes for the server
      --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
      --  - settings (table): Override the default settings passed when initializing the server.
      --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
      local servers = {
        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              diagnostics = {
                globals = { 'LOG' },
              },
              completion = {
                callSnippet = 'Replace',
              },
            },
          },
        },
        tsserver = {
          on_attach = function(client, bufnr)
            vim.api.nvim_create_user_command('TsOrganizeImport', function()
              h_lsp.ts.organize_import(bufnr, h_path.get_current_file_path())
            end, {})
          end,
          root_dir = require('lspconfig').util.root_pattern('package.json', 'tsconfig.json', 'jsconfig.json', '.git'),
          init_options = {
            preferences = {
              quotePreference = 'single',
              includeCompletionsForModuleExports = true,
              includeCompletionsForImportStatements = true,
              includeCompletionsWithSnippetText = true,
              includeAutomaticOptionalChainCompletions = true,
              includeCompletionsWithClassMemberSnippets = true,
              includeCompletionsWithInsertText = true,
              importModuleSpecifierPreference = 'auto', -- 'auto' | 'relative',
              importModuleSpecifierEnding = 'minimal',
              provideRefactorNotApplicableReason = true,
              allowRenameOfImportPath = true,
              allowTextChangesInNewFiles = true,
              displayPartsForJSDoc = true,
              generateReturnInDocTemplate = true,
            },
          },
        },
        rust_analyzer = {
          cmd = { vim.env.HOME .. '/.cargo/bin/rust-analyzer' },
          settings = {
            diagnostics = {
              enable = false,
            },
          },
        },
      }

      require('mason').setup {
        ui = {
          border = 'rounded',
        },
      }

      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }
      require('mason-lspconfig').setup {
        automatic_installation = true,
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})

            -- server.handlers = {
            --   ['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = 'rounded' }),
            --   ['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = 'rounded' }),
            -- }
            require('lspconfig')[server_name].setup(server)
          end,
        },
      }
      LOG '[LOADED] lsp'
    end,
  },
}
