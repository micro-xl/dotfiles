local map = function(table, callback)
  local new_table = {}
  for k, v in pairs(table) do
    new_table[k] = callback(v, k)
  end
  return new_table
end

local reduce = function(table, callback, initial_value)
  local acc = initial_value
  for k, v in pairs(table) do
    acc = callback(acc, v, k)
  end
  return acc
end

local filter = function(table, predicate)
  local new_table = {}
  for k, v in pairs(table) do
    if predicate(v, k) then
      new_table[k] = v
    end
  end
  return new_table
end

local find = function(table, predicate)
  for k, v in pairs(table) do
    if predicate(v, k) then
      return v
    end
  end
  return nil
end

local find_not = function(table, predicate)
  return find(table, function(v, k)
    return not predicate(v, k)
  end)
end

local find_max = function(table)
  return reduce(table, function(acc, v, _)
    if v > acc then
      return v
    else
      return acc
    end
  end, 0)
end

local find_min = function(table)
  return reduce(table, function(acc, v, _)
    if v < acc then
      return v
    else
      return acc
    end
  end, 0)
end

local key_of = function(_table)
  return reduce(_table, function(acc, _, k)
    table.insert(acc, k)
    return acc
  end, {})
end

local value_of = function(_table)
  return reduce(_table, function(acc, v, _)
    table.insert(acc, v)
    return acc
  end, {})
end

local concat = function(table_a, table_b)
  local result = {}
  map(table_a, function(v) table.insert(result, v) end)
  map(table_b, function(v) table.insert(result, v) end)
  return result;
end

local include = function(table_a, value)
  return find(table_a, function(v) return v == value end) ~= nil
end

local join = function(table_a, separator)
  return reduce(table_a, function(acc, v, i)
    if (i == 1) then
      return v
    end
    return acc .. separator .. v
  end, '')
end


return {
  map = map,
  reduce = reduce,
  filter = filter,
  find = find,
  find_not = find_not,
  find_max = find_max,
  find_min = find_min,
  key_of = key_of,
  value_of = value_of,
  concat = concat,
  include = include,
  join = join
}
