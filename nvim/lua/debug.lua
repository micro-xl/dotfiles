local mod = {}

mod.log = function(something)
  vim.cmd('echo ' .. vim.inspect(something))
end

return mod
