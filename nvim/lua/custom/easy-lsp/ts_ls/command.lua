--- @class TypescriptLspCommand
local M = {}


--- @param client vim.lsp.Client
--- @param bufnr number
M.setup = function(client, bufnr)
  vim.api.nvim_create_user_command('EasyLspOrganizeImport', function()
    --- @type lsp.Command
    local context = {
      title     = 'Organize Imports',
      command   = "_typescript.organizeImports",
      arguments = { vim.api.nvim_buf_get_name(bufnr) },
    }
    client:exec_cmd(context)
  end, { desc = 'LSP: Organize Imports' })

  vim.api.nvim_create_user_command('EasyLspRenameFile', function()
    --- @type lsp.Command
    local context = {
      title     = 'Rename File',
      command   = "_typescript.renameFile",
      arguments = { vim.api.nvim_buf_get_name(bufnr) },
    }
    client:exec_cmd(context)
  end, { desc = 'LSP: Rename File' })
end

return M
