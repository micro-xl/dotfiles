local htable = require('handies').htable
local mod = {}

-- @params {table} opts
-- @params {table} opts.ignore_buftypes
-- @params {table} opts.ignore_filetypes
mod.setup = function(opts)
  local ignore_buftypes = opts.ignore_buftypes ~= nil
      and opts.ignore_buftypes
      or {}
  local ignore_filetypes = opts.ignore_filetypes ~= nil
      and opts.ignore_filetypes
      or {}
  local should_ignore = function(buf_type, file_type)
    return htable.includes(ignore_filetypes, file_type) or htable.includes(ignore_buftypes, buf_type)
  end
  if opts.fold_save == true then
    vim.api.nvim_create_augroup("remember_folds", {})
    vim.api.nvim_create_autocmd(
      "BufWinLeave",
      {
        group = "remember_folds",
        callback = function()
          if should_ignore(
                vim.api.nvim_buf_get_option(0, 'buftype'),
                vim.api.nvim_buf_get_option(0, 'filetype')
              ) then
            return
          end
          vim.cmd("mkview")
        end
      }
    )
    vim.api.nvim_create_autocmd(
      "BufWinEnter",
      {
        group = "remember_folds",
        callback = function()
          if should_ignore(
                vim.api.nvim_buf_get_option(0, 'buftype'),
                vim.api.nvim_buf_get_option(0, 'filetype')
              ) then
            return
          end
          vim.cmd("loadview", { silent = true })
        end
      }
    )
  end
end

return mod
