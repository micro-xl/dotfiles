--- @class LLMModule
--- @usage
--- local llm = require('util.llm')
--- local client = llm.new(llm.PROVIDERS.OPENAI, 'your-api-key')
---
--- client.list_models(function(err, models)
---   if not err then
---     print(vim.inspect(models))
---   end
--- end)
---
--- local response = client.complete({
---   model = 'gpt-3.5-turbo',
---   messages = {
---     { role = 'user', content = 'Hello, world!' }
---   },
---   temperature = 0.7,
---   max_tokens = 100
--- })
local M = {}

--- @class LLMClient
--- @field list_models fun(callback?: fun(err: string?, models: table?)): table?
--- @field complete fun(request: LLMRequest, callback?: fun(err: string?, response: LLMResponse?)): LLMResponse?

local openai_client = require('util.llm.openai')
local claude_client = require('util.llm.claude')

--- @class LLMMessage
--- @field role string
--- @field content string

--- @class LLMRequest
--- @field model string
--- @field messages LLMMessage[]
--- @field temperature? number
--- @field max_tokens? number
--- @field stream? boolean

--- @class LLMResponse
--- @field content string
--- @field model string
--- @field usage? table

--- @alias UnderlyingClient OpenAIClient | ClaudeClient

--- @enum LLMProvider
local PROVIDERS = {
  OPENAI = 'openai',
  CLAUDE = 'claude',
}


--- Creates a new LLM client
--- @param provider string The LLM provider ('openai' or 'claude')
--- @param api_key string The API key for the provider
--- @return LLMClient
function M.new(provider, api_key)
  local client = {}
  --- @type UnderlyingClient
  local underlying_client

  if provider == PROVIDERS.OPENAI then
    underlying_client = openai_client.new(api_key) --[[@as OpenAIClient]]
  elseif provider == PROVIDERS.CLAUDE then
    underlying_client = claude_client.new(api_key) --[[@as ClaudeClient]]
  else
    error('Unsupported provider: ' .. tostring(provider))
  end

  --- Get available models from the provider
  --- @param callback? function Optional callback for async operation
  --- @return table|nil
  function client.list_models(callback)
    if callback then
      -- Async request
      underlying_client.list_models(function(err, models)
        if err then
          callback(err, nil)
        else
          callback(nil, models)
        end
      end)
    else
      -- Sync request
      return underlying_client.list_models()
    end
  end

  --- Send a completion request
  --- @param request LLMRequest
  --- @param callback? function Optional callback for async operation
  --- @return LLMResponse|nil
  function client.complete(request, callback)
    -- Validate required model parameter
    if not request.model or type(request.model) ~= 'string' or request.model == '' then
      error('Model is required and must be a non-empty string')
    end

    -- Normalize request for different providers
    local normalized_request = {
      model = request.model,
      messages = request.messages,
      temperature = request.temperature,
      max_tokens = request.max_tokens,
      stream = request.stream,
    }

    -- Claude requires max_tokens
    if provider == PROVIDERS.CLAUDE and not normalized_request.max_tokens then
      normalized_request.max_tokens = 4096
    end

    local function normalize_response(response)
      if provider == PROVIDERS.OPENAI then
        return {
          content = response.choices[1].message.content,
          model = response.model,
          usage = response.usage,
        }
      elseif provider == PROVIDERS.CLAUDE then
        return {
          content = response.content[1].text,
          model = response.model,
          usage = response.usage,
        }
      end
    end

    if callback then
      -- Async request
      local method = provider == PROVIDERS.OPENAI and 'chat_completion' or 'messages'
      underlying_client[method](normalized_request, function(err, response)
        if err then
          callback(err, nil)
        else
          callback(nil, normalize_response(response))
        end
      end)
    else
      -- Sync request
      local method = provider == PROVIDERS.OPENAI and 'chat_completion' or 'messages'
      local response = underlying_client[method](normalized_request)
      return normalize_response(response)
    end
  end

  return client
end

M.PROVIDERS = PROVIDERS

return M
