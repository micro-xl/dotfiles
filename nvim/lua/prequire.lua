local mod = {}

local original_require = require

mod.prequire = function(module_name)
  require('asserter').non_empty_string(module_name, 'module_name')

  local ok, mod = pcall(original_require, module_name)
  if not ok then
    vim.notify('RequireError: Fail to load ' .. module_name .. ':\n' .. mod, 'error')
    mod = nil
  end
  return mod;
end

mod.setup = function()
  require = mod.prequire
end

return mod
