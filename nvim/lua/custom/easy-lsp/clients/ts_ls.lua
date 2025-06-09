local request = require("custom.easy-lsp.clients.request-template")

--- @class EasyLspClient_ts_ls
local M = {}

--- @param client vim.lsp.Client
--- @return EasyLspReqeustTemplate_ts_ls
function M.LspRequest(client)
  local lsp_exec = request.execute_command(client)

  --- @class EasyLspReqeustTemplate_ts_ls
  local obj = {}

  --- @param bufnr number Buffer number
  function obj.rename_file(bufnr, old_file_path, new_file_path)
    if new_file_path == nil or new_file_path == '' or old_file_path == new_file_path then
      return
    end
    lsp_exec(bufnr, '_typescript.applyRenameFile', {
      {
        sourceUri = old_file_path,
        targetUri = new_file_path,
      },
    })
  end

  --- @param bufnr number Buffer number
  --- @param document_uri string File URI of the document to organize imports
  function obj.organize_import(bufnr, document_uri)
    lsp_exec(bufnr, '_typescript.organizeImports', { document_uri },
      function(err, result, ctx)
        vim.print(vim.inspect(
          { err = err, result = result, ctx = ctx }
        ))
      end
    )
  end

  --- @param bufnr number Buffer number
  --- @param file_path string File path for the refactoring
  --- @param start_pos table Start position as {line, offset}
  --- @param end_pos table End position as {line, offset}
  function obj.select_refactor(bufnr, file_path, start_pos, end_pos)
    lsp_exec(bufnr, '_typescript.selectRefactoring', {
      {
        file = file_path,
        startLine = start_pos[1],
        startOffset = start_pos[2],
        endLine = end_pos[1],
        endOffset = end_pos[2],
      },
    })
  end

  return obj
end

return M
