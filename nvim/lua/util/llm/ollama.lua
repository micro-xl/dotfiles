local curl = require('plenary.curl')

--- @class OllamaClient : LLMClient
--- OllamaClient implements the LLMClient interface.
local M = {}

--- Get available models from Ollama
--- @param callback? fun(err: string?, models: table?) Optional callback for async operation
--- @return table|nil
function M.list_models(callback)
  local url = 'http://localhost:11434/api/tags'
  local headers = {
    ['Content-Type'] = 'application/json',
  }

  if callback then
    -- Async request
    curl.get(url, {
      headers = headers,
      callback = function(response)
        if response.status == 200 then
          local success, data = pcall(vim.json.decode, response.body)
          if success and data.models then
            callback(nil, data.models)
          else
            callback('Failed to parse response JSON or missing models field', nil)
          end
        else
          callback('HTTP error: ' .. response.status .. ' - ' .. (response.body or ''), nil)
        end
      end,
    })
  else
    -- Sync request
    local response = curl.get(url, {
      headers = headers,
    })

    if response.status == 200 then
      local success, data = pcall(vim.json.decode, response.body)
      if success and data.models then
        return data.models
      else
        error('Failed to parse response JSON or missing models field')
      end
    else
      error('HTTP error: ' .. response.status .. ' - ' .. (response.body or ''))
    end
  end
end

--- Send a chat completion request to Ollama (LLMClient interface)
--- @param request table
--- @param callback? fun(err: string?, response: table?) Optional callback for async operation
--- @return table|nil
function M.chat_complete(request, callback)
  local url = 'http://localhost:11434/api/chat'
  local headers = {
    ['Content-Type'] = 'application/json',
  }

  -- Input validation
  if not request then
    error('Request is required')
  end

  if type(request) ~= 'table' then
    error('Request must be a table')
  end

  if not request.messages or type(request.messages) ~= 'table' then
    error('Messages array is required and must be a table')
  end

  -- Validate each message
  for i, message in ipairs(request.messages) do
    if type(message) ~= 'table' then
      error('Message ' .. i .. ' must be a table')
    end

    if not message.role or type(message.role) ~= 'string' then
      error('Message ' .. i .. ' must have a role (string)')
    end

    if not message.content or type(message.content) ~= 'string' then
      error('Message ' .. i .. ' must have content (string)')
    end
  end

  -- Validate optional parameters
  if request.model and type(request.model) ~= 'string' then
    error('Model must be a string')
  end

  if request.stream and type(request.stream) ~= 'boolean' then
    error('Stream must be a boolean')
  end

  if request.keep_alive and not (type(request.keep_alive) == 'string' or type(request.keep_alive) == 'number') then
    error('keep_alive must be a string or number')
  end

  local body = vim.json.encode({
    model = request.model or 'llama3.2',
    messages = request.messages,
    tools = request.tools,
    options = request.options or { top_p = 0.9 },
    stream = request.stream or false,
    keep_alive = request.keep_alive,
  })

  if callback then
    -- Async request
    curl.post(url, {
      headers = headers,
      body = body,
      callback = function(response)
        if response.status == 200 then
          local success, data = pcall(vim.json.decode, response.body)
          if success then
            callback(nil, {
              content = data.message and data.message.content or "",
              model = data.model,
              usage = nil, -- Ollama does not have a usage field
            })
          else
            callback('Failed to parse response JSON', nil)
          end
        else
          callback('HTTP error: ' .. response.status .. ' - ' .. (response.body or ''), nil)
        end
      end,
    })
  else
    -- Sync request
    local response = curl.post(url, {
      headers = headers,
      body = body,
    })

    if response.status == 200 then
      local success, data = pcall(vim.json.decode, response.body)
      if success then
        return {
          content = data.message and data.message.content or "",
          model = data.model,
          usage = nil,
        }
      else
        error('Failed to parse response JSON')
      end
    else
      error('HTTP error: ' .. response.status .. ' - ' .. (response.body or ''))
    end
  end
end

--- @class OllamaCompleteRequestOptions
--- @field num_predict number
--- @field temperature number 0 ~ 1 float
--- @field top_p number 0 ~ 1 float
--- @field stop string[]

--- @class OllamaCompleteRequest
--- @field model string 모델 이름 (필수)
--- @field prompt string 프롬프트 텍스트 (필수)
--- @field stream? boolean 스트리밍 여부 (선택)
--- @field keep_alive? string|number 세션 유지 시간 (선택)
--- @field options? OllamaCompleteRequestOptions 추가 옵션 (선택)

--- Completion method using Ollama's /api/generate endpoint
--- @param request OllamaCompleteRequest
--- @param callback? fun(err: string?, response: table?) Optional callback for async operation
--- @return table|nil
function M.complete(request, callback)
  local url = 'http://localhost:11434/api/generate'
  local headers = {
    ['Content-Type'] = 'application/json',
  }

  -- Input validation
  if not request then
    error('Request is required')
  end
  if type(request) ~= 'table' then
    error('Request must be a table')
  end
  if not request.model or type(request.model) ~= 'string' then
    error('Model is required and must be a string')
  end
  if not request.prompt or type(request.prompt) ~= 'string' then
    error('Prompt is required and must be a string')
  end
  if request.stream and type(request.stream) ~= 'boolean' then
    error('Stream must be a boolean')
  end
  if request.keep_alive and not (type(request.keep_alive) == 'string' or type(request.keep_alive) == 'number') then
    error('keep_alive must be a string or number')
  end

  local body = vim.json.encode({
    model = request.model,
    prompt = request.prompt,
    options = request.options,
    stream = request.stream or false,
    keep_alive = request.keep_alive,
  })

  if callback then
    -- Async request
    curl.post(url, {
      headers = headers,
      body = body,
      callback = function(response)
        if response.status == 200 then
          local success, data = pcall(vim.json.decode, response.body)
          if success then
            callback(nil, {
              content = data.response or "",
              model = data.model,
              usage = nil, -- Ollama does not have a usage field
            })
          else
            callback('Failed to parse response JSON', nil)
          end
        else
          callback('HTTP error: ' .. response.status .. ' - ' .. (response.body or ''), nil)
        end
      end,
    })
  else
    -- Sync request
    local response = curl.post(url, {
      headers = headers,
      body = body,
    })

    if response.status == 200 then
      local success, data = pcall(vim.json.decode, response.body)
      if success then
        return {
          content = data.response or "",
          model = data.model,
          usage = nil,
        }
      else
        error('Failed to parse response JSON')
      end
    else
      error('HTTP error: ' .. response.status .. ' - ' .. (response.body or ''))
    end
  end
end

return M
