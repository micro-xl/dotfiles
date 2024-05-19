local asserter = require('asserter')
local htable = {}

htable.find = function(t, val)
  asserter.table(t, 'table')
  for k, v in pairs(t) do
    if v == val then
      return k
    end
  end
  return nil
end

htable.includes = function(t, val)
  asserter.table(t, 'table')

  return htable.find(t, val) ~= nil
end

return {
  htable = htable
}
