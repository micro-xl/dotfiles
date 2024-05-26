--[[ Dressing provides the advanced ui for vim.input and vim.ui.select ]]

return {
  'stevearc/dressing.nvim',
  event = 'VeryLazy',
  config = function()
    require('dressing').setup {
      input = {
        border = 'rounded',
      },
      select = {
        border = 'rounded',
      },
    }
    LOG '[LOADED] dressing'
  end,
}
