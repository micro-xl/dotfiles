local get_current_file_path = require('utils.path').get_current_file_path

local mod = {}

-- formatter
local formatter_augroup = vim.api.nvim_create_augroup('Formatting', { clear = true })


local format_buffer = function(client, bufnr)
  vim.lsp.buf.format({
    bufnr = bufnr,
    filter = function(cli)
      return client.name == cli.name
    end
  })
end

mod.buf_set_format_on_save = {
  name = "buf_set_format_on_save",
  handle = function(client, bufnr)
    local formatting_command = 'textDocument/formatting'
    if not client.supports_method(formatting_command) then
      return false
    end
    -- if buffer don't has augroup named formatting
    vim.api.nvim_clear_autocmds({
      group = formatter_augroup,
      buffer = bufnr,
    })
    vim.api.nvim_create_user_command('FormatFile', function()
      format_buffer(client, bufnr)
    end, {})
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = formatter_augroup,
      buffer = bufnr,
      callback = function()
        local cur_file_path = get_current_file_path();
        if string.find(cur_file_path, 'dist') or
            string.find(cur_file_path, '.min', 1, true) or
            string.find(cur_file_path, 'node_modules') then
          return;
        end
        format_buffer(client, bufnr)
      end
    })
    return true;
  end
}


mod.keymap_to_common_language_service = {
  name = "keymap_to_common_language_service",
  handle = function(_, bufnr)
    assert(type(bufnr) == 'number', 'bufnr must be a number')
    local bufopts = { noremap = true, silent = false, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gh', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, bufopts)
    -- see plugins.telescope.lua 60 - 65 lines
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>qf', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>sh', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', 'g]', vim.diagnostic.goto_next, bufopts)
    vim.keymap.set('n', 'g[', vim.diagnostic.goto_prev, bufopts)
    return true
  end
}

mod.turn_off_syntax_highlighting_by_lsp = {
  name = "turn_off_syntax_highlighting_by_lsp",
  handle = function(client, bufnr)
    client.server_capabilities.semanticTokensProvider = nil
    return true
  end
}

mod.notify_attached = {
  name = "notify_attached",
  handle = function(client, bufnr)
    vim.notify('[' .. client.name .. ']: Client attached to buf[' .. bufnr .. ']')
    return true
  end
}

return mod;
