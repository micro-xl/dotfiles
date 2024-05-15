local trim = require('utils.string').trim

local function translate_shell(word, source_lang, dest_lang, option)
  option = option or {
    brief = false
  }
  local cmd = "trans " ..
      (option.brief == true and "-b " or " ") ..
      "-show-original n " ..
      "-show-original-phonetics n " ..
      "-show-translation n " ..
      "-show-translation-phonetics n " ..
      "-show-prompt-message n " ..
      "--no-ansi " ..
      source_lang .. ":" .. dest_lang .. ' "' .. word .. '"'
  return trim(vim.fn.system(cmd));
end

return {
  translate_shell = translate_shell
}
