--- @class EasyLspKeymaps
local M = {}

--- @param client vim.lsp.Client
--- @param bufnr number
function M.setup(client, bufnr)
  print('Setting up keymaps for LSP client: ' .. client.name)
  local opts = { noremap = true, buffer = bufnr }

  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
end

return M
