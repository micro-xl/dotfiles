local h_window = require 'lib.h-window'
local h_terminal = require 'lib.h-terminal'

local COMMAND = 'Playground'

local function save_runner(bufnr, cmd)
  return function()
    vim.api.nvim_buf_call(bufnr, function()
      vim.api.nvim_command 'write'
    end)
    local windowRatio = h_window.getCurrentWindowRatio()
    if windowRatio.height >= windowRatio.width then
      h_terminal.open_terminal_horizontal(cmd)
    else
      h_terminal.open_terminal_vertical(cmd)
    end
  end
end

local function on_scratch_created(entry)
  local build_cmd = ''
  if entry.ext == 'ts' then
    build_cmd = 'ts-node ' .. entry.path
  else
    error('Unsupported extension: ' .. entry.ext)
  end
  local bufnr = vim.api.nvim_get_current_buf()
  vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>', '', { callback = save_runner(bufnr, build_cmd) })
  vim.api.nvim_buf_set_keymap(bufnr, 'i', '<C-s>', '', { callback = save_runner(bufnr, build_cmd) })
end

return {
  'm-demare/attempt.nvim',
  cmd = COMMAND,
  config = function()
    local attempt = require 'attempt'
    attempt.setup {
      dir = '/tmp/attempt.nvim/',
      autosave = false,
      list_buffers = true, -- This will make them show on other pickers (like :Telescope buffers)
      initial_content = {
        py = '',           -- Either string or function that returns the initial content
        c = '',
        cpp = '',
        java = '',
        rs = '',
        go = '',
        sh = '',
      },
      ext_options = { 'lua', 'js', 'ts', 'py', '' }, -- Options to choose from
      format_opts = {
        [''] = '[None]',
        ['js'] = 'javascript',
        ['ts'] = 'typescript',
        ['py'] = 'python',
        ['lua'] = 'lua',
      }, -- How they'll look
      run = {
        -- Not use this option. Instead, use set keymap on the callback of the creation. see below.
        -- py = { 'w !python' }, -- Either table of strings or lua functions
        -- js = { 'w !node' },
        -- ts = function() end,
        -- lua = { 'w', 'luafile %' },
        -- sh = { 'w !bash' },
        -- pl = { 'w !perl' },
      },
    }
    vim.api.nvim_create_user_command(COMMAND, function()
      -- @type entry { ext = string, filename = string, path = string, creation_date = number }
      attempt.new_select(on_scratch_created)
    end, {
      desc = 'Create a new scratch buffer'
    })
  end,
}
