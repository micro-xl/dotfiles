--- @class Cursor
local M = {}

---
--- Returns the entire buffer text split into two parts: before and after the cursor position.
--- The first value is the text before the cursor (including the character under the cursor),
--- and the second value is the text after the cursor.
--- @return { before: string, after: string}
function M.split_text_at_cursor()
  local bufnr = vim.api.nvim_get_current_buf()
  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]

  -- 버퍼 전체 텍스트를 한 줄로 합침
  local all_text = table.concat(lines, "\n")

  -- 커서 위치까지의 바이트 오프셋 계산
  local byte_offset = 0
  for i = 1, row - 1 do
    byte_offset = byte_offset + #lines[i] + 1 -- 줄바꿈(\n)
  end
  byte_offset = byte_offset + col

  local before = all_text:sub(1, byte_offset)
  local after = all_text:sub(byte_offset + 1)

  return { before, after }
end

--- add method to get current cursor position row col AI!

return M
