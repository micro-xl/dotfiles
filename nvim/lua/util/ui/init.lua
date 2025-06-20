--- @class UiUtil
local M = {}

local virtual_text = require('util.ui.virtual_text')

--- Creates a virtual text instance with the given namespace
--- @param namespace number The namespace to use for virtual text
--- @return VirtualText
function M.virtual_text(namespace)
  return virtual_text.create(namespace)
end

return M
