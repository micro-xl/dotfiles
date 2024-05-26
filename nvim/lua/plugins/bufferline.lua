return {
  {
    'akinsho/bufferline.nvim',
    event = { 'VeryLazy' },
    -- event = { 'BufRead', 'BufAdd' }, TODO: Lazy load on using buffer for text editting. 지금 현상은 Dashboard나 telescope 통해서 버퍼를 열었을때 성공적으로 config는 실행되지만 buffline이 표시되지 않는 이슈가 있음
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('bufferline').setup {}
      LOG '[LOADED] bufferline'
    end,
  },
}
