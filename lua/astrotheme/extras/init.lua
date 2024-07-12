--- Automatically generate extras for theming other applications
--- Basically Copy/Paste (with some adjustments) from folke's tokyonight colorscheme:
--- https://github.com/folke/tokyonight.nvim/blob/66a272ba6cf93bf303c4b7a91b100ca0dd3ec7bd/lua/tokyonight/extra/init.lua

local M = {}

-- map of plugin name to plugin extension
--- @type table<string, {ext:string, url:string, label:string, subdir?: string, sep?:string}>
-- stylua: ignore
M.extras = {
  -- Keep all entries here aligned by the first `=` sign
  wezterm = { ext = "toml", url = "https://wezfurlong.org/wezterm/config/files.html", label = "WezTerm" },
}

function M.setup()
  local config, util = require("astrotheme").config, require "astrotheme.lib.util"

  -- map of style to style name
  local palettes = {
    astrodark = "Dark",
    astrolight = "Light",
    astromars = "Mars",
    astrojupiter = "Jupiter",
  }

  ---@type string[]
  local names = vim.tbl_keys(M.extras)
  table.sort(names)

  for _, extra in ipairs(names) do
    local info = M.extras[extra]
    local plugin = require("astrotheme.extras." .. extra)
    for palette, palette_name in pairs(palettes) do
      config.palette, config.plugin_default = palette, true
      local colors = util.set_palettes(config)
      local highlights = util.get_highlights(colors, config)
      local fname = extra
        .. (info.subdir and "/" .. info.subdir .. "/" or "")
        .. "/astrotheme"
        .. (info.sep or "_")
        .. palette
        .. "."
        .. info.ext
      colors["_upstream_url"] = "https://github.com/AstroNvim/astrotheme/raw/main/extras/" .. fname
      colors["_style_name"] = "AstroTheme " .. palette_name
      colors["_name"] = "astrotheme_" .. palette
      colors["_style"] = palette
      print("[write] " .. fname)
      M.write("extras/" .. fname, plugin.generate(colors, highlights, config))
    end
  end
end

--- Write contents to a file
---@param file string
---@param contents string
function M.write(file, contents)
  vim.fn.mkdir(vim.fn.fnamemodify(file, ":h"), "p")
  local fd = assert(io.open(file, "w+"))
  fd:write(contents)
  fd:close()
end

-- Simple string interpolation.
--
-- Example template: "${name} is ${value}"
--
---@param str string template string
---@param table table key value pairs to replace in the string
function M.template(str, table)
  return (
    str:gsub(
      "($%b{})",
      function(w) return vim.tbl_get(table, unpack(vim.split(w:sub(3, -2), ".", { plain = true }))) or w end
    )
  )
end

return M
