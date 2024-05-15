-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua#L190
local ls = require('luasnip')
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local jump = ls.jump
local l = require("luasnip.extras").lambda
local rep = require("luasnip.extras").rep
local p = require("luasnip.extras").partial
local m = require("luasnip.extras").match
local n = require("luasnip.extras").nonempty
local dl = require("luasnip.extras").dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local types = require("luasnip.util.types")
local conds = require("luasnip.extras.conditions")
local conds_expand = require("luasnip.extras.conditions.expand")
ls.add_snippets('typescript', {
  s('func',
    fmt([[
    function {1}({2}):{3} {{
      {4}
    }}]], {
      i(1, 'functionName'),
      i(2, '/* args */'),
      i(3, 'ReturnType'),
      i(4, 'body')
    })
  ),
  s('async_func',
    fmt([[
    async function {1}({2}):Promise<{3}> {{
      {4}
    }}]], {
      i(1, 'functionName'),
      i(2, '/* args */'),
      i(3, 'ReturnType'),
      i(4, '// function body')
    })),
  s('async_method_public',
    fmt([[
    async {1}({2}):Promise<{3}> {{
      {4}
    }}]], {
      i(1, 'methodName'),
      i(2, '/* args */'),
      i(3, 'ReturnType'),
      i(4, '// method body')
    })),
  s('async_method_private',
    fmt([[
    private async {1}({2}):Promise<{3}> {{
      {4}
    }}]], {
      i(1, 'methodName'),
      i(2, '/* args */'),
      i(3, 'ReturnType'),
      i(4, '// method body')
    })),
  s('class',
    fmt([[
    class {1} {{
      constructor({2}) {{
        {3}
      }}

      {4}({5}): {6} {{
        {7}
      }}
    }}]], {
      i(1, 'ClassName'),
      i(2, '/* args */'),
      i(3, '// initialize'),
      i(4, 'methodName'),
      i(5, 'args'),
      i(6, 'ReturnType'),
      i(7, '// method body')
    })
  ),
  s('export:func',
    fmt([[
    export function {1}({2}):{3} {{
      {4}
    }}]], {
      i(1, 'functionName'),
      i(2, '/* args */'),
      i(3, 'ReturnType'),
      i(4, '// function body')
    })
  ),
  s('export:class',
    fmt([[
    export class {1} {{
      constructor({2}) {{
        {3}
      }}

      {4}({5}): {6} {{
        {7}
      }}
    }}]], {
      i(1, 'ClassName'),
      i(2, '/* args */'),
      i(3, '/* initialize */'),
      i(4, 'methodName'),
      i(5, '/* args */'),
      i(6, 'ReturnType'),
      i(7, '// method body')
    })
  ),
  s('constructor',
    fmt([[
      constructor({1}) {{{2}}}
    ]],
      {
        i(1, '/*args*/'),
        i(2, '// initialize')
      })
  ),
  s('desc',
    fmt([[
    describe('{1}', () => {{
      it('{2}', () => {{
        {3}
      }})
    }})
    ]], {
      i(1, '/* test name */'),
      i(2, '/* specification */'),
      i(3, '// test code'),
    })
  ),
  s('pbcopy',
    fmt([[
      function pbcopy(data: {1}) {{
        const proc = require('child_process').spawn('pbcopy');
        proc.stdin.write(data);
        proc.stdin.end();
      }}
    ]], {
      i(1, 'any')
    })
  )
})

-- press <Tab> to expand or jump in a snippet. These can also be mapped separately
-- via <Plug>luasnip-expand-snippet and <Plug>luasnip-jump-next.
vim.cmd("imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'")
vim.keymap.set('i', '<S-Tab>', function() jump(-1) end, { silent = true })
vim.keymap.set('s', '<Tab>', function() jump(1) end, { silent = true })
vim.keymap.set('s', '<S-Tab>', function() jump(-1) end, { silent = true })
return ls
