-- grug-far: project-wide find & replace with live preview
-- https://github.com/MagicDuck/grug-far.nvim

---@module 'lazy'
---@type LazySpec
return {
  "MagicDuck/grug-far.nvim",
  cmd = "GrugFar",
  keys = {
    { "<leader>sR", "<cmd>GrugFar<cr>",                            desc = "[S]earch and [R]eplace (project)" },
    { "<leader>sR", "<cmd>GrugFar<cr>", mode = "v",                desc = "[S]earch and [R]eplace selection" },
  },
  opts = {},
}
