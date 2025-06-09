local exec = require('lib.h-shell').exec
local trim = require('lib.string').trim

--[[ Telescope provides a  Fuzzy Finder for files, lsp, etc ]]

return {
  {
    'nvim-telescope/telescope.nvim',
    event = { 'VimEnter' },
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'folke/noice.nvim' }, -- TODO: popupwindow의 winblend option이 값이아니라 함수로 들어가는 이상한 이슈가 있는데, noice가 로드되면서 해당 옵션을 덮어써줄수있음.
      { -- Use native fzf for telescope fuzzy finding
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { -- Use telescope ui for vim.select
        'nvim-telescope/telescope-ui-select.nvim',
      },
      -- Useful for getting pretty icons, but requires a Nerd Font.
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      require('telescope').setup {
        -- extensions = {
        --   ['ui-select'] = {
        --     require('telescope.themes').get_dropdown(),
        --   },
        -- },
      }

      pcall(require('telescope').load_extension, 'fzf')
      -- pcall(require('telescope').load_extension, 'ui-select')

      local builtin = require 'telescope.builtin'

      vim.keymap.set('n', '<space>p', builtin.commands, {})
      vim.keymap.set('n', '<space>t', builtin.builtin, {})
      vim.keymap.set('n', '<space>r', builtin.resume, {})
      vim.keymap.set('v', '<space>f', builtin.grep_string, {})
      vim.keymap.set('n', 'giw', builtin.grep_string, {})
      vim.keymap.set('n', '<C-b>', builtin.buffers, {})
      -- Find Neovim configuration files
      vim.keymap.set('n', '<space>n', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Find Neovim configuration files' })

      -- Bookmarks
      vim.keymap.set('n', 'π', function()
        require('telescope.pickers')
          .new({
            prompt_title = 'Bookmarks',
            result_title = 'In ~/.bookmarks',
            finder = require('telescope.finders').new_table {
              results = vim.fn.systemlist 'cat ~/.bookmarks',
              entry_maker = function(entry)
                return {
                  value = entry,
                  ordinal = entry,
                  display = entry,
                }
              end,
            },
            sorter = require('telescope.config').values.generic_sorter {},
            previewer = require('telescope.previewers').vim_buffer_cat.new {},
            attach_mappings = function(_, map)
              map('i', '<CR>', function(prompt_bufnr)
                local selected = require('telescope.actions.state').get_selected_entry()
                if selected == nil then
                  return
                end

                vim.api.nvim_exec('cd ' .. vim.fn.fnameescape(selected.value), false)
                vim.notify('[CWD] ' .. selected.value)
                require('telescope.actions').close(prompt_bufnr)
              end)
              return true
            end,
          }, {})
          :find()
      end, { desc = 'Change directory to the selected bookmarks' })

      -- Find files
      vim.keymap.set('n', '<C-p>', function()
        builtin.find_files {
          cwd = vim.fn.getcwd(-1, -1),
          no_ignore = false,
          no_ignore_parent = false,
          hidden = true,
        }
      end, { desc = 'Find files in cwd' })

      vim.keymap.set('n', '<space>f', function()
        builtin.live_grep {
          cwd = vim.fn.getcwd(-1, -1),
        }
      end)
    end,
  },
}
