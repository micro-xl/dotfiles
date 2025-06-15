--- @class EasyLsp
local M = {}

--- @class EasyLspOpts
--- @field use_nvim_cmp_capabilities boolean
--- @field use_mason boolean

--- @param opts EasyLspOpts
function M.setup(opts)
  if opts.use_nvim_cmp_capabilities then
    vim.lsp.config('*', {
      capabilities = require('cmp_nvim_lsp').default_capabilities(),
      on_attach = function(client, bufnr)
        require('custom.easy-lsp.keymap').setup(client, bufnr)
      end,
    })
  end

  if not opts.use_mason then
    vim.notify(
      'LSP: my lsp plugin do not yet support the case where use_mason is false, as this assumes that you install language-server using mason.',
      vim.log.levels.WARN
    )
    return
  end

  require('custom.easy-lsp.command').setup()

  --- @type table<string, string>
  local pkg_to_server = require('mason-lspconfig').get_mappings()
      .package_to_lspconfig -- Use mason-lspconfig for data mapping only. not need other mason-lspconfig features.
  local installed_mason_package = require('mason-registry').get_installed_package_names()

  vim
      .iter(installed_mason_package)
      :filter(function(pkg)
        return pkg_to_server[pkg] ~= nil
      end)
      :map(function(pkg)
        local server_name = pkg_to_server[pkg]
        local ok, err = pcall(require, 'custom.easy-lsp.' .. server_name)
        if not ok then
          vim.notify(
            'LSP: Failed to load configuration for ' ..
            server_name ..
            '. Write config file in custom/easy-lsp/' .. server_name .. '.lua (or ' .. server_name .. '/init.lua)',
            vim.log.levels.WARN
          )
          return nil
        end
        vim.lsp.config(server_name, require('custom.easy-lsp.' .. server_name))
        vim.lsp.enable(server_name)
      end)
end

return M
