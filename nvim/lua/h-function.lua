local mod = {}

mod.pipe = function(...)
  -- lua5.2 부터는 table.pack 사용하면 되지만, neovim이 사용하는 LuaJit은 5.1이라서 사용할 수 없다.
  local fns = { ... }
  fns.n = select('#', ...)

  return function(arg)
    local result = arg
    for i = 1, fns.n do
      result = fns[i](result)
    end
    return result
  end
end

mod.tap = function(fn)
  return function(arg)
    fn(arg)
    return arg
  end
end


return mod;
