--- This module provides an experience similar to copilot.vim, offering code completion using virtual text.
--- It uses a local ollama model (util/llm/ollama client).
--- @class OpenCompletion
local M = {}


local ollama = require("util.llm.ollama")
local virtual_text = require("util.ui.virtual_text")
local cursor_util = require("util.ui.cursor")

--- @alias PromptMaker fun(ctx: {before: string, after: string}, filename: string, filetype: string): string


--- @class CompletionPrompting
--- @field model string
--- @field make_prompt PromptMaker
--- @field override_options OllamaCompleteRequestOptions

--- @class table<'CODEGEMMA_2B' | 'CODELLAMA_7B', CompletionPrompting>
M.COMPLETION_PROMPTING = {
  CODEGEMMA_2B = {
    model = 'codegemma:2b',
    --- @type PromptMaker
    make_prompt = function(ctx, filetype, filename)
      local prefix = ctx.before
      local suffix = ctx.after
      return string.format("<|fim_prefix|>%s<|fim_suffix|>%s<|fim_middle|>", prefix, suffix)
    end,
    override_options = {
      num_prediction = 64,
      temperature = 0.5,
      top_p = 0.95,
      stop = { "<|file_separator|>" }
    }
  },
  CODELLAMA_7B = {
    model = "codellama:7b-code",
    make_prompt = function(ctx, filetype, filename)
      local metadata = wrapAsComment(filetype, filename) .. "\n\n"
      return string.format("<PRE> %s %s <SUF> %s <MID>", metadata, ctx.before, ctx.after)
    end,
    override_options = {
      num_prediction = 64,
      temperature = 0.5,
      top_p = 0.95,
      stop = { "<EOT>" }
    }
  }
}

--- @param filetype string
--- @param content string
function wrapAsComment(filetype, content)
  -- 파일타입에 따라 주석 스타일을 다르게 처리
  if filetype == "lua" then
    return "-- " .. content
  elseif filetype == "python" then
    return "# " .. content
  elseif filetype == "javascript" or filetype == "typescript" or filetype == "typescriptreact" or filetype == "javascriptreact" then
    return "// " .. content
  elseif filetype == "c" or filetype == "cpp" or filetype == "java" then
    return "// " .. content
  elseif filetype == "sh" or filetype == "bash" or filetype == "zsh" then
    return "# " .. content
  elseif filetype == "html" then
    return "<!-- " .. content .. " -->"
  else
    return content
  end
end

--- @class OpenCompletionType
--- @field completion_prompting CompletionPrompting
--- @field keymap { request: string, accept: string, next: string, prev: string } -- keymaps for accept, next, prev (all required)


--- @param opts OpenCompletionType
function M.setup(opts)
  local ns = vim.api.nvim_create_namespace("open-completion")
  local vt = virtual_text.create(ns)
  local keymap = opts.keymap

  local completions = {}
  local current_index = 1

  local function clear_virtual_text()
    vt.clear(vim.api.nvim_get_current_buf())
    completions = {}
    current_index = 1
  end

  local function show_completion(text)
    local pos = vim.api.nvim_win_get_cursor(0)
    vt.show(vim.api.nvim_get_current_buf(), pos[1] - 1, pos[2], text)
  end

  local function request_completion()
    clear_virtual_text()
    local split = cursor_util.split_text_at_cursor()
    local filetype = vim.bo.filetype
    local filename = vim.fn.expand('%:t')
    local prompt = opts.completion_prompting.make_prompt({ before = split[1], after = split[2] }, filetype, filename)
    vim.print(prompt)
    ollama.complete({
      model = opts.completion_prompting.model,
      prompt = prompt,
      options = opts.completion_prompting.override_options,
      stream = false
    }, function(err, resp)
      if err then
        vim.notify("OpenCompletion error: " .. err, vim.log.levels.ERROR)
        return
      end
      if resp and resp.content then
        if type(resp.content) == "table" then
          completions = resp.content
        else
          completions = { resp.content }
        end
        current_index = 1
        vim.schedule(function()
          show_completion(completions[current_index])
        end)
      end
    end)
  end

  local function accept_completion()
    if completions[current_index] then
      -- 현재 커서 위치에 completion을 삽입
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local line = vim.api.nvim_get_current_line()
      local before = line:sub(1, col)
      local after = line:sub(col + 1)
      local new_line = before .. completions[current_index] .. after
      vim.api.nvim_set_current_line(new_line)
      vim.api.nvim_win_set_cursor(0, { row, col + #completions[current_index] })
      clear_virtual_text()
    end
  end

  local function next_completion()
    if #completions > 1 then
      current_index = current_index % #completions + 1
      show_completion(completions[current_index])
    end
  end

  local function prev_completion()
    if #completions > 1 then
      current_index = (current_index - 2) % #completions + 1
      show_completion(completions[current_index])
    end
  end

  vim.keymap.set("i", keymap.request, request_completion, { desc = "OpenCompletion: request completion" })
  vim.keymap.set("i", keymap.accept, accept_completion, { desc = "OpenCompletion: accept completion" })
  vim.keymap.set("i", keymap.next, next_completion, { desc = "OpenCompletion: next completion" })
  vim.keymap.set("i", keymap.prev, prev_completion, { desc = "OpenCompletion: previous completion" })

  return {
    request_completion = request_completion,
    clear_virtual_text = clear_virtual_text,
    accept_completion = accept_completion,
    next_completion = next_completion,
    prev_completion = prev_completion,
  }
end

return M
