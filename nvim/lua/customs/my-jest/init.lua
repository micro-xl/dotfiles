local h_path = require 'lib.h-path'
local h_string = require 'lib.h-string'
local pipe = require('lib.h-function').pipe

local M = {}

-- @param {table} opts
-- @param {string} opts.test_command - test command to run
function M.setup(opts)
  print 'asdfasdfasdfasddsf'
  local test_command = opts.test_command or 'jest'

  local function parse_test_suite()
    local current_line = h_string.trim(vim.api.nvim_buf_get_lines(0, vim.fn.line '.' - 1, vim.fn.line '.', false)[1])
    local test_signature = { 'describe', 'it', 'test', 'itLocal' }
    local test_suite_name = current_line:match('[' .. table.concat(test_signature, '') .. ']+' .. "%([\"']([^']+)[\"'].-[,%)%s]")
    if test_suite_name == nil then
      return nil
    end

    if current_line:match '^describe' then
      return '"^' .. test_suite_name .. '"'
    end

    if current_line:match '^it' or current_line:match '^test' or current_line:match '^itLocal' then
      return '"' .. test_suite_name .. '$"'
    end

    return nil
  end

  local function build_command(test_name, file_name, options)
    test_name = string.gsub(test_name, '%(', '\\(')
    test_name = string.gsub(test_name, '%)', '\\)')

    local command = (options.inspect == true and 'env NODE_OPTIONS="$(echo $NODE_OPTIONS) --inspect" ' or ' ')
      .. 'pnpm '
      .. test_command
      .. (options.watch == true and ' --watch ' or ' ')
      .. '-t '
      .. test_name
      .. ' '
      .. file_name
    return command
  end

  -- TestSingle, TestSingleWatch
  local function test_single(options)
    local test_name = parse_test_suite()

    if test_name == nil then
      vim.notify 'No test found in this line'
      return
    end

    vim.fn.chdir(h_path.get_module_rootdir_of_cur_file())

    local cmd = build_command(test_name, h_path.get_current_file_path(), options)
    cmd = h_string.escape_question_mark(cmd)
    cmd = h_string.escape_double_quote(cmd) --.gsub(test_name, '%"', '\\"')

    vim.cmd('VimuxRunCommand("' .. cmd .. '")')
    --      local windowRatio = h_window.getCurrentWindowRatio()
    --      if windowRatio.height >= windowRatio.width then
    --        h_terminal.open_terminal_horizontal(cmd)
    --      else
    --        h_terminal.open_terminal_vertical(cmd)
    --      end
  end

  vim.api.nvim_create_user_command('TestSingle', function()
    test_single { watch = false }
  end, {})
  vim.api.nvim_create_user_command('TestSingleDebug', function()
    test_single { watch = false, inspect = true }
  end, {})
  vim.api.nvim_create_user_command('TestSingleWatch', function()
    test_single { watch = true }
  end, {})
  vim.keymap.set('n', '<F5>', ':TestSingle<CR>', { silent = true })
  vim.keymap.set('n', '<F6>', ':TestSingleDebug<CR>', { silent = true })

  -- TestSingleCopy, TestSingleCopyWatch
  local function test_single_copy(options)
    local test_module_root = h_path.get_module_rootdir_of_cur_file()
    local test_name = parse_test_suite()
    if test_name == nil then
      vim.notify 'No test found in this line'
      return
    end
    local cd_cmd = 'cd ' .. test_module_root
    local cli_cmd = build_command(test_name, h_path.get_current_file_path(), options)
    local escape_unnecessary_chars = pipe(h_string.escape_double_quote, h_string.escape_dollar_sign, h_string.escape_question_mark)
    local system_copy_cmd = 'echo "' .. cd_cmd .. ' && ' .. escape_unnecessary_chars(cli_cmd) .. '" | pbcopy'
    vim.fn.system(system_copy_cmd)
  end
  vim.api.nvim_create_user_command('TestSingleCopy', function()
    test_single_copy { watch = false }
  end, {})
  vim.api.nvim_create_user_command('TestSingleCopyDebug', function()
    test_single_copy { watch = false, inspect = true }
  end, {})
  vim.api.nvim_create_user_command('TestSingleCopyWatch', function()
    test_single_copy { watch = true }
  end, {})
  vim.keymap.set('n', '<leader><F5>', ':TestSingleCopy<CR>', { silent = true })
  vim.keymap.set('n', '<leader><F6>', ':TestSingleCopyDebug<CR>', { silent = true })
end

return M
