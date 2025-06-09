--[[ Configs ]]
require('config.options').setup()
require('config.autocommands').setup()
require 'config.diagnostics'

require('config.keymaps').setup {
  keymap_delete_current_buffer_force = '<leader>bd',
  keymap_close_other_buffers = '<leader>bc',
  keymap_previous_buffer = '<leader>[',
  keymap_next_buffer = '<leader>]',
  keymap_search = '<C-f>',
}

if vim.fn.has("nvim-0.11.2") ~= 1 then
  error("Neovim ≥0.11.2 required (current " ..
    vim.version().major .. "." .. vim.version().minor .. "." .. vim.version().patch .. ")")
end


--[[ Plugins ]]
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out,                            "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', { ui = { border = 'rounded' } })
