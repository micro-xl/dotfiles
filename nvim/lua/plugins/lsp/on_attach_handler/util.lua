local filetype_of = require('utils.buffer').filetype_of
local map = require('utils.list').map

local use_handlers_with_filetype = function(filetype_handlers_mapping)
  return function(client, bufnr)
    local attached_handler_filetype = 'none'
    map(
      filetype_handlers_mapping, function(handlers, filetype)
        if filetype_of(bufnr) == filetype then
          local handlers_info = map(handlers, function(handler)
            return {
              name = handler.name,
              enabled = handler.handle(client, bufnr)
            }
          end)

          if DEBUG.lsp_attached_handler then
            vim.notify('[' .. client.name .. '] '
              .. 'Activates '
              .. vim.inspect(handlers_info)
            )
          end
        end
      end
    )
  end
end

return {
  use_handlers_with_filetype = use_handlers_with_filetype
}
