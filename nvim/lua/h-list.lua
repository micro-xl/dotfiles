local mod = {}

mod.map = function(table, callback)
  local new_table = {}
  for k, v in pairs(table) do
    new_table[k] = callback(v, k)
  end
  return new_table
end

mod.reduce = function(table, callback, initial_value)
  local acc = initial_value
  for k, v in pairs(table) do
    acc = callback(acc, v, k)
  end
  return acc
end

mod.filter = function(_table, predicate)
  return mod.reduce(_table, function(acc, v, k)
    if predicate(v, k) then
      table.insert(acc, v)
    end
    return acc
  end, {})
end

mod.find = function(table, predicate)
  for k, v in pairs(table) do
    if predicate(v, k) then
      return v
    end
  end
  return nil
end

mod.find_not = function(table, predicate)
  return mod.find(table, function(v, k)
    return not predicate(v, k)
  end)
end

mod.find_max = function(table)
  return mod.reduce(table, function(acc, v, _)
    if v > acc then
      return v
    else
      return acc
    end
  end, 0)
end

mod.find_min = function(table)
  return mod.reduce(table, function(acc, v, _)
    if v < acc then
      return v
    else
      return acc
    end
  end, 0)
end

mod.key_of = function(_table)
  return mod.reduce(_table, function(acc, _, k)
    table.insert(acc, k)
    return acc
  end, {})
end

mod.value_of = function(_table)
  return mod.reduce(_table, function(acc, v, _)
    table.insert(acc, v)
    return acc
  end, {})
end

mod.concat = function(table_a, table_b)
  local result = {}
  mod.map(table_a, function(v) table.insert(result, v) end)
  mod.map(table_b, function(v) table.insert(result, v) end)
  return result;
end

mod.slice = function(_table, start, finish)
  if finish == nil then
    finish = #_table
  end
  return mod.reduce(_table, function(acc, v, i)
    if i >= start and i <= finish then
      table.insert(acc, v)
    end
    return acc
  end, {})
end

mod.include = function(table_a, value)
  return mod.find(table_a, function(v) return v == value end) ~= nil
end

mod.join = function(table_a, separator)
  return mod.reduce(table_a, function(acc, v, i)
    if (i == 1) then
      return v
    end
    return acc .. separator .. v
  end, '')
end

return mod;
