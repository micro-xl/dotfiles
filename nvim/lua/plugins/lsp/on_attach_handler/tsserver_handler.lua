local tsserver_request = require('plugins.lsp.request.tsserver_request')
local util = require('utils.path');

local function setting_for_tsserver_language_service(_, bufnr)
  assert(type(bufnr) == 'number', 'bufnr must be a number')
  local bufopts = { noremap = true, silent = false, buffer = bufnr }

  -- Rename current file
  vim.api.nvim_create_user_command('TsRenameFile', function()
    local cur_file_path = util.get_current_file_path()
    local new_file_path = vim.fn.input("Rename File: ", cur_file_path, "file")
    tsserver_request.rename_file(0, cur_file_path, new_file_path);
  end, {})
  vim.keymap.set('n', '<F2>', ':TsRenameFile<CR>', bufopts)

  -- Rename current dir
  vim.api.nvim_create_user_command('TsRenameDir', function()
    local cur_dir_path = util.get_current_dir_path()
    local new_dir_path = vim.fn.input("Rename Dir: ", cur_dir_path, "file")
    vim.cmd('!git mv ' .. cur_dir_path .. ' ' .. new_dir_path)
  end, {})

  -- Organize import
  vim.api.nvim_create_user_command('TsOrganizeImport', function()
    local cur_file_path = util.get_current_file_path()
    tsserver_request.organize_import(0, cur_file_path)
  end, {})
  return true
end

local function setting_for_ts_source_file_util_service()
  local function makeTestFile()
  end
end

return {
  setting_for_tsserver_language_service = {
    name = 'setting_for_tsserver_language_service',
    handle = setting_for_tsserver_language_service
  },
  setting_for_ts_source_file_util_service = {
    name = 'setting_for_ts_source_file_util_service',
    handle = setting_for_ts_source_file_util_service
  }
}
