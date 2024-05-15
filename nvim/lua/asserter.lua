local mod = {}

-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.not_nil = function(value, var_name)
  if value == nil then
    error('Expected ' .. var_name .. ' to not be nil')
  end
end

return mod
