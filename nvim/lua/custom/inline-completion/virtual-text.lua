local M = {}

local namespace = vim.api.nvim_create_namespace('inline_completion')

function M.show(bufnr, row, col, text)
  M.clear(bufnr)
  
  if not text or text == '' then
    return
  end
  
  local lines = vim.split(text, '\n')
  local current_line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
  
  if #lines == 1 then
    -- Single line completion
    local virt_text = { { lines[1], 'Comment' } }
    vim.api.nvim_buf_set_extmark(bufnr, namespace, row, col, {
      virt_text = virt_text,
      virt_text_pos = 'inline',
    })
  else
    -- Multi-line completion
    -- First line (inline with current line)
    local virt_text = { { lines[1], 'Comment' } }
    vim.api.nvim_buf_set_extmark(bufnr, namespace, row, col, {
      virt_text = virt_text,
      virt_text_pos = 'inline',
    })
    
    -- Subsequent lines (as virtual lines)
    for i = 2, #lines do
      vim.api.nvim_buf_set_extmark(bufnr, namespace, row, 0, {
        virt_lines = { { { lines[i], 'Comment' } } },
        virt_lines_above = false,
      })
    end
  end
end

function M.clear(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
end

return M
