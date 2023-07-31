local function callback(opts)
  return {
    WhichKey = { fg = C.ui.cyan },
    WhichKeyFloat = { link = "NormalFloat" },
    WhichKeyBorder = { link = "FloatBorder" },
    WhichKeySeperator = { fg = C.ui.none_text },
    WhichKeyDesc = { fg = C.ui.purple },
    WhichKeyGroup = { fg = C.ui.blue },
    WhichKeyValue = { fg = C.ui.active_text },
  }
end

return callback
