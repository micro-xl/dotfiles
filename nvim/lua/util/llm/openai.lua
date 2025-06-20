--- @class OpenAIClient
local M = {}

local curl = require('plenary.curl')

--- @class ChatMessage
--- @field role string
--- @field content string

--- @class ChatCompletionRequest
--- @field model string
--- @field messages ChatMessage[]
--- @field temperature? number
--- @field max_tokens? number
--- @field stream? boolean

--- @class ChatCompletionResponse
--- @field id string
--- @field object string
--- @field created number
--- @field model string
--- @field choices table[]

--- Creates a new OpenAI client
--- @param api_key string The OpenAI API key
--- @return OpenAIClient
function M.new(api_key)
  local client = {}

  --- Get available models from OpenAI
  --- @param callback? fun(err: string?, models: table?) Optional callback for async operation
  --- @return table|nil
  function client.list_models(callback)
    local url = 'https://api.openai.com/v1/models'
    local headers = {
      ['Authorization'] = 'Bearer ' .. api_key,
      ['Content-Type'] = 'application/json',
    }

    if callback then
      -- Async request
      curl.get(url, {
        headers = headers,
        callback = function(response)
          if response.status == 200 then
            local success, data = pcall(vim.json.decode, response.body)
            if success then
              callback(nil, data.data)
            else
              callback('Failed to parse response JSON', nil)
            end
          else
            callback('HTTP error: ' .. response.status, nil)
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
        if success then
          return data.data
        else
          error('Failed to parse response JSON')
        end
      else
        error('HTTP error: ' .. response.status)
      end
    end
  end

  --- Send a chat completion request to OpenAI
  --- @param request ChatCompletionRequest
  --- @param callback? fun(err: string?, response: ChatCompletionResponse?) Optional callback for async operation
  --- @return ChatCompletionResponse|nil
  function client.chat_completion(request, callback)
    local url = 'https://api.openai.com/v1/chat/completions'
    local headers = {
      ['Authorization'] = 'Bearer ' .. api_key,
      ['Content-Type'] = 'application/json',
    }

    -- Input validation
    if not request then
      error('Request is required')
    end

    if type(request) ~= 'table' then
      error('Request must be a table')
    end

    if not request.messages or type(request.messages) ~= 'table' or #request.messages == 0 then
      error('Messages array is required and must not be empty')
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

      -- Validate role values
      local valid_roles = { system = true, user = true, assistant = true }
      if not valid_roles[message.role] then
        error('Message ' .. i .. ' has invalid role: ' .. message.role)
      end
    end

    -- Validate optional parameters
    if request.model and type(request.model) ~= 'string' then
      error('Model must be a string')
    end

    if request.temperature and (type(request.temperature) ~= 'number' or request.temperature < 0 or request.temperature > 2) then
      error('Temperature must be a number between 0 and 2')
    end

    if request.max_tokens and (type(request.max_tokens) ~= 'number' or request.max_tokens < 1) then
      error('Max tokens must be a positive number')
    end

    if request.stream and type(request.stream) ~= 'boolean' then
      error('Stream must be a boolean')
    end

    local body = vim.json.encode({
      model = request.model or 'gpt-3.5-turbo',
      messages = request.messages,
      temperature = request.temperature or 0.7,
      max_tokens = request.max_tokens,
      stream = request.stream or false,
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
              callback(nil, data)
            else
              callback('Failed to parse response JSON', nil)
            end
          else
            callback('HTTP error: ' .. response.status, nil)
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
          return data
        else
          error('Failed to parse response JSON')
        end
      else
        error('HTTP error: ' .. response.status)
      end
    end
  end

  return client
end

return M
