local theme    = require("lualine.themes.auto")
local muted_fg = "#7a7f8b"
local muted_bg = theme.normal.c.bg

for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
  if theme[mode] and theme[mode].c then
    theme[mode].c = vim.tbl_extend("force", theme[mode].c, { fg = muted_fg, bg = muted_bg })
  end
end

require("lualine").setup({
  options = {
    icons_enabled        = false,
    theme                = theme,
    component_separators = "",
  },
  sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {
      "mode",
      "branch",
      { "filename", path = 1 },
      "diff",
    },
    lualine_x = {
      "diagnostics",
      "lsp_status",
      "encoding",
      "progress",
      "location",
    },
    lualine_y = {},
    lualine_z = {},
  },
})
