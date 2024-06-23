local asserter = require 'lib.asserter'

local mod = {}

-- @param cmd_str string
mod.pexec = function(cmd_str)
  asserter.not_nil(cmd_str, 'command_str')
  asserter.non_empty_string(cmd_str, 'command_str')

  -- Create temporary files for stdout and stderr
  local tmp_stdout = os.tmpname()
  local tmp_stderr = os.tmpname()

  -- Modify the command to redirect stdout and stderr to the temporary files
  local cmd_with_redirects = string.format('%s > %s 2> %s', cmd_str, tmp_stdout, tmp_stderr)
  os.execute(cmd_with_redirects)

  -- Read the contents of the temporary files
  local stdout_file = io.open(tmp_stdout, 'r')
  local stderr_file = io.open(tmp_stderr, 'r')

  local stdout = stdout_file:read '*a'
  local stderr = stderr_file:read '*a'

  stdout_file:close()
  stderr_file:close()

  -- Remove the temporary files
  os.remove(tmp_stdout)
  os.remove(tmp_stderr)
  if stderr ~= '' then
    return nil, stderr
  end
  return stdout, nil
end

mod.exec = function(cmd_str)
  asserter.not_nil(cmd_str, 'command_str')
  asserter.non_empty_string(cmd_str, 'command_str')

  local stdout, stderr = mod.pexec(cmd_str)
  if stderr ~= nil then
    error(stderr)
  end
  return stdout or ''
end

return mod
