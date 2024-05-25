local reduce = require('lib.h-list').reduce
local include = require('lib.h-list').include

local function get_files_in_path(path, options)
  options = options or {}
  if options.ignore_patterns == nil then
    options.ignore_patterns = {}
  end
  if options.absolute == nil then
    options.absolute = true
  end
  if options.extensions == nil then
    options.extensions = {}
  end

  if options.filetype == nil or not include({ 'all', 'file', 'directory' }, options.filetype) then
    options.filetype = 'all'
  end

  local exclude_options = reduce(options.ignore_patterns, function(prev, dir)
    return prev .. '-E ' .. dir .. ' '
  end, '')

  local extension_options = reduce(options.extensions, function(prev, ext)
    return prev .. '-e ' .. ext .. ' '
  end, '')

  local fd_cmd = 'fd -H -I'
    .. (options.absolute and ' -a ' or ' ')
    .. (options.filetype == 'all' and '' or ' -t ' .. options.filetype .. ' ')
    .. '--strip-cwd-prefix '
    .. extension_options
    .. exclude_options
    .. ' '
    .. path

  local pfile = io.popen(fd_cmd)

  if pfile == nil then
    print('No files found in path: ' .. path, 'error')
    return nil
  end

  local files = {}
  for line in pfile:lines() do
    table.insert(files, line)
  end

  pfile:close()
  return files
end

local function on_each_files_in_path(path, callback, option)
  local files = get_files_in_path(path, option)
  if files == nil then
    return
  end
  for _, file in pairs(files) do
    callback(file)
  end
end

local function get_git_rootdir_of_cur_file()
  return vim.fn.finddir('.git/..', vim.fn.expand '%:p:h' .. ';')
end

local function get_module_rootdir_of_cur_file()
  local rootDir = vim.fn.finddir('node_modules/..', vim.fn.expand '%:p:h' .. ';')
  if rootDir == '' then
    rootDir = get_git_rootdir_of_cur_file()
  end
  return rootDir
end

local function get_current_file_path(options)
  options = options or {}
  if options.absolute == nil then
    options.absolute = true
  end

  if options.absolute == true then
    return vim.fn.expand '%:p'
  else
    return vim.fn.expand '%:p:t'
  end
end

local function get_current_dir_path()
  return vim.fn.expand '%:p:h'
end

local function change_dir_to(dir)
  vim.cmd('cd ' .. vim.fn.fnameescape(dir))
end

local function change_cwd_to_root_dir_of_cur_file()
  local rootDir = get_module_rootdir_of_cur_file()
  vim.notify('CWD: ' .. rootDir)
  change_dir_to(rootDir)
end

return {
  get_files_in_path = get_files_in_path,
  on_each_files_in_path = on_each_files_in_path,
  get_git_rootdir_of_cur_file = get_git_rootdir_of_cur_file,
  get_module_rootdir_of_cur_file = get_module_rootdir_of_cur_file,
  get_current_file_path = get_current_file_path,
  get_current_dir_path = get_current_dir_path,
  change_dir_to = change_dir_to,
  change_cwd_to_root_dir_of_cur_file = change_cwd_to_root_dir_of_cur_file,
}
