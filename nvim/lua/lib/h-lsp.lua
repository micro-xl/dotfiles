local mod = {}

local function request_exec_command(buf_no, command, arguments)
  vim.lsp.buf_request(buf_no, 'workspace/executeCommand', {
    command = command,
    arguments = arguments,
  })
end

mod.ts = {}

mod.ts.rename_file = function(buf_no, old_file_path, new_file_path)
  if new_file_path == nil or new_file_path == '' or old_file_path == new_file_path then
    return
  end
  request_exec_command(buf_no, '_typescript.applyRenameFile', {
    {
      sourceUri = old_file_path,
      targetUri = new_file_path,
    },
  })
end

mod.ts.organize_import = function(buf_no, filename)
  request_exec_command(buf_no, '_typescript.organizeImports', { filename })
end

mod.ts.select_refactor = function(buf_no, file_path, start_pos, end_pos)
  request_exec_command(buf_no, '_typescript.selectRefactoring', {
    {
      file = file_path,
      startLine = start_pos[1],
      startOffset = start_pos[2],
      endLine = end_pos[1],
      endOffset = end_pos[2],
    },
  })
end

return mod
