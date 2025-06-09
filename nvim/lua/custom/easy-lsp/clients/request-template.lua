--- @class LspRequestTemplate
local M = {}

--- @alias vim.lsp.Context { bufnr: number, method: string }
--- @alias vim.lsp.Handler fun(err: any, result: any, ctx: vim.lsp.Context)

--- @param client vim.lsp.Client
--- @return function(bufnr: number, command: string, arguments: table, handler?: vim.lsp.Handler)
function M.execute_command(client)
  --- @param bufnr number Buffer number
  --- @param command string Command to execute
  --- @param arguments table Arguments for the command
  --- @param handler? vim.lsp.Handler Optional handler for the command response
  return function(bufnr, command, arguments, handler)
    local default_handler = function(err, result, ctx)
      if err then
        vim.notify('Error executing command: ' .. err.message, vim.log.levels.ERROR)
      end
    end

    --- @type vim.lsp.Handler
    local _handler = handler or default_handler

    client:request('workspace/executeCommand', {
      command = command,
      arguments = arguments,
    }, _handler, bufnr)
  end
end

return M
