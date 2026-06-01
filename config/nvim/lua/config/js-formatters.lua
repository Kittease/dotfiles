-- Per-project JS/TS formatter selection for conform.nvim.
-- Returns a list of formatters based on the project's tooling:
--   * Biome project (has biome.json/jsonc) → run `biome check --write` only
--   * Otherwise                            → run eslint_d (fix + sort imports), then prettier
return function(bufnr)
  if vim.fs.root(bufnr, { "biome.json", "biome.jsonc" }) then
    return { "biome-check" }
  end
  return { "eslint_d", "prettierd" }
end
