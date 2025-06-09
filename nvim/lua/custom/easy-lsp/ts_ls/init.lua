-- local ts_client = require('custom.easy-lsp.clients.ts_ls')
return {
  cmd = {
    'typescript-language-server',
    '--stdio',
  },
  --- @param client vim.lsp.Client
  --- @param bufnr number
  on_attach = function(client, bufnr)
    require('custom.easy-lsp.ts_ls.command').setup(client, bufnr)
  end,
  filetypes = {
    'typescript',
    'typescriptreact',
    'typescript.tsx',
    'javascript',
    'javascriptreact',
    'javascript.jsx',
  },
  init_options = {
    hostInfo = 'neovim',
    preferences = {
      quotePreference = 'single',
      includeCompletionsForModuleExports = true,
      includeCompletionsForImportStatements = true,
      includeCompletionsWithSnippetText = true,
      includeAutomaticOptionalChainCompletions = true,
      includeCompletionsWithClassMemberSnippets = true,
      includeCompletionsWithInsertText = true,
      importModuleSpecifierPreference = 'relative', -- 'auto' | 'relative',
      importModuleSpecifierEnding = 'minimal',
      provideRefactorNotApplicableReason = true,
      allowRenameOfImportPath = true,
      allowTextChangesInNewFiles = true,
      displayPartsForJSDoc = true,
      generateReturnInDocTemplate = true,
    },
  },
  root_markers = {
    { 'pnpm-lock.yaml', 'yarn.lock', 'package-lock.json' },
    {
      'package.json',
      'tsconfig.json',
      'jsconfig.json',
    },
    '.git',
  },
}
