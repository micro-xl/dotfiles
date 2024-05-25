local mod = {}

-- @param {boolean|function} condition - condition to check
-- @param {string} message - message to display if condition is false
mod.assert = function(condition, message)
  if type(condition) == 'function' then
    return {
      with = function(...)
        if not condition(...) then
          error(message or 'Assertion failed')
        end
      end
    }
  end
  if not condition then
    error(message or 'Assertion failed')
  end
end


-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.not_nil = function(value, var_name)
  mod.assert(value ~= nil, var_name .. ' is nil')
end


-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.string = function(value, var_name)
  mod.assert(type(value) == 'string', var_name .. ' is not a string')
end

mod.non_empty_string = function(value, var_name)
  mod.string(value, var_name)
  mod.assert(#value > 0, var_name .. ' is an empty string')
end

-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.number = function(value, var_name)
  mod.assert(type(value) == 'number', var_name .. ' is not a number')
end

-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.boolean = function(value, var_name)
  mod.assert(type(value) == 'boolean', var_name .. ' is not a boolean')
end

-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.table = function(value, var_name)
  mod.assert(type(value) == 'table', var_name .. ' is not a table')
end

-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.func = function(value, var_name)
  mod.assert(type(value) == 'function', var_name .. ' is not a function')
end

-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.positive_number = function(value, var_name)
  mod.number(value, var_name)
  mod.assert(value > 0, var_name .. ' is not a positive number')
end

-- @param {any} value - value to check
-- @param {string} var_name - name of the variable
mod.natural_number = function(value, var_name)
  mod.number(value, var_name)
  mod.assert(value >= 0, var_name .. ' is not a natural number')
end

return mod;
