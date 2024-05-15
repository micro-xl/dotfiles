local module = {}

module.getCurrentWindowSizes = function()
  return {
    width = vim.api.nvim_win_get_width(0),
    height = vim.api.nvim_win_get_height(0)
  }
end

module.getCurrentWindowRatio = function()
  local unitWidth = 104;
  local unitHeight = 34;
  local windowSize = module.getCurrentWindowSizes()

  return {
    width = windowSize.width / unitWidth,
    height = windowSize.height / unitHeight
  }
end


return module
