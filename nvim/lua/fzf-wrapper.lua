local fzf = require('fzf')
local mod = {}

-- @param callback {function} callback
-- function.args.1 {table} -- sources
-- function.args.2 {table} -- spec of fzf
-- function.returns {table} -- picked items
mod.with_fzf_on_cur_win = function(callback)
  coroutine.wrap(function()
    callback(fzf.provided_win_fzf)
  end)()
end

mod.with_fzf = function(callback)
  coroutine.wrap(function()
    callback(fzf.fzf)
  end)()
end

return mod;
