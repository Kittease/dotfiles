-- nvim-ts-autotag: auto-close and auto-rename HTML/JSX/XML tags via treesitter
-- https://github.com/windwp/nvim-ts-autotag

---@module 'lazy'
---@type LazySpec
return {
  "windwp/nvim-ts-autotag",
  ft = {
    "html",
    "xml",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "markdown",
  },
  opts = {},
}
