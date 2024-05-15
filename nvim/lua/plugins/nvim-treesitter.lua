require('nvim-treesitter.configs').setup({
  ensure_installed = { 'typescript', 'json', 'javascript', 'lua', 'vim' },
  auto_install = true,
  additional_vim_regex_highlighting = false,
  highlight = {
    enable = false
  },
  refactor = {
    highlight_definitions = { enable = false },
    highlight_current_scope = { enable = false },
    smart_rename = { enable = false },
    navigation = { enable = false },
  }
})
