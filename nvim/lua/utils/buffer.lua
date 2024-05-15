local function filetype_of(bufnr)
  return vim.bo[bufnr].filetype
end

local function buftype_of(bufnr)
  return vim.bo[bufnr].buftype
end

return {
  filetype_of = filetype_of,
  buftype_of = buftype_of,
}
