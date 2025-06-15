local M = {}

local function make_openai_request(context, provider_config, callback)
  local prompt = string.format([[
You are a code completion assistant. Given the following context, provide a short, relevant code completion.

File: %s
Language: %s
Context:
%s

Current prefix: %s

Provide only the completion text, no explanations. Keep it concise and relevant.
]], context.filename, context.filetype, context.context, context.prefix)

  local body = vim.json.encode({
    model = provider_config.model,
    messages = {
      {
        role = "user",
        content = prompt
      }
    },
    max_tokens = provider_config.max_tokens,
    temperature = 0.3,
    stream = false
  })

  local cmd = string.format([[
curl -s -X POST "https://api.openai.com/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer %s" \
  -d '%s'
]], provider_config.api_key, body:gsub("'", "'\"'\"'"))

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        local response_text = table.concat(data, '\n')
        local ok, response = pcall(vim.json.decode, response_text)
        
        if ok and response.choices and #response.choices > 0 then
          local completion = response.choices[1].message.content
          if completion and completion ~= '' then
            callback({ completion })
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify('OpenAI API error: ' .. table.concat(data, '\n'), vim.log.levels.ERROR)
      end
    end,
  })
end

local function make_anthropic_request(context, provider_config, callback)
  local prompt = string.format([[
You are a code completion assistant. Given the following context, provide a short, relevant code completion.

File: %s
Language: %s
Context:
%s

Current prefix: %s

Provide only the completion text, no explanations. Keep it concise and relevant.
]], context.filename, context.filetype, context.context, context.prefix)

  local body = vim.json.encode({
    model = provider_config.model,
    max_tokens = provider_config.max_tokens,
    messages = {
      {
        role = "user",
        content = prompt
      }
    }
  })

  local cmd = string.format([[
curl -s -X POST "https://api.anthropic.com/v1/messages" \
  -H "Content-Type: application/json" \
  -H "x-api-key: %s" \
  -H "anthropic-version: 2023-06-01" \
  -d '%s'
]], provider_config.api_key, body:gsub("'", "'\"'\"'"))

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    on_stdout = function(_, data)
      if data and #data > 0 then
        local response_text = table.concat(data, '\n')
        local ok, response = pcall(vim.json.decode, response_text)
        
        if ok and response.content and #response.content > 0 then
          local completion = response.content[1].text
          if completion and completion ~= '' then
            callback({ completion })
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        vim.notify('Anthropic API error: ' .. table.concat(data, '\n'), vim.log.levels.ERROR)
      end
    end,
  })
end

local providers = {
  openai = {
    complete = make_openai_request,
  },
  anthropic = {
    complete = make_anthropic_request,
  },
}

function M.get_provider(name)
  return providers[name]
end

function M.list_providers()
  return vim.tbl_keys(providers)
end

return M
