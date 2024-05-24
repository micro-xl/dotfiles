local asserter = require('asserter')
local floating = require('floating-window')
local h_string = require('h-string')
local h_list = require('h-list')
local fz = require('fzf-wrapper');
local exec = require('h-shell').exec
local get_icon = require('nvim-web-devicons').get_icon

-- TODO: 최초파일 리스트 캐시 확보 비동기로 변경

local mod = {}

local function icon_of_filename(filename)
  local icon = get_icon(filename)
  if icon == nil then
    return ''
  end
  return icon
end

-- @params {table} opts
-- @params {string} opts.excludes
mod.fzf_find_file = function(opts)
  asserter.not_nil(opts, 'opts');
  asserter.table(opts, 'opts');

  local excludes = opts.excludes ~= nil and h_list.join(h_list.map(opts.excludes, function(exclude_item)
        return '--exclude ' .. exclude_item
      end), ' ') or '';
  floating.open(0.9, 0.8, {
    filetype = 'find-file'
  })

  fz.with_fzf_on_cur_win(function(fzf)
    local pwd_stdout = h_string.trim(exec('pwd'))

    -- TODO 스트림 처리로 변경
    -- local ignore_error = function(err)
    --   if err then
    --     return;
    --   end
    -- end
    -- fzf(function(emit)
    --   emit('1', ignore_error)
    --   emit('2', ignore_error)
    -- end)
    local fd_stdout = h_string.trim(exec('fd --type f --hidden --no-ignore ' .. excludes .. ' .'))
    local sources = h_list.map(h_string.split(fd_stdout, '\n'), function(item)
      return icon_of_filename(item) .. ' ' .. item
    end)
    local picked = fzf(sources, '--color=gutter:-1')
    asserter.assert(#picked == 1, 'length of picked should be 1')

    local start_idx, end_idx = string.find(picked[1], ' ');
    asserter.assert(start_idx == end_idx and start_idx ~= nil, 'start_idx should be equal to end_idx and not nil')

    local filename = string.sub(picked[1], end_idx + 1, #picked[1])
    vim.cmd('e ' .. pwd_stdout .. '/' .. filename)
  end)
end


-- @params {table} opts
-- @params {table} opts.excludes
-- @params {string} opts.command
-- @params {string} opts.keymap
mod.setup = function(opts)
  asserter.not_nil(opts.command, 'opts.command')
  asserter.non_empty_string(opts.command, 'opts.command')
  asserter.non_empty_string(opts.keymap, 'opts.keymap')

  vim.api.nvim_create_user_command(opts.command, function()
    mod.fzf_find_file({
      excludes = opts.excludes
    })
  end, {})

  vim.api.nvim_set_keymap('n', opts.keymap, ':' .. opts.command .. '<CR>', { noremap = true, silent = true })
end

return mod;
