vim.ui.select = require("popui.ui-overrider")
vim.ui.input = require("popui.input-overrider")

vim.g.popui_border_style = "rounded";


vim.cmd('hi PopuiCoordinates guifg=#dcdcaa guibg=#272727 ctermfg=Red')
vim.cmd('hi PopuiDiagnosticsCodes guifg=#777777 ctermfg=Gray')
