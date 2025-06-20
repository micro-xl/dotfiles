--- @class InlineCompletion
local M = {}

local providers = require('custom.inline-completion.providers')
local virtual_text = require('custom.inline-completion.virtual-text')

local config = {
  provider = 'openai',
  auto_trigger = true,
  trigger_delay = 1000,
  filetypes = { 'lua', 'javascript', 'typescript', 'python', 'go', 'rust' },
  keymaps = {
    accept = '<Tab>',
    reject = '<C-c>',
    next_suggestion = '<C-n>',
    prev_suggestion = '<C-p>',
  },
  providers = {
    openai = {
      api_key = vim.env.OPENAI_API_KEY,
      model = 'gpt-4.1-mini',
      max_tokens = 100,
    },
    anthropic = {
      api_key = vim.env.ANTHROPIC_API_KEY,
      model = 'claude-3.5-haiku',
      max_tokens = 100,
    },
  }
}

local state = {
  current_suggestion = nil,
  suggestions = {},
  suggestion_index = 1,
  timer = nil,
  bufnr = nil,
  row = nil,
  col = nil,
}

local function clear_suggestion()
  if state.current_suggestion then
    virtual_text.clear(state.bufnr)
    state.current_suggestion = nil
    state.suggestions = {}
    state.suggestion_index = 1
  end
end

local function show_suggestion(suggestion)
  if not suggestion or suggestion == '' then
    return
  end

  state.current_suggestion = suggestion
  virtual_text.show(state.bufnr, state.row, state.col, suggestion)
end

