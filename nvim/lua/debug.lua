local mod = {}

mod.Log = function(something)
  vim.cmd('echo ' .. vim.inspect(something))
end

return mod
