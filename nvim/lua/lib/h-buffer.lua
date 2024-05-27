local mod = {}

mod.get_visual_selection = function()
  vim.api.nvim_exec('normal! "vy', false)
  return vim.fn.getreg 'v'
end

return mod
