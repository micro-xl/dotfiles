-- Formatting

-- Autoformat
return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  opts = {
    notify_on_error = true,
    format_on_save = function(bufnr)
      -- Disable "format_on_save lsp_fallback" for languages that don't
      -- have a well standardized coding style. You can add additional
      -- languages here or re-enable it for the disabled ones.
      local disable_filetypes = { c = true, cpp = true }
      return {
        timeout_ms = 500,
        lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
      }
    end,
    formatters = {
      jq_formatter = {
        command = 'jq',
        stdin = true,
      },
    },
    formatters_by_ft = {
      lua = { 'stylua' },
      -- python = { "isort", "black" },
      javascript = { 'prettier' },
      typescript = { 'prettier' },
      javascriptreact = { 'prettier' },
      typescriptreact = { 'prettier' },
      -- json = { 'prettier' },
      json = { 'jq_formatter' },
    },
  },
}
