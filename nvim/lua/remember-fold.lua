local mod = {}

-- @params {table} opts
-- @params {boolean} opts.enabled
mod.setup = function(opts)
  if opts.enabled == true then
    vim.api.nvim_create_augroup("remember_folds", {})
    vim.api.nvim_create_autocmd(
      "BufWinLeave",
      {
        group = "remember_folds",
        callback = function()
          pcall(function()
            vim.cmd("mkview")
          end)
        end
      }
    )
    vim.api.nvim_create_autocmd(
      "BufWinEnter",
      {
        group = "remember_folds",
        callback = function()
          pcall(function()
            vim.cmd("loadview", { silent = true })
          end)
        end
      }
    )
  end
end

return mod
