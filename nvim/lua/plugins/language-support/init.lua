local cfg_path = vim.fn.stdpath 'config'

return {
  {
    dir = cfg_path .. '/lua/custom/easy-lsp',
    name = 'easy-lsp',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'folke/neodev.nvim',
      'mason-org/mason.nvim',
      'mason-org/mason-lspconfig.nvim',
      'ibhagwan/fzf-lua',
    },
    config = function()
      vim.lsp.set_log_level(vim.log.levels.TRACE)
      --- Map mason package names to vim lsp sever names
      require('custom.easy-lsp').setup {
        use_nvim_cmp_capabilities = true,
        use_mason = true
      }
    end,
  },
  {
    'mason-org/mason.nvim', -- Package manager for Neovim LSP, DAP, linters, formatters (other external tools)
    opts = {
      ensure_installed = {
        --- Formatters
        -- 'stylua',
        -- 'shfmt',

        --- LSP servers
        'typescript-language-server',
        'lua-language-server',
        -- 'dockerfile-language-server',
        -- 'pyright',
      },
      ui = {
        border = 'rounded',
      },
    },
    config = function(_, opts)
      require('mason').setup(opts)

      local ensure_installed = opts.ensure_installed or {}
      local registry = require 'mason-registry'

      vim.iter(ensure_installed):each(function(pkg_name)
        if not registry.is_installed(pkg_name) then
          local pkg = registry.get_package(pkg_name)
          if pkg then
            vim.notify('Mason: Installing package ' .. pkg_name .. '...', vim.log.levels.INFO)
            pkg:install()
          else
            vim.notify('Mason: Package ' .. pkg_name .. ' not found in registry.', vim.log.levels.ERROR)
          end
        end
      end)
    end,
  },
}
