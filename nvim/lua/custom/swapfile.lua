local mod = {}

mod.clear_swap_files = function()
  local result = vim.fn.system('/bin/rm ~/.local/state/nvim/swap/*')
  vim.notify(result);
end

mod.setup = function(opts)
  vim.api.nvim_create_user_command('SwapFileClear', mod.clear_swap_files, {});
end

return mod
