--- @class EasyLspKeymaps
local M = {}

--- @param client vim.lsp.Client
--- @param bufnr number
function M.setup(client, bufnr)
  local opts = { noremap = true, buffer = bufnr }


  vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, opts)
  vim.keymap.set('n', 'gr', require('fzf-lua').lsp_references, opts)
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, opts)
  vim.keymap.set('n', 'gh', vim.lsp.buf.hover, opts)
end

return M
