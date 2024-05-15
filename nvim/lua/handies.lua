local htable = {}

htable.find = function(table, val)
  for k, v in pairs(table) do
    if v == val then
      return k
    end
  end
  return nil
end

htable.includes = function(table, val)
  return htable.find(table, val) ~= nil
end

return {
  htable = htable
}
