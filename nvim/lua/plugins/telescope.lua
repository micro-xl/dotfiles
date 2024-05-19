local telescope = require('telescope')
local sorters = require('telescope.sorters')
local builtin = require('telescope.builtin')
local pickers = require('telescope.pickers')
local entry_display = require('telescope.pickers.entry_display')
local conf = require('telescope.config').values
local previewers = require('telescope.previewers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local lsp_ts_client = require('plugins.lsp.request.tsserver_request')

local concat = require('utils.list').concat
local web_devicons = require('nvim-web-devicons')
local path_util = require('utils.path');
local string_util = require('utils.string')
local filetype_of = require('utils.buffer').filetype_of
-- local async = require('plenary.async') -- TODO: define preview async

telescope.setup({
  defaults = {
    layout_strategy = 'bottom_pane',
    layout_config = { height = 0.4, prompt_position = 'bottom', preview_cutoff = 60 },
    sorter = sorters.get_generic_fuzzy_sorter,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  },
  pickers = {
    find_files = {
      find_command = {
        'rg',
        '--files',
        '--hidden',
        '--no-ignore',
        '--no-heading',
        '--with-filename',
        '--line-number',
        '--column',
        '--smart-case',
        '--iglob',
        '!**/node_modules/',
        '--iglob',
        '!**/.git/',
        '--iglob',
        '!**/dist/',
        '--iglob',
        '!**/esm/',
      }
    }
  },
})
telescope.load_extension('fzf')
-- telescope.load_extension('notify')

local bufopts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>p', builtin.commands, bufopts)
vim.keymap.set('n', '<space>t', builtin.builtin, bufopts)
vim.keymap.set('n', '<space>f', builtin.live_grep, bufopts)
vim.keymap.set('v', '<space>f', builtin.grep_string, bufopts)
vim.keymap.set('n', 'giw', builtin.grep_string, bufopts)
vim.keymap.set('n', '<leader>gst', builtin.git_status, bufopts)
vim.keymap.set('n', '<leader>gco', builtin.git_branches, bufopts)
vim.keymap.set('n', 'gr', builtin.lsp_references, bufopts)
vim.keymap.set('n', 'gt', builtin.lsp_type_definitions, bufopts)
vim.keymap.set('n', 'gd', builtin.lsp_definitions, bufopts)
vim.keymap.set('n', 'gi', builtin.lsp_implementations, bufopts)
vim.keymap.set('n', 'go', builtin.lsp_outgoing_calls, bufopts)
vim.keymap.set('n', 'gO', builtin.lsp_incoming_calls, bufopts)

local function change_dir(prompt_bufnr)
  local selected = action_state.get_selected_entry()
  if selected == nil then
    return
  end
  vim.cmd('cd ' .. selected.value)
  vim.notify('[CWD] ' .. selected.value)
  actions.close(prompt_bufnr);
end


-- Explore files
-- local function explore_files() -- alternative builtin.find_files
--   local open_file = function(prompt_bufnr)
--     local selected = action_state.get_selected_entry()
--     actions.close(prompt_bufnr);
--     if selected == nil or path_util.get_current_file_path() == selected.value then
--       return
--     else
--       vim.cmd('e ' .. selected.value)
--     end
--   end
--
--   local opts = {
--     prompt_title = 'Explorer',
--     results_title = 'In ' .. vim.fn.getcwd(),
--     finder = finders.new_table({
--       results = path_util.get_files_in_path('.', {
--         ignore_patterns = { 'node_modules', 'dist', 'esm', '.git' },
--         filetype = 'file',
--         absolute = false,
--       }),
--       entry_maker = function(entry_str)
--         local icon, color = web_devicons.get_icon(entry_str)
--         local default_icon = web_devicons.get_default_icon().icon
--         if icon == nil then
--           icon = default_icon;
--           color = 'DeviconDefault';
--         end
--         return {
--           valid = true,
--           value = entry_str,
--           ordinal = entry_str,
--           display = function(entry)
--             local displayer = entry_display.create({
--               separator = ' ',
--               items = {
--                 { width = 2 },
--                 { remaining = true },
--               },
--             })
--             return displayer({
--               { icon, color },
--               entry.value,
--             })
--           end
--         }
--       end,
--     }),
--     previewer = previewers.vim_buffer_cat.new({}),
--     sorter = conf.generic_sorter({}),
--     attach_mappings = function(_, map)
--       map('i', '<CR>', open_file)
--       return true
--     end
--   };
--
--   pickers.new(opts):find()
-- end
--
-- vim.api.nvim_create_user_command('ExploreFiles', explore_files, {})
-- vim.keymap.set('i', '<C-p>', explore_files, bufopts)
-- vim.keymap.set('n', '<C-p>', explore_files, bufopts)


-- NewFile
local function t_new_files()
  local create_file = function(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    local new_file_name = vim.fn.input('New file name: ')
    actions.close(prompt_bufnr);
    if string_util.get_nth_char(new_file_name, string.len(new_file_name)) == '/' then
      -- dir
      vim.fn.system('mkdir -p ' .. selected.value .. new_file_name)
    else
      -- file
      vim.cmd('e ' .. selected.value .. new_file_name)
      vim.cmd('w');
    end
  end
  local opts = {
    prompt_title = 'Create new File',
    results_title = 'Select parent directory',
    finder = finders.new_table({
      results = concat(
        { './' },
        path_util.get_files_in_path('.',
          {
            filetype = 'directory',
            absolute = false,
            ignore_patterns = { '.git', 'node_modules', 'esm', 'dist' }
          }
        )
      ),
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry,
          display = entry
        }
      end,
    }),
    previewer = previewers.vim_buffer_cat.new({}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<CR>', create_file)
      return true
    end
  }
  pickers.new(opts):find()
end

vim.api.nvim_create_user_command('NewFile', t_new_files, {})
vim.keymap.set('n', '<leader>af', t_new_files, {})

-- ChangeDirectory
local function t_change_directory()
  local opts = {
    prompt_title = 'Change directory',
    results_title = 'Select directory',
    finder = finders.new_table({
      results = path_util.get_files_in_path('.', { filetype = 'directory', absolute = false }),
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry,
          display = entry
        }
      end,
    }),
    previewer = previewers.vim_buffer_cat.new({}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<CR>', change_dir)
      return true
    end
  }
  pickers.new(opts):find()
end

vim.api.nvim_create_user_command('ChangeDirectory', t_change_directory, {})
vim.keymap.set('n', '<leader>cd', t_change_directory, {})

-- Delete File
local function t_delete_file()
  local remove_file = function(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    actions.close(prompt_bufnr);
    vim.fn.system('mv ' .. selected.value .. ' ~/.Trash/')
  end
  local opts = {
    prompt_title = 'Delete file',
    results_title = 'Select target',
    finder = finders.new_table({
      results = path_util.get_files_in_path('.', { absolute = false }),
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry,
          display = entry
        }
      end,
    }),
    previewer = previewers.vim_buffer_cat.new({}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<CR>', remove_file)
      return true
    end
  }
  pickers.new(opts):find()
end

vim.api.nvim_create_user_command('DeleteFile', t_delete_file, {})
vim.keymap.set('n', '<leader>df', t_delete_file, {})

-- Move dir
local function t_move_dir()
  local old_dir_path = path_util.get_current_dir_path()
  print(old_dir_path)
end

-- Move file
local function t_move_file()
  local old_file_path = path_util.get_current_file_path()
  local old_file_name = path_util.get_current_file_path({ absolute = false })
  local old_buf_nr = vim.fn.bufnr('%')
  local mv_file = function(prompt_bufnr)
    local selected = action_state.get_selected_entry()
    actions.close(prompt_bufnr);
    local new_file_path = selected.value .. old_file_name
    if filetype_of(0) == 'typescript' then
      vim.notify(old_file_path)
      lsp_ts_client.rename_file(0, old_file_path, new_file_path)
    end
    vim.fn.system('mv ' .. old_file_path .. ' ' .. selected.value);
    vim.cmd('e ' .. new_file_path)
    vim.api.nvim_buf_delete(old_buf_nr, { force = true })
  end
  local opts = {
    prompt_title = 'Move file',
    results_title = 'Select destination',
    finder = finders.new_table({
      results = concat(
        { './' },
        path_util.get_files_in_path('.',
          {
            filetype = 'directory',
            absolute = false,
            ignore_patterns = { 'node_modules', '.git', 'esm', 'dist' }
          }
        )
      ),
      entry_maker = function(entry)
        return {
          value = entry,
          ordinal = entry,
          display = entry
        }
      end,
    }),
    previewer = previewers.vim_buffer_cat.new({}),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(_, map)
      map('i', '<CR>', mv_file)
      return true
    end
  }
  pickers.new(opts):find()
end

vim.api.nvim_create_user_command('MoveFile', t_move_file, {})
vim.keymap.set('n', '<leader>mf', t_move_file, {})
