local mod = {}

mod.getCurrentWindowSizes = function()
  return {
    width = vim.api.nvim_win_get_width(0),
    height = vim.api.nvim_win_get_height(0),
  }
end

mod.getCurrentWindowRatio = function()
  local unitWidth = 104
  local unitHeight = 34
  local windowSize = mod.getCurrentWindowSizes()

  return {
    width = windowSize.width / unitWidth,
    height = windowSize.height / unitHeight,
  }
end

return mod
