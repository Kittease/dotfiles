-- NeoCodeium: AI completion (Codeium) with virtual-text suggestions
-- https://github.com/monkoose/neocodeium

---@module 'lazy'
---@type LazySpec
return {
  "monkoose/neocodeium",
  event = "VeryLazy",
  config = function()
    local neocodeium = require("neocodeium")
    neocodeium.setup()

    vim.keymap.set("i", "<Tab>", function()
      if neocodeium.visible() then
        neocodeium.accept()
      else
        return vim.api.nvim_replace_termcodes("<Tab>", true, false, true)
      end
    end, { expr = true, silent = true, desc = "NeoCodeium accept / Tab" })
  end,
}
