local get_current_dir_path = require('utils.path').get_current_dir_path
local join = require('utils.list').join;
local map = require('utils.list').map;
local replace = require('utils.string').replace;

-- Bookmarks
do
  local function open_bookmarks_file()
    vim.cmd('e ~/.bookmarks')
  end

  vim.api.nvim_create_user_command('BookmarksEdit', function() open_bookmarks_file() end, {});
end

-- CopyPwd
do
  local function copy_pwd()
    local path = vim.fn.system('pwd');
    vim.fn.system('echo "' .. path .. '" | pbcopy');
  end

  vim.api.nvim_create_user_command('CopyPwd', function() copy_pwd() end, {});
end

-- CurrentDirCopy
do
  local function copy_current_dir_path()
    local path = get_current_dir_path();
    vim.fn.system('echo "' .. path .. '" | pbcopy');
  end

  vim.api.nvim_create_user_command('CurrentDirPathCopy', copy_current_dir_path, {});
end

-- CopyBufferText
do
  local function copy_buffer_text()
    local allLines = vim.api.nvim_buf_get_lines(0, 0, -1, false);
    allLines = map(allLines, function(line)
      local text = line;
      text = replace(line, '\\', '\\\\');
      text = replace(text, '"', '\\"');
      text = replace(text, '`', '\\`');
      text = replace(text, '%$', '\\$');
      return text;
    end)
    local cmd =
        'printf "' ..
        join(map(allLines, function() return '%s' end), '\\n') ..
        '" ' ..
        join(map(allLines, function(line) return '"' .. line .. '"' end), ' ') ..
        ' | pbcopy'
    vim.fn.system(cmd);
    print('Copied buffer text to clipboard');
  end

  vim.api.nvim_create_user_command('CopyBufferText', copy_buffer_text, {});
end
