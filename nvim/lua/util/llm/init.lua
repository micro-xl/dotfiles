--- @class LLMChatMessage
--- @field role string
--- @field content string

--- @class LLMRequest
--- @field model string
--- @field messages LLMChatMessage[]
--- @field temperature? number
--- @field max_tokens? number
--- @field stream? boolean

--- @class LLMResponse
--- @field content string
--- @field model string
--- @field usage? table

--- @class LLMClient
--- @field list_models fun(callback?: fun(err: string?, models: table?)): table?
--- @field chat_complete fun(request: LLMRequest, callback?: fun(err: string?, response: LLMResponse?)): LLMResponse?

local openai = require('util.llm.openai')
local claude = require('util.llm.claude')
local ollama = require('util.llm.ollama')

return {
  openai = openai,
  claude = claude,
  ollama = ollama,
}
