local exports = {}

exports.open_zsh = function()
  vim.cmd('e ~/.zshrc')
end

exports.setup = function(options)
  local open_zsh = options.path
      and function() vim.cmd('e ' .. options.path) end
      or exports.open_zsh
  vim.api.nvim_create_user_command('ZshrcEdit', function() open_zsh() end, {});
end

return exports;