local function accept_suggestion()
  if not state.current_suggestion then
    return
  end

  local lines = vim.split(state.current_suggestion, '\n')
  local current_line = vim.api.nvim_buf_get_lines(state.bufnr, state.row, state.row + 1, false)[1]

  -- Insert the suggestion
  if #lines == 1 then
    -- Single line suggestion
    local new_line = current_line:sub(1, state.col) .. lines[1] .. current_line:sub(state.col + 1)
    vim.api.nvim_buf_set_lines(state.bufnr, state.row, state.row + 1, false, { new_line })
    vim.api.nvim_win_set_cursor(0, { state.row + 1, state.col + #lines[1] })
  else
    -- Multi-line suggestion
    local first_line = current_line:sub(1, state.col) .. lines[1]
    local last_line = lines[#lines] .. current_line:sub(state.col + 1)

    local new_lines = { first_line }
    for i = 2, #lines - 1 do
      table.insert(new_lines, lines[i])
    end
    table.insert(new_lines, last_line)

    vim.api.nvim_buf_set_lines(state.bufnr, state.row, state.row + 1, false, new_lines)
    vim.api.nvim_win_set_cursor(0, { state.row + #lines, #lines[#lines] })
  end

  clear_suggestion()
end

local function next_suggestion()
  if #state.suggestions == 0 then
    return
  end

  state.suggestion_index = state.suggestion_index % #state.suggestions + 1
  show_suggestion(state.suggestions[state.suggestion_index])
end

local function prev_suggestion()
  if #state.suggestions == 0 then
    return
  end

  state.suggestion_index = state.suggestion_index - 1
  if state.suggestion_index < 1 then
    state.suggestion_index = #state.suggestions
  end
  show_suggestion(state.suggestions[state.suggestion_index])
end

local function get_context()
  local bufnr = vim.api.nvim_get_current_buf()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] - 1
  local col = cursor[2]

  -- Get surrounding context
  local start_row = math.max(0, row - 10)
  local end_row = math.min(vim.api.nvim_buf_line_count(bufnr) - 1, row + 5)
  local lines = vim.api.nvim_buf_get_lines(bufnr, start_row, end_row + 1, false)

  local context = table.concat(lines, '\n')
  local current_line = vim.api.nvim_buf_get_lines(bufnr, row, row + 1, false)[1] or ''
  local prefix = current_line:sub(1, col)

  return {
    context = context,
    prefix = prefix,
    filetype = vim.bo[bufnr].filetype,
    filename = vim.api.nvim_buf_get_name(bufnr),
  }
end

local function request_completion()
  if state.timer then
    state.timer:stop()
    state.timer = nil
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  state.bufnr = vim.api.nvim_get_current_buf()
  state.row = cursor[1] - 1
  state.col = cursor[2]

  local context = get_context()
  local provider = providers.get_provider(config.provider)

  if not provider then
    vim.notify('Provider not found: ' .. config.provider, vim.log.levels.ERROR)
    return
  end

  provider.complete(context, config.providers[config.provider], function(suggestions)
    if suggestions and #suggestions > 0 then
      state.suggestions = suggestions
      state.suggestion_index = 1
      show_suggestion(suggestions[1])
    end
  end)
end

local function is_supported_filetype()
  local current_ft = vim.bo.filetype
  if not config.filetypes or #config.filetypes == 0 then
    return true
  end
  
  for _, ft in ipairs(config.filetypes) do
    if ft == current_ft then
      return true
    end
  end
  return false
end

local function trigger_completion()
  if not config.auto_trigger or not is_supported_filetype() then
    return
  end

  clear_suggestion()

  if state.timer then
    state.timer:stop()
  end

  state.timer = vim.defer_fn(function()
    request_completion()
  end, config.trigger_delay)
end

local function setup_keymaps()
  local opts = { noremap = true, silent = true }

  vim.keymap.set('i', config.keymaps.accept, function()
    if state.current_suggestion then
      accept_suggestion()
    end
    return config.keymaps.accept
  end, { expr = true, noremap = true, silent = true })

  vim.keymap.set('i', config.keymaps.reject, function()
    clear_suggestion()
  end, opts)

  vim.keymap.set('i', config.keymaps.next_suggestion, function()
    next_suggestion()
  end, opts)

  vim.keymap.set('i', config.keymaps.prev_suggestion, function()
    prev_suggestion()
  end, opts)
end

local function setup_autocmds()
  local group = vim.api.nvim_create_augroup('InlineCompletion', { clear = true })

  vim.api.nvim_create_autocmd({ 'TextChangedI' }, {
    group = group,
    callback = trigger_completion,
  })

  vim.api.nvim_create_autocmd({ 'InsertLeave', 'BufLeave' }, {
    group = group,
    callback = clear_suggestion
  })

  vim.api.nvim_create_autocmd({ 'CursorMovedI' }, {
    group = group,
    callback = function()
      -- Clear suggestion if cursor moved away from suggestion position
      if state.current_suggestion then
        local cursor = vim.api.nvim_win_get_cursor(0)
        local row = cursor[1] - 1
        local col = cursor[2]

        if row ~= state.row or col < state.col then
          clear_suggestion()
        end
      end
    end,
  })
end

function M.setup(opts)
  config = vim.tbl_deep_extend('force', config, opts or {})

  setup_keymaps()
  setup_autocmds()

  -- Commands
  vim.api.nvim_create_user_command('InlineCompletionToggle', function()
    config.auto_trigger = not config.auto_trigger
    vim.notify('Inline completion ' .. (config.auto_trigger and 'enabled' or 'disabled'))
  end, { desc = 'Toggle inline completion' })

  vim.api.nvim_create_user_command('InlineCompletionProvider', function(args)
    if args.args == '' then
      vim.notify(
        'Current provider: ' .. config.provider .. '\n' ..
        'Available providers: ' .. table.concat(vim.tbl_keys(config.providers), ', ') .. '\n' ..
        'To switch: InlineCompletionProvider <provider>'
      )
    else
      if config.providers[args.args] then
        config.provider = args.args
        vim.notify('Switched to provider: ' .. args.args)
      else
        vim.notify('Unknown provider: ' .. args.args, vim.log.levels.ERROR)
      end
    end
  end, {
    desc = 'Set or show current AI provider',
    nargs = '?',
    complete = function()
      return vim.tbl_keys(config.providers)
    end
  })

  vim.api.nvim_create_user_command('InlineCompletionRequest', function()
    if is_supported_filetype() then
      request_completion()
    else
      vim.notify('Inline completion not supported for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
    end
  end, { desc = 'Manually request completion' })
end

return M
