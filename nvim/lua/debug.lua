local mod = {}

mod.LOG = function(something)
  vim.notify('LOG :' .. vim.inspect(something))
end

return mod
