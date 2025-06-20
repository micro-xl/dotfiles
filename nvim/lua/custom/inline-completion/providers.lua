---@class Context
---@field uncompleted string The text to complete
---@field filetype string The file type/language
---@field filename string The file name/path

---@class ProviderConfig
---@field api_key string The API key for the provider
---@field model string The model name to use
---@field max_tokens number Maximum tokens in response

---@alias CompletionCallback fun(suggestions: string[]): nil

---@class Provider
---@field complete fun(context: Context, config: ProviderConfig, callback: CompletionCallback): nil

local M = {}

---Make a completion request to OpenAI API
---@param context Context
---@param provider_config ProviderConfig
---@param callback CompletionCallback
local function make_openai_request(context, provider_config, callback)
  local prompt = string.format([[
You are a code completion assistant. User gives a uncompleted code. The part you need to complete is labeled {{COMPLETE_HERE}} in the text. Answer the replacing_code to replace the labeled.

Filename: %s
Filetype: %s
]], context.filename, context.filetype)

  local body = vim.json.encode({
    model = provider_config.model,
    messages = {
      {
        role = "system",
        content = prompt
      },
      {
        role = "user",
        content = prompt
      }
    },
    max_tokens = provider_config.max_tokens,
    response_format = {
      type = "json_schema",
      json_schema = {
        type = "object",
        properties = {
          replacing_code = {
            type = "string"
          }
        }
      }
    },
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
      vim.notify("OpenAI Error " .. _)
      if data and #data > 0 then
        vim.notify('OpenAI API error: ' .. table.concat(data, '\n'), vim.log.levels.ERROR)
      end
    end,
  })
end

---Make a completion request to Anthropic API
---@param context Context
---@param provider_config ProviderConfig
---@param callback CompletionCallback
local function make_anthropic_request(context, provider_config, callback)
  local prompt = string.format([[
You are a code completion assistant. User gives a uncompleted code. The part you need to complete is labeled {{COMPLETE_HERE}} in the text.

Filename: %s
Filetype: %s
]], context.filename, context.filetype)

  local body = vim.json.encode({
    model = provider_config.model,
    max_tokens = provider_config.max_tokens,
    messages = {
      {
        role = "system",
        content = prompt
      },
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

---Get a provider by name
---@param name string The provider name
---@return Provider|nil
function M.get_provider(name)
  return providers[name]
end

---List all available provider names
---@return string[]
function M.list_providers()
  return vim.tbl_keys(providers)
end

return M
