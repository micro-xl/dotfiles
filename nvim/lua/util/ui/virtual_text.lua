--- @class VirtualText
--- @field show function
--- @field clear function

local M = {}

--- Creates a virtual text instance with the given namespace
--- @param namespace number The namespace to use for virtual text
--- @return VirtualText
function M.create(namespace)
  local vt = {}

  function vt.show(bufnr, row, col, text)
    vt.clear(bufnr)

    if not text or text == '' then
      return
    end

    local lines = vim.split(text, '\n')

    if #lines == 1 then
      local virt_text = { { lines[1], 'Comment' } }
      vim.api.nvim_buf_set_extmark(bufnr, namespace, row, col, {
        virt_text = virt_text,
        virt_text_pos = 'inline',
      })
    else
      local virt_text = { { lines[1], 'Comment' } }
      vim.api.nvim_buf_set_extmark(bufnr, namespace, row, col, {
        virt_text = virt_text,
        virt_text_pos = 'inline',
      })

      for i = 2, #lines do
        vim.api.nvim_buf_set_extmark(bufnr, namespace, row, 0, {
          virt_lines = { { { lines[i], 'Comment' } } },
          virt_lines_above = false,
        })
      end
    end
  end

  function vt.clear(bufnr)
    vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
  end

  return vt
end

return M
