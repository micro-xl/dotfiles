-- Comment visual regions/lines

local is_tmux = os.getenv 'TMUX' ~= nil

local CTRL_SLASH = is_tmux and '' or '<C-/>'
local CTRL_QUESTION = is_tmux and '<backspace>' or '<C-?>'

return {
  { -- "gc" to comment visual regions/lines
    'numToStr/Comment.nvim',
    keys = {
      {
        '<C-/>',
        mode = { 'n', 'v' },
      },
      {
        '',
        mode = { 'n', 'v' },
      },
      {
        '<C-?>',
        mode = { 'n', 'v' },
      },
      {
        '<backspace>',
        mode = { 'n', 'v' },
      },
    },
    opts = {
      toggler = {
        line = CTRL_SLASH,
        block = CTRL_QUESTION,
      },
      opleader = {
        line = CTRL_SLASH,
        block = CTRL_QUESTION,
      },
    },
  },
}
