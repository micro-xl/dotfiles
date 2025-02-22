return {
  'my-translate',
  dir = '~/.config/nvim/lua/customs/my-translate',
  event = { 'VimEnter' },
  config = function()
    require('customs.my-translate').setup {
      lang = {
        from = 'en',
        to = 'ko',
      },
      keys = {
        trigger = 'tl',
        quit = 'q',
      },
    }
  end,
}
